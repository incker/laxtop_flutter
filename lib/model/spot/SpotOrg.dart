import 'package:hive/hive.dart';

part 'SpotOrg.g.dart';

@HiveType(typeId: 14)
class SpotOrg {
  @HiveField(0)
  final String orgType;
  @HiveField(1)
  final String orgName;

  const SpotOrg(this.orgType, this.orgName)
      : assert(orgType != null),
        assert(orgName != null);

  factory SpotOrg.dummy() {
    return SpotOrg('ФОП', 'Иванова И.И');
  }

  factory SpotOrg.fromJson(Map<String, dynamic> json) {
    return SpotOrg(
      json['orgType'] as String,
      json['orgName'] as String,
    );
  }

  // костыль, но пока норм
  isValid() => orgType.isNotEmpty && orgName.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'orgType': orgType,
        'orgName': orgName,
      };
}
