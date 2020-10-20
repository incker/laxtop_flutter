import 'package:laxtop/model/InvoiceData.dart';
import 'package:laxtop/model/SupplierCatalog.dart';
import 'package:laxtop/model/SupplierInfo.dart';
import 'package:hive/hive.dart';

class SupplierCatalogBox extends LazyBoxInitializer<SupplierCatalog> {
  String boxName() => 'supplier_catalog';
}

class SupplierInfoBox extends LazyBoxInitializer<SupplierInfo> {
  String boxName() => 'supplier_info';
}

class InvoiceDataBox extends LazyBoxInitializer<InvoiceData> {
  String boxName() => 'invoice_data';
}

abstract class LazyBoxInitializer<T> {
  String boxName();

  static List<LazyBoxInitializer> boxes() => [
        SupplierCatalogBox(),
        SupplierInfoBox(),
        InvoiceDataBox(),
      ];

  Future<LazyBox<T>> initBox() async {
    print('initBox: ' + boxName());
    return await Hive.openLazyBox(boxName());
  }

  LazyBox<T> lazyBox() {
    print('BOX: ' + boxName());
    return Hive.lazyBox(boxName());
  }

  Future<T> get(int key) async {
    LazyBox<T> lazyBox = await initBox();
    return await lazyBox.get(key);
  }

// void dispose();
}
