import 'package:hive/hive.dart';

part 'Unit.g.dart';

// do not change priority
@HiveType(typeId: 11)
enum Unit {
  @HiveField(0)
  other,
  @HiveField(1)
  piece,
}
