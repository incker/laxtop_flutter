import 'package:laxtop/model/InvoiceData.dart';

class ApiRespInvoice {
  final int creationId;
  final int spotId;
  final int supplierId;
  final int status;
  final List<List<int>> products;

  ApiRespInvoice(
      this.creationId, this.spotId, this.supplierId, this.status, this.products);

  Map<int, int> productsToMap() {
    Map<int, int> map = {};
    for (List<int> product in products) {
      map[product[0]] = product[1];
    }
    return map;
  }

  InvoiceData toInvoiceData() => InvoiceData(creationId, productsToMap());

  factory ApiRespInvoice.fromJson(Map<String, dynamic> json) => ApiRespInvoice(
        json['creationId'] as int,
        json['spotId'] as int,
        json['supplierId'] as int,
        json['status'] as int,
        (json['products'] as List)
            .map((e) =>
                (e as List).map((e) => e as int).toList(growable: false))
            .toList(growable: false),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'creationId': creationId,
        'spotId': spotId,
        'supplierId': supplierId,
        'status': status,
        'products': products,
      };
}
