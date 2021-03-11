import 'package:laxtop/model/ImageIdHandler.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';

class SpotNearby extends ImageIdHandler {
  final int id;
  final SpotAddress address;
  final int imageId;

  SpotNearby(this.id, this.address, this.imageId);

  factory SpotNearby.dummy() => SpotNearby(1, SpotAddress.dummy(), 0);

  factory SpotNearby.fromJson(Map<String, dynamic> json) {
    return SpotNearby(
      json['id'] as int,
      SpotAddress.fromJson(json['address']),
      json['imageId'] as int,
    );
  }

  int getImageId() => imageId;
}
