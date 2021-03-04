import 'package:laxtop/manager/Manager.dart';
import 'package:laxtop/model/Product.dart';
import 'package:rxdart/rxdart.dart';

class InvoiceDataManager extends Manager {
  Map<int, int> data = {};
  final BehaviorSubject<Map<int, int>> currentData =
      BehaviorSubject<Map<int, int>>();

  Stream<Map<int, int>> get stream$ => currentData.stream;

  int? getAmount(Product product) => data[product.id];

  void setAmount(Product product, int amount) {
    if (amount < 1) {
      if (data.containsKey(product.id)) {
        data.remove(product.id);
        sendData();
      }
    } else if (data[product.id] != amount) {
      data[product.id] = amount;
      sendData();
    }
  }

  void setData(Map<int, int> newData) {
    data = newData;
    sendData();
  }

  void sendData() {
    currentData.add(data);
  }

  factory InvoiceDataManager(Map<int, int> data) {
    final InvoiceDataManager invoiceDataManager =
        InvoiceDataManager._internal(data);
    invoiceDataManager.sendData();
    return invoiceDataManager;
  }

  InvoiceDataManager._internal(this.data);

  Future<T> manage<T>(Future<T> Function(InvoiceDataManager) func) async {
    T data = await func(this);
    this.dispose();
    return data;
  }

  void dispose() {
    currentData.close();
  }
}
