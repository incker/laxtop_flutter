import 'package:laxtop/api/ApiCore.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';

class SpotNearby {
  final int id;
  final SpotAddress address;
  final String imageUrl;

  const SpotNearby(this.id, this.address, this.imageUrl)
      : assert(id != null),
        assert(address != null),
        assert(imageUrl != null);

  factory SpotNearby.dummy() {
    return SpotNearby(1, SpotAddress.dummy(),
        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Budka9.jpg/250px-Budka9.jpg');
  }

  factory SpotNearby.fromJson(Map<String, dynamic> json) {
    return SpotNearby(
      json['id'] as int,
      SpotAddress.fromJson(json['address']),
      json['imageUrl'] as String,
    );
  }

  String networkImageUrl() {
    var res = '${ApiCore.domain}i/$imageUrl';
    print(res);
    return res;
  }
}
