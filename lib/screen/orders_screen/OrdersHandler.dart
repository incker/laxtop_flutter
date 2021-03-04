import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/screen/invoice/ProcessedInvoiceScreen.dart';
import 'package:laxtop/screen/orders_screen/widgets/DraftBlock.dart';
import 'package:laxtop/screen/orders_screen/widgets/InvoiceDate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class OrdersHandler extends StatelessWidget {
  final Box<InvoiceHeader> boxInvoiceHeader = InvoiceHeaderBox().box();
  final Function() showSnackBar;

  OrdersHandler(this.showSnackBar) : super(key: ObjectKey('OrdersHandler'));

  Widget invoiceByIndex(int reversedIndex) {
    final currentInvoiceHeader = boxInvoiceHeader.getAt(reversedIndex);

    final String currentInvoiceDate =
        InvoiceDate.toDate(currentInvoiceHeader.creationId * 1000);

    final String nextInvoiceDate = (reversedIndex >= 1)
        ? InvoiceDate.toDate(
            boxInvoiceHeader.getAt(reversedIndex - 1).creationId * 1000)
        : '';

    if (currentInvoiceDate == nextInvoiceDate) {
      return _InvoicePreview(currentInvoiceHeader);
    } else {
      return Column(
        children: <Widget>[
          InvoiceDate(currentInvoiceHeader.creationId),
          _InvoicePreview(currentInvoiceHeader)
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<InvoiceHeader>>(
        valueListenable: InvoiceHeaderBox().listenable() as ValueListenable<Box<InvoiceHeader>>,
        builder: (BuildContext context, Box<InvoiceHeader> box, Widget? _child) {
          final int boxLength = box.length;

          return ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, i) {
              final int reversedIndex = boxLength - i - 1;
              if (i == 0) {
                return Column(children: [
                  if (boxLength > 0) invoiceByIndex(reversedIndex),
                  DraftBlock(showSnackBar),
                  SizedBox(height: 150.0, key: ObjectKey('SizedBox')),
                ]);
              } else {
                return invoiceByIndex(reversedIndex);
              }
            },
            itemCount: boxLength == 0 ? 1 : boxLength,
          );
        });
  }
}

class _InvoicePreview extends StatelessWidget {
  final InvoiceHeader invoiceHeader;

  void onTapInvoice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProcessedInvoiceScreen(invoiceHeader)),
    );
  }

  _InvoicePreview(
    this.invoiceHeader,
  ) : super(key: ObjectKey(invoiceHeader.creationId));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SvgPicture.asset(
          'assets/file.svg',
          semanticsLabel: 'Acme Logo',
          color: Colors.grey,
          height: 56.0,
        ),
        title: Text(invoiceHeader.supplierName()),
        subtitle: Text(invoiceHeader.readablePositionCount()),
        onTap: () {
          onTapInvoice(context);
          print('onTap: ListTile');
        },
      ),
    );
  }
}
