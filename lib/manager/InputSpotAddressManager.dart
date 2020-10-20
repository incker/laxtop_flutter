import 'package:laxtop/manager/InputFieldManager.dart';
import 'package:laxtop/manager/Manager.dart';
import 'package:laxtop/manager/Validation.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';

class InputSpotAddressManager extends Manager {
  final InputFieldManager addressManager;
  final InputFieldManager typeManager;
  final InputFieldManager nameManager;

  InputSpotAddressManager(SpotAddress spotAddress)
      : addressManager = InputFieldManager(spotAddress.address,
            validation: Validation.notEmpty),
        typeManager = InputFieldManager(spotAddress.spotType,
            validation: Validation.notEmpty),
        nameManager = InputFieldManager(spotAddress.spotName);

  Future<T> manage<T>(Future<T> Function(InputSpotAddressManager) func) async {
    T data = await func(this);
    this.dispose();
    return data;
  }

  SpotAddress resultSpotAddress() {
    String Function(String) cleaner = Validation.getSpaceCleaner();
    return SpotAddress(
      cleaner(addressManager.value()),
      cleaner(typeManager.value()),
      cleaner(nameManager.value()),
    );
  }

  void dispose() {
    addressManager.dispose();
    typeManager.dispose();
    nameManager.dispose();
  }
}
