import 'package:hive/hive.dart';

part 'InvoiceData.g.dart';

@HiveType(typeId: 0)
class InvoiceData {
  @HiveField(0)
  final int creationId;
  @HiveField(1)
  final Map<int, int> data;

  const InvoiceData(this.creationId, this.data);
}
