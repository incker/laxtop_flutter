import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/ApiCore.dart';
import 'package:laxtop/init/InitBasicData.dart';
import 'package:laxtop/init/SystemInit.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InitApiToken extends ProcessInit {
  List<Type> after() => [InitBasicData];

  Future<void> init() async {
    Api.spotIdChangeCallback();
    ApiCore.tokenChangeCallback();
    BasicData().box.listenable(
        keys: [DataKey.spotId.index]).addListener(Api.spotIdChangeCallback);
    BasicData().box.listenable(
        keys: [DataKey.token.index]).addListener(ApiCore.tokenChangeCallback);
  }
}
