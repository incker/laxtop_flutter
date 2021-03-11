import 'package:laxtop/libs/dedup.dart';
import 'package:laxtop/model/InvoiceHeader.dart';

class InvoicePreviewBinary {
  final List<List<int>> data;

  const InvoicePreviewBinary(this.data);

  Map<int, InvoiceHeader> invoiceHeaderMap() {
    Map<int, InvoiceHeader> map = {};

    for (List<int> data in data) {
      InvoiceHeader invoiceHeader = InvoiceHeader(data[0], data[1], data[2]);
      map[invoiceHeader.creationId] = invoiceHeader;
    }
    return map;
  }

  factory InvoicePreviewBinary.fromJson(Map<String, dynamic> json) {
    List? list = json['data'] as List?;

    if (list == null) {
      print("json['data'] == null");
      return InvoicePreviewBinary([]);
    }

    final List<List<int>> data = list.map((innerList) {
      if (innerList == null) {
        return [0, 0, 0];
      }
      List<int> resInnerList =
          (innerList as List).map((e) => e as int).toList(growable: false);
      if (resInnerList.length != 3) {
        return [0, 0, 0];
      }
      return resInnerList;
    }).toList();

    return InvoicePreviewBinary(data);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
      };

  void sortById() {
    data.sort((arr1, arr2) => arr1[0] - arr2[0]);
  }

  void dedupById(List<List<int>> list) {
    dedupBy(list, (List<int> innerList) => innerList[0], removeLast: false);
  }
}
