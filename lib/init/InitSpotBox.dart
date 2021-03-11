import 'package:laxtop/init/InitHive.dart';
import 'package:laxtop/init/SystemInit.dart';
import 'package:laxtop/storage/BoxInitializer.dart';

class InitSpotBox extends ProcessInit {
  List<Type> after() => [InitHive];

  Future<void> init() async {
    await SpotBox().initBox();
  }
}
