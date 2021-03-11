import 'package:laxtop/model/ImageId.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';
import 'package:laxtop/model/spot/SpotOrg.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';

part 'Spot.g.dart';

@HiveType(typeId: 12)
class Spot {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final SpotAddress address;
  @HiveField(2)
  final SpotOrg spotOrg;
  @HiveField(3)
  final ImageId imageId;

  const Spot(this.id, this.address, this.spotOrg, this.imageId);

  bool hasOrganization() =>
      spotOrg.orgName.isNotEmpty && spotOrg.orgType.isNotEmpty;

  bool hasNotOrganization() =>
      spotOrg.orgName.isEmpty && spotOrg.orgType.isEmpty;

  // todo empty spot?

  static Spot get currentSpot => SpotBox().box().get(BasicData().spotId);

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      json['id'] as int,
      SpotAddress.fromJson(json['address']),
      SpotOrg.fromJson(json['spotOrg']),
      ImageId(json['imageId'] as int),
    );
  }
}
