import 'package:hive/hive.dart';

part 'SpotOrg.g.dart';

@HiveType(typeId: 14)
class SpotOrg {
  @HiveField(0)
  final String orgType;
  @HiveField(1)
  final String orgName;

  const SpotOrg(this.orgType, this.orgName);

  SpotOrg.empty()
      : this.orgType = '',
        this.orgName = '';

  SpotOrg.dummy()
      : this.orgType = 'ФОП',
        this.orgName = 'Иванова И.И';

  isValid() => orgType.isNotEmpty && orgName.isNotEmpty;

  factory SpotOrg.fromJson(Map<String, dynamic> json) {
    return SpotOrg(
      json['orgType'] as String,
      json['orgName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'orgType': orgType,
        'orgName': orgName,
      };
}
