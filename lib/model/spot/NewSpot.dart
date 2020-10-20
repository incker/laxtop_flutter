import 'package:laxtop/model/GeoLocation.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';

class NewSpot {
  final SpotAddress address;
  final GeoLocation location;

  NewSpot(this.address, this.location)
      : assert(address != null),
        assert(location != null);

  Map<String, dynamic> toJson() => {
        'address': address.toJson(),
        'location': location.toJson(),
      };
}
