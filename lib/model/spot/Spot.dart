import 'package:laxtop/model/ImageIdHandler.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';
import 'package:laxtop/model/spot/SpotOrg.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';

part 'Spot.g.dart';

@HiveType(typeId: 12)
class Spot extends ImageIdHandler {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final SpotAddress address;
  @HiveField(2)
  final SpotOrg spotOrg;
  @HiveField(3)
  final int imageId;

  Spot(this.id, this.address, this.spotOrg, this.imageId);

  bool hasOrganization() =>
      spotOrg.orgName.isNotEmpty && spotOrg.orgType.isNotEmpty;

  bool hasNotOrganization() =>
      spotOrg.orgName.isEmpty && spotOrg.orgType.isEmpty;

  Spot.empty(this.id)
      : this.address = SpotAddress.empty(),
        this.spotOrg = SpotOrg.empty(),
        this.imageId = 0;

  static get currentSpot =>
      SpotBox().box().get(BasicData().spotId) ?? Spot.empty(BasicData().spotId);

  int getImageId() => imageId;

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      json['id'] as int,
      SpotAddress.fromJson(json['address']),
      SpotOrg.fromJson(json['spotOrg']),
      json['imageId'] as int,
    );
  }
}
