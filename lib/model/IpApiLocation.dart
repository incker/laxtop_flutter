import 'package:laxtop/model/GeoLocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;

class IpApiLocation {
  final String countryCode;
  final GeoLocation location;

  const IpApiLocation(this.countryCode, this.location)
      : assert(countryCode != null),
        assert(location != null);

  static Future<IpApiLocation> detectLocation() async {
    Map<String, dynamic> map = await () async {
      try {
        String body = await http
            .get('http://ip-api.com/json?fields=194')
            .then((http.Response response) => utf8.decode(response.bodyBytes));
        return json.decode(body);
      } catch (e) {
        return <String, dynamic>{};
      }
    }();

    if (map['countryCode'] == null &&
        map['lon'] == null &&
        map['lat'] == null) {
      return IpApiLocation('ua', GeoLocation.kiev());
    }

    return IpApiLocation(
        map['countryCode'] as String, GeoLocation(map['lon'], map['lat']));
  }
}
