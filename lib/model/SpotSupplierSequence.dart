import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

part 'SpotSupplierSequence.g.dart';

@HiveType(typeId: 5)
class SpotSupplierSequence {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final List<int> sequence;

  bool isEqual(SpotSupplierSequence spotSequence) =>
      id == spotSequence.id &&
      ListEquality().equals(sequence, spotSequence.sequence);

  bool isNotEqual(SpotSupplierSequence spotSequence) => !isEqual(spotSequence);

  const SpotSupplierSequence(this.id, this.sequence)
      : assert(id != null),
        assert(sequence != null);

  factory SpotSupplierSequence.fromJson(Map<String, dynamic> json) {
    List<int> sequence = (json['sequence'] as List)?.cast<int>();
    return SpotSupplierSequence(json['id'], sequence);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sequence': sequence,
      };
}
