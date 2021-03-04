import 'package:flutter/material.dart';
import 'package:laxtop/libs/FocusSwitcher.dart';
import 'package:laxtop/libs/RxTextField.dart';
import 'package:laxtop/manager/InputSpotOrgManager.dart';
import 'package:laxtop/model/spot/SpotOrg.dart';

Future<SpotOrg?> changeSpotOrganization(BuildContext context, SpotOrg spotOrg) {
  return InputSpotOrgManager(spotOrg)
      .manage<SpotOrg?>((InputSpotOrgManager inputManager) {
    return Navigator.push<SpotOrg?>(
      context,
      MaterialPageRoute(
          builder: (context) => _ChangeSpotOrganizationScreen(inputManager)),
    );
  });
}

class _ChangeSpotOrganizationScreen extends StatelessWidget {
  final FocusSwitcher focusSwitcher = FocusSwitcher(2);
  final InputSpotOrgManager inputManager;

  _ChangeSpotOrganizationScreen(this.inputManager);

  void submitForm(BuildContext context) {
    final SpotOrg spotOrg = inputManager.resultSpotOrg();
    if (spotOrg.isValid()) {
      Navigator.pop(context, spotOrg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('СПД'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Text(
                'Субъект предпринимательской деятельности',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 40.0),
              RxTextField<String>(
                autofocus: true,
                subscribe: inputManager.typeManager.stream$,
                dispatch: inputManager.typeManager.inField.add,
                controller: TextEditingController()
                  ..text = inputManager.typeManager.value(),
                decoration: InputDecoration(
                    labelText: 'Тип Вашего Предприятия (ФОП/ООО)',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    errorMaxLines: 5),
                focusNode: focusSwitcher.getAt(0),
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  focusSwitcher.nextFocusNode(context, 0);
                },
              ),
              RxTextField<String>(
                subscribe: inputManager.nameManager.stream$,
                dispatch: inputManager.nameManager.inField.add,
                controller: TextEditingController()
                  ..text = inputManager.nameManager.value(),
                decoration: InputDecoration(
                    labelText: 'Название Вашего Предприятия (Иванов/Ромашка)',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    errorMaxLines: 5),
                focusNode: focusSwitcher.getAt(1),
              ),
              SizedBox(height: 40.0),
              RaisedButton(
                onPressed: () {
                  submitForm(context);
                },
                child: Text('Сохранить'),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          )),
    );
  }
}
