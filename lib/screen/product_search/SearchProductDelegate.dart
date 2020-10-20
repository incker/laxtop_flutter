import 'package:flutter/material.dart';
import 'package:laxtop/libs/Observer.dart';
import 'package:laxtop/manager/SearchManager.dart';
import 'package:laxtop/model/Product.dart';
import 'package:laxtop/screen/product_search/ProductSearchItem.dart';

class SearchProductDelegate extends SearchDelegate<Product> {
  // cash widget made code feel faster
  final ProductListBuilder productListBuilder;
  final SearcherManager searcherManager;

  SearchProductDelegate(this.searcherManager)
      : this.productListBuilder = ProductListBuilder(searcherManager);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        key: ObjectKey('IconButton'),
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searcherManager.search(query);
    return productListBuilder;
  }
}

class ProductListBuilder extends StatelessWidget {
  final SearcherManager searcherManager;

  ProductListBuilder(this.searcherManager)
      : super(key: ObjectKey('ProductListBuilder'));

  @override
  Widget build(BuildContext context) {
    return Observer<List<ProductSearchItem>>(
      stream: searcherManager.foundProductsStream,
      onSuccess: (BuildContext context, List<ProductSearchItem> items) {
        return ListView(
          shrinkWrap: true,
          children: items,
        );
      },
    );
  }
}
