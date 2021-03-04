import 'package:laxtop/libs/dedup.dart';
import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/model/InvoicePreviewBinary.dart';

class InvoicePreviewList {
  final List<InvoiceHeader> data;

  InvoicePreviewList(this.data) : assert(data != null);

  static Future<InvoicePreviewList> fromInvoicePreviewBinary(
      InvoicePreviewBinary invoicePreviewBinary) async {
    return InvoicePreviewList([]);
  }

  InvoicePreviewBinary toInvoicePreviewBinary() {
    return InvoicePreviewBinary(data.map((InvoiceHeader invoicePreview) {
      return <int>[
        invoicePreview.creationId,
        invoicePreview.supplierId,
        invoicePreview.positionCount
      ];
    }).toList());
  }

  void sortById() {
    data.sort((a, b) => a.creationId - b.creationId);
  }

  void dedupById() {
    dedupBy(data, (InvoiceHeader innerList) => innerList.creationId,
        removeLast: false);
  }
}
