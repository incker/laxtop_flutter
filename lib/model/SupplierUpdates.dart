import 'package:laxtop/model/SupplierCatalog.dart';
import 'package:laxtop/model/SupplierInfo.dart';
import 'package:laxtop/storage/LazyBoxInitializer.dart';
import 'package:hive/hive.dart';

class SupplierUpdates {
  final Map<int, int> data;

  const SupplierUpdates(this.data) : assert(data != null);

  Future<Box<int>> initBox() async {
    return await Hive.openBox<int>('supplier_updates');
  }

  Future<void> save() async {
    Box<int> box = await initBox();
    Map<int, int> newUpdates = {};

    data.entries.forEach((MapEntry<int, int> mapEntry) {
      int id = mapEntry.key;
      int update = mapEntry.value;

      if (box.get(id) != update) {
        newUpdates[id] = update;
      }
    });

    if (newUpdates.isEmpty) {
      return;
    }

    LazyBox<SupplierCatalog> supplierCatalogBox =
        await SupplierCatalogBox().initBox();
    LazyBox<SupplierInfo> supplierDataBox = await SupplierInfoBox().initBox();

    for (int id in newUpdates.keys) {
      await supplierCatalogBox.delete(id).catchError((e) {});
      await supplierDataBox.delete(id).catchError((e) {});
    }

    await box.clear();
    await box.putAll(data);
    await box.close();
  }
}
