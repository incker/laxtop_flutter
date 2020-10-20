import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/storage/LazyBoxInitializer.dart';

abstract class HiveHelper {
  /// change BasicDataBox
  /// clean SpotBox
  /// delete other boxes
  static Future<void> clean({String newToken, String newVersion}) async {
    await cleanSecondaryBoxes();
    await BasicData().put(
      version: newVersion,
      token: newToken,
    );
  }

  static Future<void> cleanSecondaryBoxes() async {
    for (LazyBoxInitializer lazyBoxInitializer in LazyBoxInitializer.boxes()) {
      await (await lazyBoxInitializer.initBox()).clear();
    }

    for (BoxInitializer boxInitializer in BoxInitializer.boxes()) {
      if (!(boxInitializer is BasicDataBox)) {
        await (await boxInitializer.initBox()).clear();
      }
    }

    // можно в этом месте как-то добавить:
    // заглянуть в _boxDirectory
    // удалить все файлы у которых название не skip
  }
}
