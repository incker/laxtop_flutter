import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoLocation {
  // first lng than lat (sequence as in server geo_types crate)
  final double lng;
  final double lat;

  const GeoLocation(this.lng, this.lat)
      : assert(lat != null),
        assert(lng != null);

  // костыль, но пока норм
  factory GeoLocation.kiev() {
    return GeoLocation(30.51667, 50.43333);
  }

  factory GeoLocation.fromLatLng(LatLng lngLat) {
    return GeoLocation(lngLat.longitude, lngLat.latitude);
  }

  LatLng toLatLng() => LatLng(lat, lng);

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      json['lng'] as double,
      json['lat'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
        'lng': lng,
        'lat': lat,
      };
}
