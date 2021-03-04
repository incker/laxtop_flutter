import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:laxtop/libs/RxTextField.dart';
import 'package:laxtop/manager/InputFieldManager.dart';
import 'package:laxtop/libs/CenterScreenWrapper.dart';
import 'package:laxtop/screen/registration/sign_in_screen/AuthLogic.dart';

Future<auth.User?> authBySms(
    BuildContext context, AuthLogic authLogic, String phoneNumber) async {
  return InputFieldManager('')
      .manage<auth.User?>((InputFieldManager inputFieldManager) {
    return Navigator.push<auth.User>(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EnterSmsScreen(inputFieldManager, authLogic, phoneNumber)),
    );
  });
}

class EnterSmsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final InputFieldManager inputFieldManager;
  final AuthLogic authLogic;
  final String phoneNumber;

  EnterSmsScreen(this.inputFieldManager, this.authLogic, this.phoneNumber);

  String getFieldSms() {
    final RegExp regex = RegExp(r'[^\d]');
    return (inputFieldManager.value() ?? '').replaceAll(regex, '');
  }

  Future<void> verifySmsCode() async {
    // на всяк случай и тут добавлю
    if (_scaffoldKey.currentContext == null) {
      return;
    }

    try {
      auth.User user = await authLogic.signInWithPhoneNumber(getFieldSms());
      Navigator.pop(_scaffoldKey.currentContext!, user);
    } catch (e) {
      inputFieldManager.addError('$e');
    }
  }

  Widget build(BuildContext context) {
    return CenterScreenWrapper(
      'СМС Код',
      [
        Text('Войти',
            style: TextStyle(fontSize: 25.0, color: Colors.grey[700])),
        SizedBox(height: 10.0),
        Text('По номеру: $phoneNumber',
            style: TextStyle(fontSize: 18.0, color: Colors.grey[800])),
        Text('Введите СМС код',
            style: TextStyle(fontSize: 18.0, color: Colors.grey[800])),
        SizedBox(height: 30.0),
        RxTextField<String>(
          style: TextStyle(fontSize: 25.0),
          autofocus: true,
          subscribe: inputFieldManager.stream$,
          dispatch: inputFieldManager.inField.add,
          controller: TextEditingController()..text = inputFieldManager.value(),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'\d'))
          ],
          decoration: InputDecoration(hintText: '123456', errorMaxLines: 5),
          onSubmitted: (value) {
            verifySmsCode();
          },
        ),
        SizedBox(height: 20.0),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          onPressed: verifySmsCode,
          child: Text(
            'Подтвердить',
            style: TextStyle(fontSize: 20.0),
          ),
          textColor: Colors.white,
          elevation: 7.0,
          color: Theme.of(context).accentColor,
        ),
      ],
      padding: const EdgeInsets.only(bottom: 30.0, left: 40.0, right: 40.0),
      key: ObjectKey('EnterSmsScreen'),
      scaffoldKey: _scaffoldKey,
    );
  }
}
