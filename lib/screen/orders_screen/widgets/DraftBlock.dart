import 'package:flutter/material.dart';
import 'package:laxtop/screen/orders_screen/widgets/InvoiceDate.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/model/InvoiceDraft.dart';
import 'package:laxtop/screen/invoice/CreateInvoiceScreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class DraftBlock extends StatelessWidget {
  final Box<InvoiceDraft> invoiceDraftBox = InvoiceDraftBox().box();
  final Function() showSnackBar;

  DraftBlock(this.showSnackBar) : super(key: ObjectKey('DraftBlock'));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<InvoiceDraft>>(
      valueListenable: InvoiceDraftBox().listenable(),
      builder: (BuildContext context, Box<InvoiceDraft> box, Widget _child) {
        if (box.isEmpty) {
          return Container();
        }
        return Column(children: [
          InvoiceDate.today(),
          for (InvoiceDraft draft in box.values)
            _DraftInvoiceItem(draft, showSnackBar)
        ]);
      },
    );
  }
}

class _DraftInvoiceItem extends StatelessWidget {
  final InvoiceDraft invoiceDraft;
  final Function() showSnackBar;

  void onTapDraft(BuildContext context, InvoiceDraft invoiceDraft) async {
    InvoiceResult invoiceResult =
        await modifyDraftScreen(context, invoiceDraft);

    Box<InvoiceDraft> invoiceDraftBox = await InvoiceDraftBox().initBox();
    await InvoiceDraft.changeDraft(invoiceDraftBox, invoiceResult.draftToSave);

    if (invoiceResult.wasSent) {
      showSnackBar();
    }
  }

  void deleteDraft(InvoiceDraft invoiceDraft) async {
    Box<InvoiceDraft> invoiceDraftBox = await InvoiceDraftBox().initBox();
    InvoiceDraft.deleteDraft(invoiceDraftBox, invoiceDraft.supplierId);
  }

  _DraftInvoiceItem(this.invoiceDraft, this.showSnackBar)
      : super(
            key: ObjectKey(invoiceDraft.supplierId.toString() +
                '-' +
                invoiceDraft.data.length.toString()));

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
        title: Text(invoiceDraft.supplierHeader.name),
        subtitle: Row(
          children: <Widget>[
            Text(invoiceDraft.readablePositionCount()),
            Spacer(),
            Text('(Черновик)',
                style: const TextStyle(fontSize: 16.0, color: Colors.red)),
            Spacer(),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            _showDialog(context, invoiceDraft.supplierHeader.name)
                .then((bool confirmDelete) {
              if (confirmDelete) {
                deleteDraft(invoiceDraft);
              }
            });
          },
        ),
        onTap: () {
          onTapDraft(context, invoiceDraft);
          print('onTap: ListTile');
        },
      ),
    );
  }
}

Future<bool> _showDialog(context, String content) {
  return showDialogConfirmDelete(context, 'Удалить накладную?', content);
}
