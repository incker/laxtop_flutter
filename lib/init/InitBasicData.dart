import 'package:laxtop/init/InitSpotBox.dart';
import 'package:laxtop/init/SystemInit.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';

class InitBasicData extends ProcessInit {
  List<Type> after() => [InitSpotBox];

  Future<void> init() async {
    Box box = await BasicDataBox().initBox();
    BasicData.setBox(box);
  }
}
