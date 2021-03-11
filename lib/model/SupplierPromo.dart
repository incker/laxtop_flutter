import 'package:laxtop/api/ApiCore.dart';
import 'package:laxtop/model/ImageIdHandler.dart';
import 'package:laxtop/model/PromoStatus.dart';
import 'package:hive/hive.dart';

part 'SupplierPromo.g.dart';

@HiveType(typeId: 10)
class SupplierPromo extends ImageIdHandler {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int supplierId;
  @HiveField(2)
  final int imageId;
  @HiveField(3)
  final PromoStatus status;

  SupplierPromo(this.id, this.supplierId, this.imageId, this.status);

  SupplierPromo copyWith({
    int? id,
    int? supplierId,
    int? imageId,
    PromoStatus? status,
  }) {
    return SupplierPromo(id ?? this.id, supplierId ?? this.supplierId,
        imageId ?? this.imageId, status ?? this.status);
  }

  bool isFresh() => status == PromoStatus.fresh;

  bool isDownloaded() => status == PromoStatus.downloaded;

  bool isWatched() => status == PromoStatus.watched;

  String get fullUrl => '${ApiCore.domain}i/$imageId';

  static int countDownloadedPromos(Box<SupplierPromo> box) {
    int count = 0;
    for (SupplierPromo promo in box.values) {
      if (promo.isDownloaded()) {
        count += 1;
      }
    }
    return count;
  }

  int getImageId() => imageId;

  static int countNotFreshPromos(Box<SupplierPromo> box) {
    int count = 0;
    for (SupplierPromo promo in box.values) {
      if (!promo.isFresh()) {
        count += 1;
      }
    }
    return count;
  }
}
