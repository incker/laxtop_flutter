import 'dart:io';
import 'package:laxtop/init/SystemInit.dart';
import 'package:laxtop/model/InvoiceData.dart';
import 'package:laxtop/model/InvoiceDraft.dart';
import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/model/Product.dart';
import 'package:laxtop/model/PromoStatus.dart';
import 'package:laxtop/model/SpotSupplierSequence.dart';
import 'package:laxtop/model/SupplierCatalog.dart';
import 'package:laxtop/model/SupplierInfo.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/model/SupplierPhone.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:laxtop/model/Unit.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/model/spot/Spot.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';
import 'package:laxtop/model/spot/SpotOrg.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p;

class InitHive extends ProcessInit {
  List<Type> after() => List(0);

  Future<void> init() async {
    Hive.init((await boxDirectory()).path);
    _initAdapters();
  }

  _initAdapters() {
    Hive.registerAdapter(SupplierHeaderAdapter());
    Hive.registerAdapter(SpotSupplierSequenceAdapter());
    Hive.registerAdapter(InvoiceDraftAdapter());
    Hive.registerAdapter(SupplierCatalogAdapter());
    Hive.registerAdapter(SupplierInfoAdapter());
    Hive.registerAdapter(SupplierPhoneAdapter());
    Hive.registerAdapter(InvoiceDataAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UnitAdapter());
    Hive.registerAdapter(InvoiceHeaderAdapter());
    Hive.registerAdapter(SupplierPromoAdapter());
    Hive.registerAdapter(PromoStatusAdapter());
    Hive.registerAdapter(SpotAdapter());
    Hive.registerAdapter(SpotAddressAdapter());
    Hive.registerAdapter(SpotOrgAdapter());
  }

  static Future<Directory> boxDirectory() async {
    Directory promoImageDir = Directory(p.join(
        (await path_provider.getApplicationDocumentsDirectory()).path, 'box4'));
    if (!await promoImageDir.exists()) {
      await promoImageDir.create();
    }
    return promoImageDir;
  }
}
