import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/model/GeoLocation.dart';
import 'package:laxtop/model/spot/NewSpot.dart';
import 'package:laxtop/model/spot/Spot.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';
import 'package:laxtop/model/spot/SpotNearby.dart';

class SelectedSpot {
  final SpotNearby spot;
  final SpotAddress newSpotAddress;

  SelectedSpot.selectSpot(this.spot)
      : assert(spot != null),
        newSpotAddress = null;

  SelectedSpot.newSpot(this.newSpotAddress)
      : assert(newSpotAddress != null),
        spot = null;

  Future<ApiResp<Spot>> submitUserSpot(GeoLocation location) async {
    if (spot != null) {
      return Api.addExistingSpot(spot.id, location);
    }

    if (newSpotAddress != null) {
      return Api.setNewSpot(NewSpot(newSpotAddress, location));
    }

    throw 'Spot is not set';
  }
}
