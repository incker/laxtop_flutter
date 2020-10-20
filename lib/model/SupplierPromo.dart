import 'package:laxtop/api/ApiCore.dart';
import 'package:laxtop/model/PromoStatus.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;

part 'SupplierPromo.g.dart';

@HiveType(typeId: 10)
class SupplierPromo {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int supplierId;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final PromoStatus status;

  SupplierPromo copyWith({
    int id,
    int supplierId,
    String url,
    PromoStatus status,
  }) {
    return SupplierPromo(id ?? this.id, supplierId ?? this.supplierId,
        url ?? this.url, status ?? this.status);
  }

  bool isFresh() => status == PromoStatus.fresh;

  bool isDownloaded() => status == PromoStatus.downloaded;

  bool isWatched() => status == PromoStatus.watched;

  String get fullUrl => '${ApiCore.domain}i/$url';

  static int countDownloadedPromos(Box<SupplierPromo> box) {
    int count = 0;
    for (SupplierPromo promo in box.values) {
      if (promo.isDownloaded()) {
        count += 1;
      }
    }
    return count;
  }

  static int countNotFreshPromos(Box<SupplierPromo> box) {
    int count = 0;
    for (SupplierPromo promo in box.values) {
      if (!promo.isFresh()) {
        count += 1;
      }
    }
    return count;
  }

  const SupplierPromo(this.id, this.supplierId, this.url, this.status)
      : assert(id != null),
        assert(supplierId != null),
        assert(url != null);

  String filenameInCache() {
    // ext is already with dot
    return id.toString() + p.extension(url);
  }
}
