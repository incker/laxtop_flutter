import 'dart:io';
import 'package:laxtop/storage/promo/PromoCacheManager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:laxtop/init/SystemInit.dart';

class InitPromoDir extends ProcessInit {
  List<Type> after() => List(0);

  Future<void> init() async {
    Directory promoDir = Directory(p.join(
        (await path_provider.getApplicationDocumentsDirectory()).path,
        'promo'));
    if (!await promoDir.exists()) {
      await promoDir.create();
    }
    PromoCacheManager.setPromoDir(promoDir);
  }
}
