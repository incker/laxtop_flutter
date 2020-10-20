import 'package:laxtop/model/PromoStatus.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as p;

part 'ApiSupplierPromo.g.dart';

@JsonSerializable()
class ApiSupplierPromo {
  final int id;
  final int supplierId;
  final String url;

  String filenameInCache() {
    // ext is already with dot
    return id.toString() + p.extension(url);
  }

  SupplierPromo toSupplierPromo(PromoStatus status) {
    return SupplierPromo(id, supplierId, url, status);
  }

  const ApiSupplierPromo(this.id, this.supplierId, this.url)
      : assert(id != null),
        assert(supplierId != null),
        assert(url != null);

  factory ApiSupplierPromo.fromJson(Map<String, dynamic> json) =>
      _$ApiSupplierPromoFromJson(json);

  Map<String, dynamic> toJson() => _$ApiSupplierPromoToJson(this);
}
