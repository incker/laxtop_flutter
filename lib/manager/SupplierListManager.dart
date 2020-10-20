import 'package:laxtop/manager/Manager.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:rxdart/rxdart.dart';

class SupplierListManager extends Manager {
  // todo spot id ?
  bool orderChanged = false;

  List<SupplierHeader> suppliers;

  final BehaviorSubject<List<SupplierHeader>> _suppliers =
      BehaviorSubject<List<SupplierHeader>>();

  Stream<List<SupplierHeader>> get suppliers$ => _suppliers.stream;

  factory SupplierListManager(List<SupplierHeader> suppliers) {
    final SupplierListManager supplierListManager =
        SupplierListManager._internal(suppliers);
    supplierListManager.sendData();
    return supplierListManager;
  }

  SupplierListManager._internal(this.suppliers);

  void makeReorder(Reorder reorder) {
    orderChanged = true;
    suppliers.insert(reorder.newIndex, suppliers.removeAt(reorder.oldIndex));
    sendData();
  }

  void sendData() {
    _suppliers.add(suppliers);
  }

  void dispose() {
    _suppliers.close();
  }
}

class Reorder {
  final int oldIndex;
  final int newIndex;
  final bool needReplace;

  factory Reorder(int oldIndex, int newIndex, int listLength) {
    if (newIndex > listLength) {
      newIndex = listLength;
    }
    if (oldIndex < newIndex) {
      --newIndex;
    }
    return Reorder._internal(oldIndex, newIndex, (oldIndex != newIndex));
  }

  Reorder._internal(this.oldIndex, this.newIndex, this.needReplace);
}
