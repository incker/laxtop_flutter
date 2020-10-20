import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/model/InvoicePreviewBinary.dart';
import 'package:laxtop/model/SpotSupplierSequence.dart';
import 'package:laxtop/model/SupplierHeader.dart';

class UserData {
  final List<SpotSupplierSequence> spots;
  final List<SupplierHeader> suppliers;
  final InvoicePreviewBinary lastInvoicesPreview;
  final List<List<int>> suppliersShift;
  final List<int> promoIds;

  Map<int, SupplierHeader> supplierHeaderMap() {
    Map<int, SupplierHeader> map = {};

    for (SupplierHeader supplierHeader in suppliers) {
      map[supplierHeader.id] = supplierHeader;
    }
    return map;
  }

  Map<int, InvoiceHeader> invoiceHeaderMap() =>
      lastInvoicesPreview.invoiceHeaderMap();

  Map<int, SpotSupplierSequence> spotSupplierSequenceMap() {
    Map<int, SpotSupplierSequence> map = {};

    for (SpotSupplierSequence spotSupplierSequence in spots) {
      map[spotSupplierSequence.id] = spotSupplierSequence;
    }
    return map;
  }

  Map<int, int> supplierUpdatesMap() {
    Map<int, int> map = {};
    for (List<int> supplierShift in suppliersShift) {
      map[supplierShift[0]] = supplierShift[1];
    }
    return map;
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    List<SpotSupplierSequence> spots = [];
    List<SupplierHeader> suppliers = [];

    (json['spots'] as List).forEach((spot) {
      spots.add(SpotSupplierSequence.fromJson(spot));
    });

    (json['suppliers'] as List).forEach((supplier) {
      suppliers.add(SupplierHeader.fromJson(supplier));
    });

    final List<List<int>> supplierUpdates = (json['suppliersShift'] as List)
        ?.map((entries) =>
            (entries as List)?.map((e) => e as int)?.toList(growable: false))
        ?.toList(growable: false);

    final List<int> promoIds = (json['promoIds'] as List)
        ?.map((id) => id as int)
        ?.toList(growable: false);

    return UserData(spots, suppliers, supplierUpdates,
        InvoicePreviewBinary.fromJson(json['lastInvoicesPreview']), promoIds);
  }

  const UserData(this.spots, this.suppliers, this.suppliersShift,
      this.lastInvoicesPreview, this.promoIds)
      : assert(spots != null),
        assert(suppliers != null),
        assert(suppliersShift != null),
        assert(lastInvoicesPreview != null),
        assert(promoIds != null);
}
