import 'package:laxtop/model/spot/Spot.dart';
import 'package:laxtop/storage/BasicData.dart';

class AuthorizedUserData {
  final String phone;
  final String token;
  final bool licenseAccepted;
  final String name;
  final List<Spot> spots;

  const AuthorizedUserData(
      this.phone, this.token, this.licenseAccepted, this.name, this.spots)
      : assert(phone != null),
        assert(token != null),
        assert(licenseAccepted != null),
        assert(name != null),
        assert(spots != null);

  Future<void> saveToApplication(BasicData basicData) async {
    await basicData.put(
      token: token,
      phone: phone,
      name: name,
      spotId: spots.isEmpty ? 0 : spots[0].id ?? 0,
    );
  }

  factory AuthorizedUserData.fromJson(Map<String, dynamic> json) {
    return AuthorizedUserData(
      json['phone'] as String,
      json['token'] as String,
      json['licenseAccepted'] as bool,
      json['name'] as String,
      (json['spots'] as List)
          .map((e) => Spot.fromJson(e))
          .toList(growable: false),
    );
  }
}
