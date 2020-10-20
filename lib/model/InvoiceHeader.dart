import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/model/InvoiceData.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/storage/LazyBoxInitializer.dart';
import 'package:hive/hive.dart';

part 'InvoiceHeader.g.dart';

@HiveType(typeId: 2)
class InvoiceHeader {
  @HiveField(0)
  final int creationId;
  @HiveField(1)
  final int supplierId;
  @HiveField(2)
  final int positionCount;

  SupplierHeader supplierHeader() {
    return SupplierHeaderBox().box().get(supplierId) ??
        SupplierHeader.unknown(supplierId);
  }

  String supplierName() {
    SupplierHeader supplierHeader = SupplierHeaderBox().box().get(supplierId) ??
        SupplierHeader.unknown(supplierId);
    return supplierHeader.name;
  }

  const InvoiceHeader(this.creationId, this.supplierId, this.positionCount)
      : assert(creationId != null),
        assert(supplierId != null),
        assert(positionCount != null);

  String readablePositionCount() {
    int r = positionCount % 10;
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

  Future<ApiResp<InvoiceData>> getInvoiceData() async {
    LazyBox<InvoiceData> lazyBox = await InvoiceDataBox().initBox();

    InvoiceData invoiceData = await lazyBox.get(creationId);
    if (invoiceData == null) {
      ApiResp<InvoiceData> apiResp = await Api.getInvoiceData(creationId);
      apiResp.rawResultAccess((InvoiceData invoiceData) async {
        await lazyBox.put(creationId, invoiceData);
        await lazyBox.compact();
      });
      return apiResp;
    } else {
      return ApiResp.result(invoiceData);
    }
  }
}

bool invoiceHeaderSortByDate(InvoiceHeader a, InvoiceHeader b) =>
    (a.creationId < b.creationId);
