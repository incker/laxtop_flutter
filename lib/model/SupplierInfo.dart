import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/model/SupplierPhone.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/storage/LazyBoxInitializer.dart';

part 'SupplierInfo.g.dart';

@HiveType(typeId: 7)
class SupplierInfo {
  @HiveField(0)
  final String about;
  @HiveField(1)
  final String address;
  @HiveField(2)
  final List<SupplierPhone> phones;

  const SupplierInfo(this.about, this.address, this.phones);

  const SupplierInfo.empty()
      : this.about = 'unknown',
        this.address = 'unknown',
        this.phones = const [];

  static Future<ApiResp<SupplierInfo>> getById(int supplierId) async {
    LazyBox<SupplierInfo> supplierInfoBox = await SupplierInfoBox().initBox();
    SupplierInfo info = await supplierInfoBox.get(supplierId);
    if (info != null) {
      return ApiResp.result(info);
    } else {
      ApiResp<SupplierInfo> apiResp = await Api.getSupplierInfo(supplierId);
      apiResp.rawResultAccess((SupplierInfo invoiceData) async {
        await supplierInfoBox.put(supplierId, info);
        await supplierInfoBox.compact();
      });
      return apiResp;
    }
  }

  factory SupplierInfo.fromJson(Map<String, dynamic> json) {
    final String about = json['about'] as String;
    final String address = json['address'] as String;
    final List<SupplierPhone> phones = (json['phones'] as List)
        .map((p) => SupplierPhone.fromJson(p))
        .toList(growable: false);

    return SupplierInfo(about, address, phones);
  }

  Map<String, dynamic> toJson() => {
        'about': about,
        'address': address,
        'phones': phones.map((p) => p.toJson()).toList(growable: false),
      };
}
