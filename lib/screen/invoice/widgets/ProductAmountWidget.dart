import 'package:flutter/material.dart';
import 'package:laxtop/model/Product.dart';
// TODO: try numbers monospace

class ProductAmountWidget extends StatelessWidget {
  final Product product;
  final int amount;

  ProductAmountWidget(this.product, this.amount)
      : super(key: ObjectKey(product.id.toString() + '-' + amount.toString()));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.grey[300],
          width: 1.0,
        ),
      )),
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <Widget>[
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 4.0),
            child: Text(
              amount.toString(),
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          Text('шт',
              style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
        ],
      ),
    );
  }
}
