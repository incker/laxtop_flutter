import 'package:laxtop/init/InitBasicData.dart';
import 'package:laxtop/init/SystemInit.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/HiveHelper.dart';
import 'package:package_info/package_info.dart';

class InitCheckVersion extends ProcessInit {
  List<Type> after() => [InitBasicData];

  Future<void> init() async {
    String currentVersion = await PackageInfo.fromPlatform()
        .then((PackageInfo packageInfo) => packageInfo.version);

    if (currentVersion != BasicData().version) {
      await HiveHelper.clean(newVersion: currentVersion);
    }
  }
}
