import 'package:flutter/material.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/api/models/ApiSupplierPromo.dart';
import 'package:laxtop/model/PromoStatus.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/model/InvoicePreviewBinary.dart';
import 'package:laxtop/model/SpotSupplierSequence.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/model/SupplierUpdates.dart';
import 'package:laxtop/model/UserData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/storage/promo/PromoCacheManager.dart';

abstract class AppInitializer {
  static Future<UserData?> initUser(BuildContext? Function() getContext) async {
    // basic request
    Future<ApiResp<UserData>> waitingUserData = Api.getUserData();
    await BoxInitializer.initMemoryBoxes();
    UserData? userData = await (await waitingUserData).handle(getContext());
    if (userData != null) {
      saveUserData(getContext(), userData);
      // without await
      syncPromos(userData.promoIds);
    }
    return userData;
  }

  static Future<void> saveUserData(
      BuildContext? context, UserData userData) async {
    // boxes
    Box<SupplierHeader> supplierHeaderBox = SupplierHeaderBox().box();
    Box<SpotSupplierSequence> spotSupplierSequenceBox =
        SpotSupplierSequenceBox().box();
    Box<InvoiceHeader> invoiceHeaderBox = InvoiceHeaderBox().box();

    // save data
    await supplierHeaderBox.putAll(userData.supplierHeaderMap());
    await spotSupplierSequenceBox.putAll(userData.spotSupplierSequenceMap());

    await () async {
      Map<int, InvoiceHeader> invoiceHeaderMap = userData.invoiceHeaderMap();
      int lengthToAdd = invoiceHeaderMap.length;
      if (lengthToAdd == 0) {
        return;
      }
      int lengthBefore = invoiceHeaderBox.length;
      invoiceHeaderBox.putAll(invoiceHeaderMap);
      if (invoiceHeaderBox.length == lengthBefore + lengthToAdd) {
        await getAllInvoicePreviewList(context);
      }
    }();

    await SupplierUpdates(userData.supplierUpdatesMap()).save();

    supplierHeaderBox.compact();
    spotSupplierSequenceBox.compact();
    invoiceHeaderBox.compact();
    InvoiceDraftBox().box().compact();
  }

  /// download all invoices
  static Future<void> getAllInvoicePreviewList(BuildContext? context) async {
    InvoicePreviewBinary? invoicePreviewBinary =
        await (await Api.getLastInvoicePreviewList()).handle(context);

    Box invoiceHeaderBox = await InvoiceHeaderBox().initBox();

    // todo was not checked invoicePreviewBinary
    await invoiceHeaderBox.putAll(invoicePreviewBinary!.invoiceHeaderMap());
    await invoiceHeaderBox.compact();
  }
}

Future<void> syncPromos(List<int> ids) async {
  final Set<int> idsSet = Set.from(ids);

  final Box<SupplierPromo> supplierPromoBox = SupplierPromoBox().box();
  // await supplierPromoBox.clear();

  bool needUpdate = false;

  for (int id in supplierPromoBox.keys) {
    if (idsSet.contains(id)) {
      idsSet.remove(id);
    } else {
      await supplierPromoBox.delete(id);
    }
  }

  if (idsSet.isNotEmpty) {
    needUpdate = true;
  }

  if (!needUpdate) {
    return;
  }

  PromoCacheManager promoCacheManager = PromoCacheManager();

  ApiResp<List<ApiSupplierPromo>> apiResp = await Api.getPromos();

  Map<int, SupplierPromo> map = {};

  await apiResp.rawResultAccess((List<ApiSupplierPromo> apiPromos) async {
    for (ApiSupplierPromo apiPromo in apiPromos) {
      SupplierPromo supplierPromo =
          apiPromo.toSupplierPromo(PromoStatus.downloaded);
      await promoCacheManager.cacheIfNeeded(supplierPromo);

      if (!supplierPromoBox.containsKey(apiPromo.id)) {
        map[apiPromo.id] = supplierPromo;
      }
    }
  });

  supplierPromoBox.putAll(map);

  // delete expired
  PromoCacheDiff promoCacheDiff =
      await promoCacheManager.comparePromoIdsWithCache(ids);
  promoCacheDiff.deleteExpired();

  /*
  List<String> files = await promoCacheManager.readAllFilesInCache();
  print(files);
  */
}
