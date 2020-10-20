import 'package:flutter/material.dart';
import 'package:laxtop/libs/FutureBuilderWrapper.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:laxtop/libs/EmptyBody.dart';
import 'package:laxtop/screen/orders_screen/widgets/PromoIndicatorChip.dart';
import 'package:laxtop/screen/promo/PromoCarouselScreen.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/storage/promo/PromoCacheManager.dart';
import 'package:hive/hive.dart';

class PromoGridScreen extends StatelessWidget {
  final PromoCacheManager promoCacheManager = PromoCacheManager();

  List<SupplierPromo> getSavedPromos() {
    return SupplierPromoBox()
        .box()
        .values
        .where((SupplierPromo promo) => !promo.isFresh())
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Акции'),
        actions: <Widget>[
          PromoIndicatorChip(),
        ],
      ),
      body: ValueListenableBuilder<Box<SupplierPromo>>(
          valueListenable: SupplierPromoBox().listenable(),
          builder:
              (BuildContext context, Box<SupplierPromo> box, Widget _child) {
            final List<SupplierPromo> promos = getSavedPromos();
            return promos.isEmpty ? EmptyBody() : PromoGrid(promos);
          }),
    );
  }
}

class PromoGrid extends StatelessWidget {
  final List<SupplierPromo> promos;

  PromoGrid(this.promos);

  void onPromoTap(BuildContext context, SupplierPromo promo) {
    final int index = promos.indexOf(promo);
    showPromoCarousel(context, promos, index);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // to fix scrolling in SupplierInfoScreen
      physics: ScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 9 / 16,
      // (1080 / 1920),
      crossAxisCount: 3,
      children: List.generate(promos.length, (int i) {
        return PromoPreview(promos[i], onPromoTap);
      }, growable: false),
    );
  }
}

class PromoPreview extends StatelessWidget {
  final PromoCacheManager promoCacheManager = PromoCacheManager();
  final SupplierPromo promo;
  final Function(BuildContext context, SupplierPromo promo) onPromoTap;

  PromoPreview(this.promo, this.onPromoTap);

  @override
  Widget build(BuildContext context) {
    return FutureBuilderWrapper<String>(
      future: promoCacheManager.getFilePath(promo),
      onSuccess: (BuildContext context, String filePath) {
        return InkWell(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(filePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          onTap: () {
            onPromoTap(context, promo);
          },
        );
      },
    );
  }
}
