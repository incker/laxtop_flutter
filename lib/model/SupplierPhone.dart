import 'package:hive/hive.dart';

part 'SupplierPhone.g.dart';

@HiveType(typeId: 9)
class SupplierPhone {
  @HiveField(0)
  final String position;
  @HiveField(1)
  final String number;

  const SupplierPhone(this.position, this.number);

  factory SupplierPhone.fromJson(Map<String, dynamic> json) {
    final String position = json['position'] as String;
    final String number = json['number'] as String;

    return SupplierPhone(position, number);
  }

  Map<String, dynamic> toJson() => {
        'position': position,
        'number': number,
      };
}
