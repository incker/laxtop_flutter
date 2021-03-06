import 'package:laxtop/model/InvoiceDraft.dart';

class ApiNewInvoice {
  final int supplierId;
  final List<List<int>> products;

  ApiNewInvoice(this.supplierId, this.products);

  factory ApiNewInvoice.fromDraft(InvoiceDraft invoiceDraft) {
    final List<List<int>> products =
        invoiceDraft.data.entries.map((MapEntry<int, int> mapEntry) {
      return [mapEntry.key, mapEntry.value];
    }).toList(growable: false);

    return ApiNewInvoice(invoiceDraft.supplierHeader.id, products);
  }

  factory ApiNewInvoice.fromJson(Map<String, dynamic> json) => ApiNewInvoice(
        json['supplierId'] as int,
        (json['products'] as List)
            .map((e) =>
                (e as List).map((e) => e as int).toList(growable: false))
            .toList(growable: false),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'supplierId': supplierId,
        'products': products,
      };
}

// https://www.youtube.com/watch?v=NkUtwePWhZo&list=PLhXZp00uXBk5TSY6YOdmpzp1yG3QbFvrN&index=8
// flutter packages pub run build_runner build --delete-conflicting-outputs
