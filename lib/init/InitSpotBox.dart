import 'package:laxtop/init/InitHive.dart';
import 'package:laxtop/init/SystemInit.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';

// box который тоже всегда нужен на первом же экране
class InitSpotBox extends ProcessInit {
  static BasicData instance;

  List<Type> after() => [InitHive];

  Future<void> init() async {
    await SpotBox().initBox();
  }
}
