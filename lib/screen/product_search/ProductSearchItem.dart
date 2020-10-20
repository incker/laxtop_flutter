import 'package:flutter/material.dart';
import 'package:laxtop/model/Product.dart';

// search item like widget made code faster
class ProductSearchItem extends StatelessWidget {
  final String lowerName;
  final Product product;

  ProductSearchItem(this.product)
      : assert(product != null),
        this.lowerName = product.name.toLowerCase(),
        super(key: ObjectKey(product.id));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      onTap: () {
        Navigator.pop(context, product);
      },
    );
  }
}
