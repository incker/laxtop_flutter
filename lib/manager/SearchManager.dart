import 'package:laxtop/manager/Manager.dart';
import 'package:laxtop/model/Product.dart';
import 'package:laxtop/screen/product_search/ProductSearchItem.dart';
import 'package:rxdart/rxdart.dart';

class SearcherManager extends Manager {
  final RegExp regex = RegExp(r'\s+');
  final BehaviorSubject<List<ProductSearchItem>> _foundProductsStream =
      BehaviorSubject<List<ProductSearchItem>>();

  final List<ProductSearchItem> _productSearch;
  List<ProductSearchItem> _foundProducts = [];
  String _query = '';

  Stream<List<ProductSearchItem>> get foundProductsStream =>
      _foundProductsStream.stream;

  factory SearcherManager(List<Product> products) {
    final List<ProductSearchItem> productSearch = products
        .map((Product product) => ProductSearchItem(product))
        .toList(growable: false);

    SearcherManager searcherManager = SearcherManager._internal(productSearch);
    searcherManager.search('');
    return searcherManager;
  }

  SearcherManager._internal(this._productSearch);

  void search(String query) {
    // double spaces (and other space chars) replace to space
    query = query.toLowerCase().trim().replaceAll(regex, ' ');

    if (query.isEmpty) {
      _foundProducts = _productSearch;
    } else {
      final List<ProductSearchItem> listToSearchProducts =
          query.contains(_query) ? _foundProducts : _productSearch;

      final List<String> queryParts = query.split(' ');

      _foundProducts =
          listToSearchProducts.where((ProductSearchItem productSearch) {
        for (String part in queryParts) {
          if (!productSearch.lowerName.contains(part)) {
            return false;
          }
        }
        return true;
      }).toList(growable: false);
    }

    _query = query;
    _foundProductsStream.add(_foundProducts);
  }

  Future<T> manage<T>(Future<T> Function(SearcherManager) func) async {
    T data = await func(this);
    this.dispose();
    return data;
  }

  void dispose() {
    _foundProductsStream.close();
  }
}
