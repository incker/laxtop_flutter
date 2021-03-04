import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laxtop/libs/FutureBuilderWrapper.dart';
import 'package:laxtop/model/PromoStatus.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/storage/promo/PromoCacheManager.dart';

Future<void> showDownloadedPromos(BuildContext context) async {
  final List<SupplierPromo> promos = SupplierPromoBox()
      .box()
      .values
      .where((SupplierPromo promo) => promo.isDownloaded())
      .toList(growable: false);

  await showPromoCarousel(context, promos, 0);
}

Future<void> showPromoCarousel(
    BuildContext context, List<SupplierPromo> promos, int index) async {
  SystemChrome.setEnabledSystemUIOverlays([]);

  final WatchedPromoSetter dataSetter = WatchedPromoSetter();
  dataSetter.collectAsWatched(promos[index]);

  await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PromoCarouselScreen(promos, dataSetter, index)));

  print(dataSetter.map);
  SupplierPromoBox().box().putAll(dataSetter.map);
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
}

class PromoCarouselScreen extends StatelessWidget {
  final List<SupplierPromo> promos;
  final WatchedPromoSetter dataSetter;
  final PageController pageController;
  final int dropSlideIndex;

  PromoCarouselScreen(this.promos, this.dataSetter, int initialPage)
      : dropSlideIndex = promos.length,
        pageController = PageController(
          initialPage: initialPage,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (int pageNum) {
          if (pageNum == dropSlideIndex) {
            Navigator.pop(context);
          } else {
            // mark as watched
            dataSetter.collectAsWatched(promos[pageNum]);
          }
        },
        children: <Widget>[
          for (SupplierPromo promo in promos) SupplierPromoStory(promo),
          Text(''),
        ],
      ),
    );
  }
}

class SupplierPromoStory extends StatelessWidget {
  final PromoCacheManager promoCacheManager = PromoCacheManager();
  final SupplierPromo promo;

  SupplierPromoStory(this.promo);

  @override
  Widget build(BuildContext context) {
    return FutureBuilderWrapper<String>(
      future: promoCacheManager.getFilePath(promo),
      onSuccess: (BuildContext context, String filePath) {
        final AssetImage assetImage = AssetImage(filePath);

        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  image: assetImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: assetImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class WatchedPromoSetter {
  Map<int, SupplierPromo> map = {};

  void collectAsWatched(SupplierPromo promo) {
    map[promo.id] = promo.copyWith(status: PromoStatus.watched);
  }
}
