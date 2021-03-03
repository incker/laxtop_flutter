import 'package:laxtop/model/ImageId.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';

class SpotNearby {
  final int id;
  final SpotAddress address;
  final ImageId imageId;

  const SpotNearby(this.id, this.address, this.imageId)
      : assert(id != null),
        assert(address != null),
        assert(imageId != null);

  factory SpotNearby.dummy() => SpotNearby(1, SpotAddress.dummy(), ImageId(0));

  factory SpotNearby.fromJson(Map<String, dynamic> json) {
    return SpotNearby(
      json['id'] as int,
      SpotAddress.fromJson(json['address']),
      ImageId(json['imageId'] as int),
    );
  }
}
