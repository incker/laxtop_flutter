import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:laxtop/screen/promo/PromoCarouselScreen.dart';
import 'package:laxtop/storage/BoxInitializer.dart';

class PromoIndicatorChip extends StatelessWidget {
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<SupplierPromo>>(
      valueListenable: SupplierPromoBox().listenable() as ValueListenable<Box<SupplierPromo>>,
      builder: (BuildContext context, Box<SupplierPromo> box, Widget? _child) {
        final int counter = SupplierPromo.countDownloadedPromos(box);
        if (counter == 0) {
          return Container();
        }
        return InkWell(
          child: Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12.0),
              child: Chip(
                  backgroundColor: Colors.pink,
                  label: Text(
                    counter.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
          onTap: () {
            showDownloadedPromos(context);
          },
        );
      },
    );
  }
}
