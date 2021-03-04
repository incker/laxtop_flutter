import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/libs/RxTextField.dart';
import 'package:laxtop/manager/InputFieldManager.dart';
import 'package:laxtop/model/AuthorizedUserData.dart';
import 'package:laxtop/model/SignInDetails.dart';
import 'package:laxtop/screen/registration/sign_in_screen/AuthLogic.dart';
import 'package:laxtop/screen/registration/sign_in_screen/EnterSmsScreen.dart';
import 'package:laxtop/storage/BasicData.dart';

Future<ApiResp<AuthorizedUserData>?> userSignIn(BuildContext context) async {
  auth.User? user = await InputFieldManager(
          BasicData().phone.replaceAll(RegExp(r'[^\d]'), ''))
      .manage<auth.User?>((InputFieldManager inputFieldManager) {
    return Navigator.push<auth.User?>(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen(inputFieldManager)),
    );
  });

  if (user != null) {
    String idToken = await user.getIdToken();
    return await Api.firebaseLogin(SignInDetails(idToken));
  } else {
    return null;
  }
}

class SignInScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final InputFieldManager inputFieldManager;
  final AuthLogic authLogic = AuthLogic();

  SignInScreen(this.inputFieldManager);

  String getNumber() {
    return '+' + inputFieldManager.value().replaceAll(RegExp(r'[^\d]'), '');
  }

  Future<void> onVerifyPhoneOk() async {
    // handle some type of bug,
    // when AuthLogic call this function second time after dropping widget (and context)
    if (_scaffoldKey.currentContext == null) {
      return;
    }
    auth.User? user =
        await authBySms(_scaffoldKey.currentContext!, authLogic, getNumber());
    if (user != null) {
      Navigator.pop(_scaffoldKey.currentContext!, user);
    }
  }

  void verifyPhone() async {
    await authLogic.verifyPhoneNumber(
        getNumber(), onVerifyPhoneOk, inputFieldManager.addError);
  }

  Widget build(BuildContext context) {
    print('SignInScreen rebuild!!!!!');

    return Scaffold(
      appBar: AppBar(
        title: Text('Laxtop'),
        key: _scaffoldKey,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Войти',
                  style: TextStyle(fontSize: 25.0, color: Colors.grey[700])),
              SizedBox(height: 10.0),
              Text('По номеру телефона:',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey[800])),
              SizedBox(height: 30.0),
              RxTextField<String>(
                style: TextStyle(fontSize: 25.0),
                autofocus: true,
                subscribe: inputFieldManager.stream$,
                dispatch: inputFieldManager.inField.add,
                controller: TextEditingController()
                  ..text = inputFieldManager.value(),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'\d')),
                ],
                decoration: InputDecoration(
                  errorMaxLines: 5,
                  prefixIcon: Icon(FontAwesomeIcons.plus,
                      size: 15.0, color: Colors.grey),
                  hintText: 'x xxx-xxx-xxxx',
                ),
                onSubmitted: (value) {
                  verifyPhone();
                },
              ),
              SizedBox(height: 40.0),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                onPressed: verifyPhone,
                child: Text(
                  'Выслать код',
                  style: TextStyle(fontSize: 20.0),
                ),
                textColor: Colors.white,
                elevation: 7.0,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// todo popup loading?
