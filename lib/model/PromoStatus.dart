import 'package:hive/hive.dart';

part 'PromoStatus.g.dart';

@HiveType(typeId: 4)
enum PromoStatus {
  @HiveField(0)
  fresh,
  @HiveField(1)
  downloaded,
  @HiveField(2)
  watched,
}
