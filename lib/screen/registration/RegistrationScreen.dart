import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/model/AuthorizedUserData.dart';
import 'package:laxtop/model/GeoLocation.dart';
import 'package:laxtop/model/IpApiLocation.dart';
import 'package:laxtop/model/spot/SelectedSpot.dart';
import 'package:laxtop/model/spot/Spot.dart';
import 'package:laxtop/model/spot/SpotOrg.dart';
import 'package:laxtop/screen/registration/AgreementScreen.dart';
import 'package:laxtop/screen/registration/add_spot/ChangeSpotOrganizationScreen.dart';
import 'package:laxtop/screen/registration/add_spot/GoogleMapScreen.dart';
import 'package:laxtop/screen/registration/add_spot/SpotImagePickerScreen.dart';
import 'package:laxtop/screen/registration/add_spot/SpotsNearbyGridScreen.dart';
import 'package:laxtop/screen/registration/UserNameScreen.dart';
import 'package:laxtop/screen/registration/sign_in_screen/SignInScreen.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/storage/BoxInitializer.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreen createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final BasicData basicData = BasicData();
  final Box<Spot> spotBox = SpotBox().box();
  final Future<IpApiLocation> waitingIpLocation =
      IpApiLocation.detectLocation();

  bool agreementAccepted = false;
  GeoLocation location;
  Spot spot;

  Future<T> onContext<T>(Future<T> Function(BuildContext) func) async {
    BuildContext context = _scaffoldKey.currentContext;
    if (context != null) {
      return func(context);
    }
    return null;
  }

  changeProgress({
    GeoLocation location,
    bool agreementAccepted,
  }) {
    setState(() {
      spot = spotBox.get(basicData.spotId);
      this.location = location ?? this.location;
      this.agreementAccepted =
          agreementAccepted ?? this.agreementAccepted ?? false;
    });
  }

  Future<bool> requirePhoneSignIn() async {
    if (basicData.hasToken) {
      return true;
    }
    ApiResp<AuthorizedUserData> apiResp =
        await onContext((BuildContext context) => userSignIn(context));
    if (apiResp == null) {
      return false;
    }
    AuthorizedUserData authorizedUserData =
        await onContext((BuildContext context) => apiResp.handle(context));
    if (authorizedUserData == null) {
      return false;
    }
    await SpotBox().setSpots(authorizedUserData.spots);
    await authorizedUserData.saveToApplication(basicData);
    changeProgress(agreementAccepted: authorizedUserData.licenseAccepted);
    return true;
  }

  Future<bool> requireAcceptAgreement() async {
    if (agreementAccepted) {
      return true;
    }
    bool accepted =
        await onContext((BuildContext context) => acceptAgreement(context)) ??
            false;
    if (accepted) {
      ApiResp<bool> apiResp = await Api.setUserLicenseAccepted(true);
      accepted =
          await onContext((BuildContext context) => apiResp.handle(context)) ??
              false;
      changeProgress(agreementAccepted: accepted);
    }
    return accepted;
  }

  Future<bool> requireInputUserName() async {
    if (basicData.hasName) {
      return true;
    }

    String name =
        await onContext((BuildContext context) => inputUserName(context)) ?? '';
    if (name.isNotEmpty) {
      ApiResp<String> apiResp = await Api.setUserName(name);
      String formattedName = await onContext(
              (BuildContext context) => (apiResp).handle(context)) ??
          '';
      await basicData.put(name: formattedName);
      changeProgress();
      return true;
    }
    return false;
  }

  Future<bool> requireAddGeoLocation() async {
    if (spot != null || location != null) {
      return true;
    }

    GeoLocation geoLocation =
        (await waitingIpLocation)?.location ?? GeoLocation.kiev();
    GeoLocation newLocation = await onContext(
        (BuildContext context) => getGoogleMapPosition(context, geoLocation));
    if (newLocation != null) {
      changeProgress(location: newLocation);
      return true;
    }
    return false;
  }

  Future<bool> requireSelectSpot() async {
    if (basicData.hasSpotId) {
      return true;
    }

    SelectedSpot selectedSpot = await onContext(
        (BuildContext context) => selectSpotOrCreate(context, location));

    if (selectedSpot != null) {
      ApiResp<Spot> apiResp = await selectedSpot.submitUserSpot(location);
      bool hasSpotId = await handleApiRespSpot(apiResp);
      changeProgress();
      return hasSpotId;
    }
    return false;
  }

  Future<bool> requireAddSpotOrg() async {
    if (spot?.spotOrg?.isValid() == true) {
      return true;
    }

    SpotOrg spotOrg = await onContext((BuildContext context) =>
        changeSpotOrganization(context, SpotOrg('', '')));

    if (spotOrg != null) {
      ApiResp<Spot> apiResp = await Api.setSpotOrganization(spotOrg);
      bool hasSpotOrg = await handleApiRespSpot(apiResp);
      changeProgress();
      return hasSpotOrg;
    }
    return false;
  }

  Future<bool> requireSpotImage() async {
    if (spot?.hasImage() == true) {
      return true;
    }

    String base64Image =
        await onContext((BuildContext context) => getSpotImage(context));

    if (base64Image != null) {
      ApiResp<Spot> apiResp = await Api.setSpotImage(base64Image);
      bool hasSpotImage = await handleApiRespSpot(apiResp);
      changeProgress();
      return hasSpotImage;
    }
    return false;
  }

  Future<bool> handleApiRespSpot(ApiResp<Spot> apiResp) async {
    return onContext((BuildContext context) async {
          Spot spot = await apiResp.handle(context);
          if (spot == null) {
            return false;
          } else {
            await spotBox.put(spot.id, spot);
            await basicData.put(spotId: spot.id);
            return true;
          }
        }) ??
        false;
  }

  Future<void> fillInfo() async {
    // there is some error about it
    if (_scaffoldKey.currentContext == null) {
      print('_scaffoldKey.currentContext is null!!');
      return;
    }

    if (await requirePhoneSignIn() &&
        await requireAcceptAgreement() &&
        await requireInputUserName() &&
        await requireAddGeoLocation() &&
        await requireSelectSpot() &&
        await requireAddSpotOrg() &&
        await requireSpotImage()) {
      await BasicData().put(isNewUser: false);
    }
  }

  Widget build(BuildContext context) {
    print('RegistrationScreen rebuild !!!!');
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Laxtop'),
        ),
        body: ListView(children: [
          basicData.hasToken
              ? ListTile(
                  leading: Icon(FontAwesomeIcons.phone),
                  trailing: Icon(FontAwesomeIcons.check, color: Colors.green),
                  title: Text('Добавлен номер'),
                  subtitle: Text(basicData.phone),
                  onTap: () {},
                )
              : SizedBox(height: 100.0),
          agreementAccepted
              ? ListTile(
                  leading: Icon(FontAwesomeIcons.check),
                  trailing: Icon(FontAwesomeIcons.check, color: Colors.green),
                  title: Text('Приняты правила'),
                  subtitle: Text('Соглашение о конфиденциальности'),
                  onTap: () {
                    acceptAgreement(context);
                  },
                )
              : SizedBox(height: 20.0),
          location != null
              ? ListTile(
                  leading: Icon(
                    Icons.location_on,
                    size: 32,
                  ),
                  trailing: Icon(FontAwesomeIcons.check, color: Colors.green),
                  title: Text('Точка отмечена на карте'),
                  subtitle: Text(spot?.address?.spotType ?? '...'),
                  onTap: () {
                    // ??
                  },
                )
              : SizedBox(height: 10.0),
          SizedBox(height: 30.0),
          Center(
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              onPressed: fillInfo,
              child: Text(
                'Войти',
                style: TextStyle(fontSize: 20.0),
              ),
              textColor: Colors.white,
              elevation: 7.0,
              color: Theme.of(context).accentColor,
            ),
          ),
        ]));
  }
}

// TODO приятно познакомиться, Добавьте свою точку поставки
// для того чтоб записывать что принято соглашение
