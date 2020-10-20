import 'package:flutter/material.dart';
import 'package:laxtop/libs/CenterScreenWrapper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laxtop/storage/BasicData.dart';

Future<bool> acceptOfferAddLocation(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _OfferAddLocationScreen()),
    ).then((accepted) => accepted == true);

class _OfferAddLocationScreen extends StatelessWidget {
  final BasicData basicData = BasicData();

  _OfferAddLocationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenterScreenWrapper('Добро пожаловать!', [
      Center(
        child: Icon(
          FontAwesomeIcons.mapMarkedAlt,
          size: 70.0,
          color: Colors.grey[500],
        ),
      ),
      SizedBox(height: 40.0),
      Text('Добро пожаловать, ${basicData.name}!',
          style: TextStyle(fontSize: 18.0)),
      SizedBox(height: 3.0),
      Text('Укажите точку доставки товаров', style: TextStyle(fontSize: 18.0)),
      SizedBox(height: 30.0),
      RaisedButton(
        child: Text(
          'Добавить точку на карте',
          style: TextStyle(fontSize: 20.0),
        ),
        textColor: Colors.white,
        elevation: 7.0,
        color: Colors.blue,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ]);
  }
}
