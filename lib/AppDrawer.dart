import 'package:flutter/material.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/model/spot/Spot.dart';
import 'package:laxtop/screen/AppInfoScreen.dart';
import 'package:laxtop/screen/user_info/SpotInfoScreen.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:laxtop/screen/SupplierListScreen.dart';
import 'package:laxtop/screen/promo/PromoGridScreen.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          ValueListenableBuilder<Box>(
              valueListenable: BasicDataBox().listenable(),
              builder: (BuildContext context, Box box, Widget _child) {
                BasicData basicData = BasicData();

                return UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Text('+'),
                  ),
                  accountEmail: Text(basicData.phone),
                  accountName: Text(Spot.currentSpot.address.address),
                );
              }),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Акции'),
            trailing: Chip(
              //backgroundColor: Theme.of(context).accentColor,
              backgroundColor: Colors.blue[100],
              label: ValueListenableBuilder<Box<SupplierPromo>>(
                  valueListenable: SupplierPromoBox().listenable(),
                  builder: (BuildContext context, Box<SupplierPromo> box,
                      Widget _child) {
                    final int count = SupplierPromo.countNotFreshPromos(box);
                    return Text(
                      count.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  }),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PromoGridScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.truck),
            title: Text('Поставщики'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupplierListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Точка поставки'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpotInfoScreen(Spot.currentSpot)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('О программе'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppInfoScreen()),
              );
            },
          ),

          /*
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('тест: Google map'),
            onTap: () async {
              final GeoLocation geoLocation =
                  (await IpApiLocation.detectLocation())?.location ??
                      GeoLocation.kiev();

              GeoLocation location =
                  await getGoogleMapPosition(context, geoLocation);
              print(location.toString());
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('тест: ImagePickerExample'),
            onTap: () async {
              await getSpotImage(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('тест: AgreementScreen'),
            onTap: () async {
              final bool accepted = await acceptAgreement(context);
              print('Agreement accepted: ' + accepted.toString());
            },
          ),
          */

          Divider(),
          Expanded(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.powerOff),
              title: Text('Выйти'),
              onTap: () async {
                // AppDrawer нужно закрывать вручную.. Его не закрывает без ошибок ApiResp.handle((
                // нужно решать, но not urgent
                Navigator.pop(context);
                (await Api.logout()).handle(context);
              },
            ),
          )),
        ],
      ),
    );
  }
}
