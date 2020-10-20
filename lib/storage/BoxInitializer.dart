import 'package:flutter/foundation.dart';
import 'package:laxtop/model/InvoiceDraft.dart';
import 'package:laxtop/model/InvoiceHeader.dart';
import 'package:laxtop/model/SpotSupplierSequence.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laxtop/model/spot/Spot.dart';

class BasicDataBox extends BoxInitializer {
  String boxName() => 'basic_data';
}

class SupplierHeaderBox extends BoxInitializer<SupplierHeader> {
  String boxName() => 'supplier_header';
}

class SpotBox extends BoxInitializer<Spot> {
  String boxName() => 'spot';

  Future<void> setSpots(List<Spot> spots) async {
    Box<Spot> spotBox = box();
    Future<int> waitingBoxClear = spotBox.clear();
    Map<int, Spot> rows = {};
    spots.forEach((Spot spot) {
      rows[spot.id] = spot;
    });
    await waitingBoxClear;
    await spotBox.putAll(rows);
    await spotBox.compact();
  }
}

class SpotSupplierSequenceBox extends BoxInitializer<SpotSupplierSequence> {
  String boxName() => 'spot_supplier_sequence';
}

class InvoiceDraftBox extends BoxInitializer<InvoiceDraft> {
  String boxName() => 'invoice_draft';
}

class InvoiceHeaderBox extends BoxInitializer<InvoiceHeader> {
  String boxName() => 'invoice_header';
}

class SupplierPromoBox extends BoxInitializer<SupplierPromo> {
  String boxName() => 'supplier_promo';
}

abstract class BoxInitializer<T> {
  String boxName();

  static List<BoxInitializer> boxes() => [
        BasicDataBox(),
        SupplierHeaderBox(),
        SpotBox(),
        SpotSupplierSequenceBox(),
        InvoiceDraftBox(),
        InvoiceHeaderBox(),
        SupplierPromoBox(),
      ];

  static Future<void> initMemoryBoxes() async {
    List<Future<void>> waitingBoxes = boxes()
        .map((BoxInitializer boxInitializer) => boxInitializer.initBox())
        .toList(growable: false);

    for (Future<void> waitingBox in waitingBoxes) {
      await waitingBox;
    }
  }

  Future<Box<T>> initBox() async {
    return await Hive.openBox<T>(boxName(),
        compactionStrategy: compactionStrategy);
  }

  Box<T> box() {
    return Hive.box<T>(boxName());
  }

  ValueListenable<Box> listenable({List<int> keys}) {
    // for convenience: importing hive_flutter is not automatic by IDE
    // for not making mistakes: keys are always int
    return box().listenable(keys: keys);
  }
}

// hive strategy compact on 1 change. Looks like it works ok
bool compactionStrategy(entries, deletedEntries) {
  return true;
}
