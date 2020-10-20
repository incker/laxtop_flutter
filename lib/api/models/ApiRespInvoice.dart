import 'package:laxtop/model/InvoiceData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ApiRespInvoice.g.dart';

@JsonSerializable()
class ApiRespInvoice {
  final int creationId;
  final int spotId;
  final int supplierId;
  final int status;
  final List<List<int>> products;

  ApiRespInvoice(
      this.creationId, this.spotId, this.supplierId, this.status, this.products)
      : assert(creationId != null),
        assert(spotId != null),
        assert(supplierId != null),
        assert(status != null),
        assert(products != null),
        assert(products.length != 0);

  Map<int, int> productsToMap() {
    Map<int, int> map = {};
    for (List<int> product in products) {
      map[product[0]] = product[1];
    }
    return map;
  }

  InvoiceData toInvoiceData() => InvoiceData(creationId, productsToMap());

  factory ApiRespInvoice.fromJson(Map<String, dynamic> json) =>
      _$ApiRespInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ApiRespInvoiceToJson(this);
}
