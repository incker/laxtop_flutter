import 'package:flutter/material.dart';
import 'package:laxtop/libs/FutureBuilderWrapper.dart';
import 'package:laxtop/libs/PreCache.dart';
import 'package:laxtop/model/InvoiceData.dart';
import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/model/Product.dart';
import 'package:laxtop/model/SupplierCatalog.dart';
import 'package:laxtop/model/Unit.dart';
import 'package:laxtop/screen/invoice/widgets/ProductAmountWidget.dart';
import 'package:laxtop/screen/orders_screen/widgets/InvoiceDate.dart';

class ProcessedInvoiceScreen extends StatelessWidget {
  final PreCache<Widget> preCache = PreCache<Widget>();
  final InvoiceHeader invoiceHeader;

  Future<Map<Product, int>> _invoiceData(BuildContext context) async {
    Future<InvoiceData> waitingInvoiceData =
        (await invoiceHeader.getInvoiceData()).handle(context);

    Map<int, Product> productMap = await () async {
      SupplierCatalog supplierCatalog =
          await SupplierCatalog.getSupplierProducts(
              invoiceHeader.supplierId, context);

      if (supplierCatalog == null) {
        return <int, Product>{};
      } else {
        return supplierCatalog.getProductMap();
      }
    }();

    // can be null
    InvoiceData invoiceData = await waitingInvoiceData;

    if (invoiceData == null) {
      return <Product, int>{};
    } else {
      return invoiceData.data.map((int productId, int amount) {
        Product product = productMap[productId] ??
            Product(productId, 'Product #$productId', Unit.piece, false);
        return MapEntry(product, amount);
      });
    }
  }

  ProcessedInvoiceScreen(this.invoiceHeader)
      : super(key: ObjectKey(invoiceHeader.creationId));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Накладная'),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            InvoiceDate.todayWithSupplier(invoiceHeader.supplierHeader()),
            Expanded(
              child: preCache.data(() =>
                  FutureBuilderWrapper<Map<Product, int>>(
                      future: _invoiceData(context),
                      onSuccess: (BuildContext context,
                          Map<Product, int> productData) {
                        return preCache.forceSet(ListView(children: [
                          for (MapEntry<Product, int> entry
                              in productData.entries)
                            ProductAmountWidget(entry.key, entry.value)
                        ]));
                      })),
            )
          ],
        )));
  }
}
