import 'package:flutter/material.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:intl/intl.dart';

// u32 timestamp кончится в 2160 году)
// как быть с поясами?

// нужно ли?
// int userTimezone = 2;
// int timeShift(int timestamp) => timestamp + (userTimezone * 60 * 60);

class InvoiceDate extends StatelessWidget {
  final String date;
  final Widget leftSideWidget;

  InvoiceDate._internal(this.leftSideWidget, this.date)
      : super(key: ObjectKey(date));

  InvoiceDate(int timestamp)
      : this._internal(
          Spacer(),
          toDate(timestamp * 1000),
        );

  InvoiceDate.today()
      : this._internal(
          Spacer(),
          _today(),
        );

  InvoiceDate.todayWithSupplier(SupplierHeader supplierHeader)
      : this._internal(
          _supplierToWidget(supplierHeader),
          _today(),
        );

  InvoiceDate.withSupplier(SupplierHeader supplierHeader, int timestamp)
      : this._internal(
          _supplierToWidget(supplierHeader),
          toDate(timestamp * 1000),
        );

  static String _today() => DateFormat('dd.MM.yy').format(DateTime.now());

  static String toDate(int millisecondsSinceEpoch) => DateFormat('dd.MM.yy')
      .format(DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch));

  static Widget _supplierToWidget(SupplierHeader supplierHeader) {
    return Expanded(
        child: Text(
      supplierHeader.name,
      style: const TextStyle(fontSize: 20.0, color: Colors.grey),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          leftSideWidget,
          Text(date),
        ],
      ),
    );
  }
}
