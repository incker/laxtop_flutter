import 'package:flutter/material.dart';
import 'package:laxtop/screen/product_search/SearchProductDelegate.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiNewInvoice.dart';
import 'package:laxtop/api/models/ApiRespInvoice.dart';
import 'package:laxtop/manager/InvoiceDataManager.dart';
import 'package:laxtop/manager/SearchManager.dart';
import 'package:laxtop/model/InvoiceData.dart';
import 'package:laxtop/model/InvoiceDraft.dart';
import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/model/Product.dart';
import 'package:laxtop/model/SupplierCatalog.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/libs/Observer.dart';
import 'package:laxtop/screen/invoice/SelectProductAmountScreen.dart';
import 'package:laxtop/screen/invoice/widgets/ProductAmountWidget.dart';
import 'package:laxtop/screen/orders_screen/widgets/InvoiceDate.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/storage/LazyBoxInitializer.dart';
import 'package:hive/hive.dart';

Future<InvoiceResult> modifyDraftScreen(
    BuildContext context, InvoiceDraft invoiceDraft) async {
  Map<int, Product> productMap;

  // extra scope to drop catalog
  final SearcherManager searcherManager = await () async {
    SupplierCatalog catalog = await SupplierCatalog.getSupplierProducts(
            invoiceDraft.supplierHeader.id, context) ??
        SupplierCatalog(invoiceDraft.supplierHeader.id, List(0));
    productMap = catalog.getProductMap();
    return SearcherManager(catalog.products
        .where((Product product) => !product.deleted)
        .toList(growable: false));
  }();

  return searcherManager.manage((SearcherManager searcherManager) {
    return InvoiceDataManager({...invoiceDraft.data})
        .manage<InvoiceResult>((InvoiceDataManager invoiceDataManager) async {
      InvoiceResult invoiceResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateInvoiceScreen(
                invoiceDraft.supplierHeader,
                productMap,
                invoiceDataManager,
                searcherManager)),
      );
      return invoiceResult ??
          InvoiceResult.draft(InvoiceDraft(
              invoiceDraft.supplierHeader.id, invoiceDataManager.data));
    });
  });
}

class CreateInvoiceScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SupplierHeader supplierHeader;
  final Map<int, Product> productMap;
  final InvoiceDataManager invoiceDataManager;
  final SearcherManager searcherManager;

  CreateInvoiceScreen(this.supplierHeader, this.productMap,
      this.invoiceDataManager, this.searcherManager)
      : super(key: ObjectKey(supplierHeader.id));

  Future<void> submitInvoice(
      BuildContext context, Map<int, int> pikedProductList) async {
    final List<List<int>> products =
        pikedProductList.entries.map((MapEntry<int, int> mapEntry) {
      List<int> list = List(2);
      list[0] = mapEntry.key;
      list[1] = mapEntry.value;
      return list;
    }).toList(growable: false);

    ApiNewInvoice apiNewInvoice = ApiNewInvoice(supplierHeader.id, products);

    print('----- setNewInvoice start -----');

    ApiRespInvoice apiRespInvoice =
        await (await Api.setNewInvoice(apiNewInvoice))
            .handle(_scaffoldKey.currentContext);

    print(apiRespInvoice);

    if (apiRespInvoice != null) {
      Navigator.pop(
          context, InvoiceResult.sent(InvoiceDraft(supplierHeader.id, {})));
      // save to hive

      InvoiceHeader invoiceHeader = InvoiceHeader(apiRespInvoice.creationId,
          apiRespInvoice.supplierId, apiRespInvoice.products.length);

      InvoiceHeaderBox().box().put(apiRespInvoice.creationId, invoiceHeader);

      LazyBox<InvoiceData> lazyBox = await InvoiceDataBox().initBox();
      await lazyBox.put(
          apiRespInvoice.creationId, apiRespInvoice.toInvoiceData());
    }

    print('----- setNewInvoice end -----');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Новая накладная'),
          actions: <Widget>[
            Observer<Map<int, int>>(
                stream: invoiceDataManager.stream$,
                onSuccess: (BuildContext context, Map<int, int> data) {
                  return data.isEmpty
                      ? Container()
                      : FlatButton(
                          textColor: Colors.white,
                          onPressed: () async {
                            await submitInvoice(context, data);
                          },
                          child: Text('Готово',
                              style: const TextStyle(fontSize: 20.0)),
                        );
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            InvoiceDate.todayWithSupplier(supplierHeader),
            Expanded(
              child: Observer<Map<int, int>>(
                  stream: invoiceDataManager.stream$,
                  onWaiting: (BuildContext context) {
                    return Text('...');
                  },
                  onSuccess: (BuildContext context, Map<int, int> data) {
                    List<ProductAmountWidgetClickable> widgets =
                        data.entries.map((MapEntry<int, int> entry) {
                      final int amount = entry.value;

                      final Product product =
                          productMap[entry.key] ?? Product.unknown(entry.key);

                      return ProductAmountWidgetClickable(
                          product, amount, invoiceDataManager.setAmount);
                    }).toList(growable: false);

                    return ListView(children: widgets);
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final Product product = await showSearch(
                context: context,
                delegate: SearchProductDelegate(searcherManager..search('')));

            // just clean memory from old search results
            searcherManager.search('');

            if (product != null) {
              final int oldAmount = invoiceDataManager.getAmount(product) ?? 1;
              final int newAmount =
                  await changeProductAmount(context, product, oldAmount);
              if (newAmount != null) {
                invoiceDataManager.setAmount(product, newAmount);
              }
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ));
  }
}

class ProductAmount {
  Product product;
  int amount;

  ProductAmount(this.product, this.amount);
}

class ProductAmountWidgetClickable extends StatelessWidget {
  final Product product;
  final int amount;
  final Function(Product, int) _changeProductAmount;

  ProductAmountWidgetClickable(
      this.product, this.amount, this._changeProductAmount)
      : super(key: ObjectKey(product.id.toString() + '-' + amount.toString()));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ProductAmountWidget(product, amount),
      onTap: () async {
        final int newAmount =
            await changeProductAmount(context, product, amount);
        if (newAmount != null) {
          _changeProductAmount(product, newAmount);
        }
      },
      onLongPress: () {
        _showDialog(context, product.name).then((bool confirmDelete) {
          if (confirmDelete) {
            _changeProductAmount(product, 0);
          }
        });
      },
    );
  }
}

Future<bool> _showDialog(context, String content) {
  return showDialogConfirmDelete(context, 'Удалить позицию?', content);
}

/// popup confirm delete (common widget)
Future<bool> showDialogConfirmDelete(context, String title, String content) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text('Удалить'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  ).then((confirmDelete) => confirmDelete == true);
}
