import 'package:laxtop/model/Unit.dart';
import 'package:hive/hive.dart';

part 'Product.g.dart';

@HiveType(typeId: 3)
class Product {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final Unit unit;
  @HiveField(3)
  final bool deleted;

  const Product(this.id, this.name, this.unit, this.deleted);

  static const List<Unit> units = Unit.values;

  bool contains(String filter) => name.contains(filter);

  factory Product.unknown(int id) {
    final String name = 'Product #' + id.toString();
    return Product(id, name, Unit.piece, false);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['id'], json['name'], units[json['unit']!], false);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit': unit.index,
        'deleted': deleted,
      };
}
