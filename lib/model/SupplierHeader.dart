import 'package:hive/hive.dart';

part 'SupplierHeader.g.dart';

@HiveType(typeId: 8)
class SupplierHeader {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  /*
  static Box<SupplierHeader> box;

  static Future<Box<SupplierHeader>> initBox() async {
    box = await SupplierHeaderBox().initBox();
    return box;
  }
   */
  const SupplierHeader(this.id, this.name);

  factory SupplierHeader.unknown(int id) {
    return SupplierHeader(id, 'Supplier #' + id.toString());
  }

  factory SupplierHeader.fromJson(Map<String, dynamic> json) {
    return SupplierHeader(json['id'] as int, json['name'] as String);
  }
}
