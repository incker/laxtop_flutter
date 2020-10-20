import 'package:laxtop/model/InvoiceDraft.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ApiNewInvoice.g.dart';

@JsonSerializable()
class ApiNewInvoice {
  final int supplierId;
  final List<List<int>> products;

  ApiNewInvoice(this.supplierId, this.products)
      : assert(supplierId != null),
        assert(products != null);

  factory ApiNewInvoice.fromDraft(InvoiceDraft invoiceDraft) {
    final List<List<int>> products =
        invoiceDraft.data.entries.map((MapEntry<int, int> mapEntry) {
      List<int> list = List(2);
      list[0] = mapEntry.key;
      list[1] = mapEntry.value;
      return list;
    }).toList(growable: false);

    return ApiNewInvoice(invoiceDraft.supplierHeader.id, products);
  }

  factory ApiNewInvoice.fromJson(Map<String, dynamic> json) =>
      _$ApiNewInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ApiNewInvoiceToJson(this);
}

// https://www.youtube.com/watch?v=NkUtwePWhZo&list=PLhXZp00uXBk5TSY6YOdmpzp1yG3QbFvrN&index=8
// flutter packages pub run build_runner build --delete-conflicting-outputs
