import 'package:laxtop/model/ImageId.dart';
import 'package:laxtop/model/PromoStatus.dart';
import 'package:laxtop/model/SupplierPromo.dart';

class ApiSupplierPromo {
  final int id;
  final int supplierId;
  final ImageId imageId;

  String filenameInCache() {
    return '$id-$imageId.jpg';
  }

  SupplierPromo toSupplierPromo(PromoStatus status) {
    return SupplierPromo(id, supplierId, imageId, status);
  }

  const ApiSupplierPromo(this.id, this.supplierId, this.imageId)
      : assert(id != null),
        assert(supplierId != null),
        assert(imageId != null);

  factory ApiSupplierPromo.fromJson(Map<String, dynamic> json) =>
      ApiSupplierPromo(
        json['id'] as int,
        json['supplierId'] as int,
        ImageId(json['imageId'] as int),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'supplierId': supplierId,
        'imageId': imageId.id,
      };
}
