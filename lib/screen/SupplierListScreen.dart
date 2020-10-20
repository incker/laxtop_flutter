import 'package:flutter/material.dart';
import 'package:laxtop/libs/EmptyBody.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/model/SpotSupplierSequence.dart';
import 'package:laxtop/screen/supplier/supplier_info_screen/SupplierInfoScreen.dart';

class SupplierListScreen extends StatelessWidget {
  final List<SupplierHeader> activeSupplierList;
  final List<SupplierHeader> otherSupplierList;

  factory SupplierListScreen() {
    List<List<SupplierHeader>> suppliers = getSupplierSequence();
    return SupplierListScreen._internal(suppliers[0], suppliers[1]);
  }

  SupplierListScreen._internal(this.activeSupplierList, this.otherSupplierList)
      : super(key: ObjectKey('SupplierListScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Доступные поставщики'),
        ),
        body: (activeSupplierList.isEmpty)
            ? EmptyBody()
            : ListView(children: [
                for (SupplierHeader supplierHeader in activeSupplierList)
                  SupplierWidget(supplierHeader),
                if (otherSupplierList.isNotEmpty)
                  Center(
                    child: Text(
                      'Другие',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ),
                for (SupplierHeader supplierHeader in otherSupplierList)
                  SupplierWidget(supplierHeader),
              ]));
  }
}

Map<int, SupplierHeader> getSupplierHeaderMap() {
  final Iterable<SupplierHeader> supplierHeaders =
      SupplierHeaderBox().box().values;
  Map<int, SupplierHeader> map = {};
  for (SupplierHeader supplierHeader in supplierHeaders) {
    map[supplierHeader.id] = supplierHeader;
  }
  return map;
}

List<List<SupplierHeader>> getSupplierSequence() {
  final List<SpotSupplierSequence> spotSupplierSequences =
      SpotSupplierSequenceBox().box().values.toList(growable: false);

  if (spotSupplierSequences.isEmpty) {
    return List<List<SupplierHeader>>.filled(2, List(0), growable: false);
  }

  if (spotSupplierSequences.length == 1) {
    return idsToSupplierHeaders(spotSupplierSequences[0].sequence);
  }

  return getSuppliersAverageSequence(spotSupplierSequences);
}

List<List<SupplierHeader>> idsToSupplierHeaders(List<int> supplierSequence) {
  Map<int, SupplierHeader> supplierHeaderMap = getSupplierHeaderMap();

  Set<int> activeSupplierIds = supplierSequence.toSet();

  List<SupplierHeader> otherSupplierList = [];

  for (int supplierId in supplierHeaderMap.keys) {
    if (!activeSupplierIds.contains(supplierId)) {
      otherSupplierList.add(supplierHeaderMap[supplierId]);
    }
  }

  List<SupplierHeader> activeSupplierList =
      supplierSequence.map((int supplierId) {
    return supplierHeaderMap[supplierId] ?? SupplierHeader.unknown(supplierId);
  }).toList(growable: false);

  otherSupplierList.map((e) => e).toList(growable: false);

  return [activeSupplierList, otherSupplierList];
}

List<List<SupplierHeader>> getSuppliersAverageSequence(
    List<SpotSupplierSequence> spotSupplierSequences) {
  // supplierId -> positions
  Map<int, List<int>> activeSuppliers = {};

  for (SpotSupplierSequence spotSupplierSequence in spotSupplierSequences) {
    final List<int> list = spotSupplierSequence.sequence;
    for (int i = 0, l = list.length; i < l; i++) {
      int supplierId = list[i];
      if (activeSuppliers.containsKey(supplierId)) {
        activeSuppliers[supplierId].add(i);
      } else {
        activeSuppliers[supplierId] = [i];
      }
    }
  }

  List<List<int>> sequenceList = [];

  final spotCount = spotSupplierSequences.length;

  for (MapEntry<int, List<int>> entry in activeSuppliers.entries) {
    int supplierId = entry.key;
    List<int> supplierPositions = entry.value;

    int summaryPosition = supplierPositions.reduce((a, b) => a + b);

    if (spotCount != supplierPositions.length) {
      summaryPosition =
          (summaryPosition * (spotCount / supplierPositions.length)).round();
    }
    sequenceList.add([supplierId, summaryPosition]);
  }

  sequenceList.sort((List<int> arr1, List<int> arr2) => arr1[1] - arr2[1]);

  List<int> supplierSequence = sequenceList
      .map((List<int> innerList) => innerList[0])
      .toList(growable: false);

  return idsToSupplierHeaders(supplierSequence);
}

class SupplierWidget extends StatelessWidget {
  final SupplierHeader supplierHeader;

  void navigateToSupplierInfo(
      BuildContext context, SupplierHeader supplierHeader) {
    print('navigate to supplier ${supplierHeader.name}');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SupplierInfoScreen(supplierHeader)),
    );
  }

  SupplierWidget(this.supplierHeader)
      : super(key: ObjectKey(supplierHeader.id));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        supplierHeader.name,
        style: const TextStyle(fontSize: 20.0),
      ),
      trailing: IconButton(
        onPressed: () {
          navigateToSupplierInfo(context, supplierHeader);
        },
        icon: Icon(
          Icons.info_outline,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        navigateToSupplierInfo(context, supplierHeader);
      },
    );
  }
}
