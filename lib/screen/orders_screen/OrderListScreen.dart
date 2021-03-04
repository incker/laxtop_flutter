import 'package:flutter/material.dart';
import 'package:laxtop/screen/orders_screen/OrdersHandler.dart';
import 'package:laxtop/screen/orders_screen/widgets/PromoIndicatorChip.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/model/InvoiceDraft.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/screen/invoice/CreateInvoiceScreen.dart';
import 'package:laxtop/screen/supplier/SelectSupplierScreen.dart';
import 'package:laxtop/AppDrawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

final Widget svgIconFile = SvgPicture.asset(
  'assets/file.svg',
  semanticsLabel: 'Acme Logo',
  color: Colors.grey,
  height: 56.0,
);

class OrderListScreen extends StatelessWidget {
  // for SnackBar, to get context under Scaffold
  final GlobalKey<ScaffoldState> _actionButtonKey = GlobalKey<ScaffoldState>();

  void showSnackBar() {
    if (_actionButtonKey.currentContext != null) {
      ScaffoldMessenger.of(_actionButtonKey.currentContext!).showSnackBar(
        SnackBar(
            backgroundColor: Colors.lightGreen,
            content: const Text('Отправлено!')),
      );
    }
  }

  OrderListScreen({Key? key}) : super(key: ObjectKey('OrderListScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заказы'),
        actions: <Widget>[
          PromoIndicatorChip(),
        ],
      ),
      drawer: AppDrawer(),
      body: OrdersHandler(showSnackBar),
      floatingActionButton: FloatingActionButton(
        key: _actionButtonKey,
        onPressed: () async {
          final SupplierHeader? supplierHeader = await selectSupplier(context);
          if (supplierHeader == null) {
            return;
          }
          Box<InvoiceDraft> invoiceDraftBox = await InvoiceDraftBox().initBox();
          InvoiceDraft invoiceDraft = invoiceDraftBox.get(supplierHeader.id) ??
              InvoiceDraft(supplierHeader.id, {});
          InvoiceResult invoiceResult =
              (await modifyDraftScreen(context, invoiceDraft));
          if (invoiceResult.draftToSave.data.isEmpty) {
            await invoiceDraftBox.delete(supplierHeader.id);
          } else {
            await invoiceDraftBox.put(
                supplierHeader.id, invoiceResult.draftToSave);
          }
          await invoiceDraftBox.compact();

          if (invoiceResult.wasSent) {
            showSnackBar();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
