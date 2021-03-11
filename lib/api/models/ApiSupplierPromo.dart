import 'package:laxtop/model/ImageIdHandler.dart';
import 'package:laxtop/model/PromoStatus.dart';
import 'package:laxtop/model/SupplierPromo.dart';

class ApiSupplierPromo extends ImageIdHandler {
  final int id;
  final int supplierId;
  final int imageId;

  String filenameInCache() {
    // TODO
    return '$id-$imageId.jpg';
  }

  int getImageId() => imageId;

  SupplierPromo toSupplierPromo(PromoStatus status) {
    return SupplierPromo(id, supplierId, imageId, status);
  }

  ApiSupplierPromo(this.id, this.supplierId, this.imageId);

  factory ApiSupplierPromo.fromJson(Map<String, dynamic> json) =>
      ApiSupplierPromo(
        json['id'] as int,
        json['supplierId'] as int,
        json['imageId'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'supplierId': supplierId,
        'imageId': imageId,
      };
}
