import 'package:hive/hive.dart';

part 'SpotAddress.g.dart';

@HiveType(typeId: 13)
class SpotAddress {
  @HiveField(0)
  final String address;
  @HiveField(1)
  final String spotType;
  @HiveField(2)
  final String spotName;

  const SpotAddress(this.address, this.spotType, this.spotName)
      : assert(address != null),
        assert(spotType != null),
        assert(spotName != null);

  factory SpotAddress.dummy() {
    return SpotAddress('Автомагистральная 32А', 'Киоск', '"Чебурум"');
  }

  factory SpotAddress.fromJson(Map<String, dynamic> json) {
    return SpotAddress(
      json['address'] as String,
      json['spotType'] as String,
      json['spotName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'spotType': spotType,
        'spotName': spotName,
      };

  // костыль, но пока норм
  bool isValid() => address.isNotEmpty && spotType.isNotEmpty;
}
