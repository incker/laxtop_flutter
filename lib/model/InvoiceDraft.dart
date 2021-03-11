import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:hive/hive.dart';

part 'InvoiceDraft.g.dart';

@HiveType(typeId: 1)
class InvoiceDraft {
  @HiveField(0)
  final int supplierId;
  @HiveField(1)
  final Map<int, int> data;

  SupplierHeader get supplierHeader =>
      SupplierHeaderBox().box().get(supplierId) ??
      SupplierHeader.unknown(supplierId);

  const InvoiceDraft(this.supplierId, this.data);

  static Future<InvoiceDraft> getDraft(
      Box<InvoiceDraft> invoiceDraftBox, int supplierId) async {
    return invoiceDraftBox.get(supplierId) ?? InvoiceDraft(supplierId, {});
  }

  static Future<void> changeDraft(
      Box<InvoiceDraft> invoiceDraftBox, InvoiceDraft invoiceDraft) async {
    if (invoiceDraft.data.isEmpty) {
      InvoiceDraft.deleteDraft(invoiceDraftBox, invoiceDraft.supplierId);
    } else {
      invoiceDraftBox.put(invoiceDraft.supplierId, invoiceDraft);
    }
  }

  static void deleteDraft(Box<InvoiceDraft> invoiceDraftBox, int supplierId) {
    invoiceDraftBox.delete(supplierId);
  }

  String readablePositionCount() {
    final int positionCount = data.length;
    final int r = positionCount % 10;

    String res = positionCount.toString() + ' позици';
    if (r >= 5 || r == 0) {
      return res + 'й';
    } else {
      if (positionCount > 10 && positionCount < 20) {
        return res + 'й';
      } else if (r == 1) {
        return res + 'я';
      } else {
        return res + 'и';
      }
    }
  }
}

class InvoiceResult {
  final bool wasSent;
  final InvoiceDraft draftToSave;

  const InvoiceResult.sent(this.draftToSave) : wasSent = true;

  const InvoiceResult.draft(this.draftToSave) : wasSent = false;
}
