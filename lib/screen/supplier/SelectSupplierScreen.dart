import 'package:flutter/material.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/libs/showErrorDialog.dart';
import 'package:laxtop/manager/SupplierListManager.dart';
import 'package:laxtop/libs/EmptyBody.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/model/SpotSupplierSequence.dart';
import 'package:laxtop/screen/supplier/reorder_explanation_screen/ReorderHintScreen.dart';
import 'package:laxtop/screen/supplier/supplier_info_screen/SupplierInfoScreen.dart';
import 'package:hive/hive.dart';

Future<SpotSupplierSequence> getSpotSupplierSequence(BuildContext context,
    Box<SpotSupplierSequence> spotSupplierSequenceBox) async {
  return spotSupplierSequenceBox.get(BasicData().spotId) ??
      await () async {
        // nearly unreachable
        await showErrorDialog(context, 'Spot Sequence',
            errorTitle: 'Ошибка чтения списка поставщиков');
        return SpotSupplierSequence(BasicData().spotId, List(0));
      }();
}

Future<SupplierHeader> selectSupplier(BuildContext context) async {
  final Box<SpotSupplierSequence> spotSupplierSequenceBox =
      SpotSupplierSequenceBox().box();

  SpotSupplierSequence oldUserSpot =
      await getSpotSupplierSequence(context, spotSupplierSequenceBox);

  final SupplierHeader supplierHeader = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => _SelectSupplierScreen()),
  );

  SpotSupplierSequence newUserSpot =
      spotSupplierSequenceBox.get(oldUserSpot.id);

  if (newUserSpot != null && oldUserSpot.isNotEqual(newUserSpot)) {
    ApiResp<SpotSupplierSequence> apiResp =
        await Api.setSupplierSequence(newUserSpot);
    SpotSupplierSequence spotSupplierSequence = await apiResp.handle(context);
    if (spotSupplierSequence != null) {
      await spotSupplierSequenceBox.put(oldUserSpot.id, spotSupplierSequence);
    }
    await spotSupplierSequenceBox.compact();
  }

  return supplierHeader;
}

class _SelectSupplierScreen extends StatelessWidget {
  _SelectSupplierScreen({Key key}) : super(key: key);

  final spotId = BasicData().spotId;
  final Box<SpotSupplierSequence> spotSupplierSequenceBox =
      SpotSupplierSequenceBox().box();
  final Box<SupplierHeader> supplierHeadersBox = SupplierHeaderBox().box();

  void makeReorder(Reorder reorder) {
    List<int> supplierSequence =
        List.from(spotSupplierSequenceBox.get(spotId).sequence);
    supplierSequence.insert(
        reorder.newIndex, supplierSequence.removeAt(reorder.oldIndex));
    SpotSupplierSequence userSpot =
        SpotSupplierSequence(spotId, supplierSequence);
    // save store
    spotSupplierSequenceBox.put(spotId, userSpot);
  }

  void setSupplier(BuildContext context, SupplierHeader supplierHeader) {
    Navigator.pop(context, supplierHeader);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Выберите поставщика'),
        ),
        body: ValueListenableBuilder<Box<SpotSupplierSequence>>(
            valueListenable: SpotSupplierSequenceBox().listenable(),
            builder: (BuildContext context, Box<SpotSupplierSequence> box,
                Widget _child) {
              final List<int> supplierIdSequence =
                  box.get(spotId)?.sequence ?? List(0);

              if (supplierIdSequence.isEmpty) {
                return EmptyBody();
              }

              return ReorderableListView(
                children: supplierIdSequence.map((int supplierId) {
                  SupplierHeader supplierHeader =
                      supplierHeadersBox.get(supplierId) ??
                          SupplierHeader.unknown(supplierId);

                  return SupplierWidget(supplierHeader, setSupplier);
                }).toList(growable: false),
                onReorder: (int oldIndex, int newIndex) {
                  Reorder reorder =
                      Reorder(oldIndex, newIndex, supplierIdSequence.length);
                  if (reorder.needReplace) {
                    makeReorder(reorder);
                  }
                },
              );
            }));
  }
}

class SupplierWidget extends StatelessWidget {
  final SupplierHeader supplierHeader;
  final Function(BuildContext, SupplierHeader) selectSupplier;

  void navigateToSupplierInfo(
      BuildContext context, SupplierHeader supplierHeader) {
    print('navigate to supplier ${supplierHeader.name}');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SupplierInfoScreen(supplierHeader)),
    );
  }

  SupplierWidget(this.supplierHeader, this.selectSupplier)
      : super(key: ObjectKey(supplierHeader.id));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.grey[300],
            width: 1.0,
          ),
        )),
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            Expanded(
                child: Text(
              supplierHeader.name,
              style: const TextStyle(fontSize: 16.0),
            )),
            IconButton(
              onPressed: () {
                print('press');
                navigateToSupplierInfo(context, supplierHeader);
              },
              // crutch to align input to center
              icon: Icon(
                Icons.info_outline,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReorderHintScreen()));
              },
              // crutch to align input to center
              icon: Icon(
                Icons.drag_handle,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        selectSupplier(context, supplierHeader);
      },
    );
  }
}
