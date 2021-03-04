import 'package:flutter/material.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/model/Product.dart';
import 'package:laxtop/storage/LazyBoxInitializer.dart';
import 'package:hive/hive.dart';

part 'SupplierCatalog.g.dart';

@HiveType(typeId: 6)
class SupplierCatalog {
  @HiveField(0)
  final int supplierId;
  @HiveField(1)
  final List<Product> products;

  const SupplierCatalog(this.supplierId, this.products);

  Map<int, Product> getProductMap() {
    Map<int, Product> data = {};
    products.forEach((Product product) {
      data[product.id] = product;
    });
    return data;
  }

  static Future<SupplierCatalog> getSupplierProducts(
      int supplierId, BuildContext context) async {
    LazyBox<SupplierCatalog> supplierCatalogBox =
        await SupplierCatalogBox().initBox();
    SupplierCatalog? supplierCatalog = await supplierCatalogBox.get(supplierId);

    if (supplierCatalog == null) {
      SupplierCatalog? apiSupplierCatalog =
          await (await Api.getSupplierCatalog(supplierId)).handle(context);
      if (apiSupplierCatalog != null) {
        await supplierCatalogBox.put(
            apiSupplierCatalog.supplierId, apiSupplierCatalog);
      }
      return apiSupplierCatalog!;
    }

    return SupplierCatalog(supplierId, []);
  }

  // need to hold deleted by supplier products
  // to allow user see his order history
  List<Product> getActiveProducts() {
    return products
        .where((Product product) => !product.deleted)
        .toList(growable: false);
  }

  factory SupplierCatalog.fromJson(Map<String, dynamic> json) {
    List<Product> products = (json['products'] as List)
        .map((spot) => Product.fromJson(spot))
        .toList(growable: false);

    return SupplierCatalog(json['supplierId'], products);
  }
}
