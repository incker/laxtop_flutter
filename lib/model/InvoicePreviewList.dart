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
      List<int> list = List(3);

      list[0] = invoicePreview.creationId;
      list[1] = invoicePreview.supplierId;
      list[2] = invoicePreview.positionCount;

      return list;
    }));
  }

  void sortById() {
    data.sort((a, b) => a.creationId - b.creationId);
  }

  void dedupById() {
    dedupBy(data, (InvoiceHeader innerList) => innerList.creationId,
        removeLast: false);
  }
}
