import 'package:hive/hive.dart';

enum DataKey { version, phone, token, name, isNewUser, spotId }

class BasicData {
  final Box box;

  static BasicData _instance;

  factory BasicData() => _instance;

  BasicData.setBox(this.box) {
    BasicData._instance = this;
  }

  String get version => box.get(DataKey.version.index) ?? '';

  String get phone => box.get(DataKey.phone.index) ?? '';

  String get token => box.get(DataKey.token.index) ?? '';

  String get name => box.get(DataKey.name.index) ?? '';

  /// user can be with token but have no spot info. so it is another variable
  bool get isNewUser => box.get(DataKey.isNewUser.index) ?? true;

  int get spotId => box.get(DataKey.spotId.index) ?? 0;

  Future<void> put(
      {String version,
      String token,
      String phone,
      String name,
      bool isNewUser,
      int spotId}) async {
    print({
      'version': version,
      'phone': phone,
      'token': token,
      'name': name,
      'isNewUser': isNewUser,
      'spotId': spotId,
    });

    if (token == '') {
      await box.putAll({
        if (version != null) DataKey.version.index: version,
        if (phone != null) DataKey.phone.index: phone,
        DataKey.token.index: token,
        DataKey.name.index: name ?? '',
        DataKey.isNewUser.index: isNewUser ?? true,
        DataKey.spotId.index: spotId ?? 0,
      });
    } else {
      await box.putAll({
        if (version != null) DataKey.version.index: version,
        if (phone != null) DataKey.phone.index: phone,
        if (token != null) DataKey.token.index: token,
        if (name != null) DataKey.name.index: name,
        if (isNewUser != null) DataKey.isNewUser.index: isNewUser,
        if (spotId != null) DataKey.spotId.index: spotId,
      });
    }

    await box.compact();
  }

  // has
  bool get hasPhone => phone.isNotEmpty;

  bool get hasToken => token.isNotEmpty;

  bool get hasName => name.isNotEmpty;

  bool get hasSpotId => spotId != 0;

  // hasNot
  bool get hasNotPhone => phone.isEmpty;

  bool get hasNotToken => token.isEmpty;

  bool get hasNotName => name.isEmpty;

  bool get hasNotSpotId => spotId == 0;
}
