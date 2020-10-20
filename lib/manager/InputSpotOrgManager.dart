import 'package:laxtop/manager/InputFieldManager.dart';
import 'package:laxtop/manager/Manager.dart';
import 'package:laxtop/manager/Validation.dart';
import 'package:laxtop/model/spot/SpotOrg.dart';

class InputSpotOrgManager extends Manager {
  final InputFieldManager typeManager;
  final InputFieldManager nameManager;

  InputSpotOrgManager(SpotOrg spotAddress)
      : typeManager = InputFieldManager(spotAddress.orgType,
            validation: Validation.notEmpty),
        nameManager = InputFieldManager(spotAddress.orgName,
            validation: Validation.notEmpty);

  Future<T> manage<T>(Future<T> Function(InputSpotOrgManager) func) async {
    T data = await func(this);
    this.dispose();
    return data;
  }

  SpotOrg resultSpotOrg() {
    String Function(String) cleaner = Validation.getSpaceCleaner();
    return SpotOrg(
      cleaner(typeManager.value()),
      cleaner(nameManager.value()),
    );
  }

  void dispose() {
    typeManager.dispose();
    nameManager.dispose();
  }
}
