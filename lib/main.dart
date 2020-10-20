import 'package:flutter/material.dart';
import 'package:laxtop/AppInitializer.dart';
import 'package:laxtop/init/SystemInit.dart';
import 'package:laxtop/libs/defaultWidgets.dart';
import 'package:laxtop/model/UserData.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/screen/registration/RegistrationScreen.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:laxtop/screen/orders_screen/OrderListScreen.dart';

void main() => runApp(LaxtopApp());

enum UserStatus {
  unknown,
  loadingStatus,
  newUser,
  userInitWaiting,
  userInitSuccess,
  userInitError,
}

class LaxtopApp extends StatefulWidget {
  @override
  _LaxtopApp createState() => _LaxtopApp();
}

class _LaxtopApp extends State<LaxtopApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserStatus userStatus = UserStatus.unknown;

  void _init() async {
    if (userStatus == UserStatus.unknown) {
      // to prevent _init() twice
      userStatus = UserStatus.loadingStatus;
      await SystemInit.initAll().then((value) {
        print('done');
      });

      _checkUserStatus();
      BasicDataBox().listenable(
          keys: [DataKey.isNewUser.index]).addListener(_checkUserStatus);
    }
  }

  void _userInitialize() async {
    _setUserStatus(UserStatus.userInitWaiting);
    await AppInitializer.initUser(() => _scaffoldKey.currentContext)
        .then((UserData userData) {
      if (userStatus != UserStatus.newUser) {
        _setUserStatus((userData == null)
            ? UserStatus.userInitError
            : UserStatus.userInitSuccess);
      }
    });
  }

  void _checkUserStatus() {
    if (BasicData().isNewUser) {
      _setUserStatus(UserStatus.newUser);
    } else {
      if (userStatus == UserStatus.newUser ||
          userStatus == UserStatus.loadingStatus) {
        _userInitialize();
      }
    }
  }

  void _setUserStatus(UserStatus newUserStatus) {
    if (userStatus != newUserStatus) {
      setState(() {
        userStatus = newUserStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Laxtop',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: () {
          switch (userStatus) {
            case UserStatus.unknown:
            case UserStatus.loadingStatus:
            case UserStatus.userInitWaiting:
              _init();
              return Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    title: Text('Laxtop'),
                  ),
                  body: defaultOnWaiting(context));
            case UserStatus.newUser:
              return RegistrationScreen();
            case UserStatus.userInitSuccess:
              return OrderListScreen();
            case UserStatus.userInitError:
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Laxtop'),
                  ),
                  body: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Не вышло загрузить пользователя'),
                      SizedBox(height: 50.0),
                      RaisedButton(
                        child: Text('Повторить'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: _userInitialize,
                      ),
                      SizedBox(height: 60.0),
                    ],
                  )));
            default:
              throw 'User status $userStatus is unreachable';
          }
        }());
  }
}

// The specific widget that could not find a MaterialLocalizations ancestor was
// https://stackoverflow.com/questions/56275595/no-materiallocalizations-found-myapp-widgets-require-materiallocalizations-to
// TODO: Application ID  https://developer.android.com/studio/publish/app-signing
// TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).

// ~~~~~~~~~ not urgent ~~~~~~~~~~~~~
// todo: input address on google map
// todo: send application version to server
// todo: if error application version - popup

// todo gitignore google maps token?
