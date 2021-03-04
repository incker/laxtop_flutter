import 'package:flutter/material.dart';
import 'package:laxtop/libs/FocusSwitcher.dart';
import 'package:laxtop/libs/RxTextField.dart';
import 'package:laxtop/manager/InputSpotAddressManager.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';
import 'package:laxtop/screen/user_info/SpotAddressScreen.dart';

Future<SpotAddress?> changeSpotAddress(
    BuildContext context, SpotAddress spotAddress) async {
  return InputSpotAddressManager(spotAddress)
      .manage<SpotAddress?>((InputSpotAddressManager inputManager) {
    return Navigator.push<SpotAddress?>(
        context,
        MaterialPageRoute(
            builder: (context) => _ChangeSpotAddressScreen(inputManager)));
  });
}

class _ChangeSpotAddressScreen extends StatelessWidget {
  final FocusSwitcher focusSwitcher = FocusSwitcher(3);
  final InputSpotAddressManager inputManager;

  _ChangeSpotAddressScreen(this.inputManager);

  void submitForm(BuildContext context) async {
    final SpotAddress spotAddress = inputManager.resultSpotAddress();
    if (spotAddress.isValid() && await applySpotAddress(context, spotAddress)) {
      Navigator.pop(context, spotAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Адрес'),
        actions: <Widget>[
          FlatButton(
            child: Text('Готово'),
            onPressed: () {
              submitForm(context);
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40.0),
              RxTextField<String>(
                // controller: _textFieldController,
                subscribe: inputManager.addressManager.stream$,
                dispatch: inputManager.addressManager.inField.add,
                controller: TextEditingController()
                  ..text = inputManager.addressManager.value(),
                decoration: InputDecoration(
                    labelText: 'Адрес',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    errorMaxLines: 5),
                focusNode: focusSwitcher.getAt(0),
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  focusSwitcher.nextFocusNode(context, 0);
                },
              ),
              RxTextField<String>(
                autofocus: true,
                // controller: _textFieldController,
                subscribe: inputManager.typeManager.stream$,
                dispatch: inputManager.typeManager.inField.add,
                controller: TextEditingController()
                  ..text = inputManager.typeManager.value(),
                decoration: InputDecoration(
                    labelText: 'Тип Объекта (Киоск/Магазин)',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    errorMaxLines: 5),
                focusNode: focusSwitcher.getAt(1),
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  focusSwitcher.nextFocusNode(context, 1);
                },
              ),
              RxTextField<String>(
                // controller: _textFieldController,
                subscribe: inputManager.nameManager.stream$,
                dispatch: inputManager.nameManager.inField.add,
                controller: TextEditingController()
                  ..text = inputManager.nameManager.value(),
                focusNode: focusSwitcher.getAt(2),
                decoration: InputDecoration(
                    labelText: 'Название (Сильпо/Апельмон), если есть',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    errorMaxLines: 5),
              ),
              SizedBox(height: 40.0),
              RaisedButton(
                onPressed: () {
                  submitForm(context);
                },
                child: Text('Сохранить'),
                autofocus: true,
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          )),
    );
  }
}
