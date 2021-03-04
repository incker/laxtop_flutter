import 'package:flutter/material.dart';
import 'package:laxtop/libs/CenterScreenWrapper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<bool> acceptAgreement(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _AgreementScreen()),
    ).then((accepted) => accepted == true);

class _AgreementScreen extends StatelessWidget {
  _AgreementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenterScreenWrapper('Конфиденциальность', [
      Center(
        child: Icon(
          FontAwesomeIcons.shieldAlt,
          size: 70.0,
          color: Colors.grey[500],
        ),
      ),
      SizedBox(height: 40.0),
      CheckboxListTile(
          value: true,
          title: Text(
              'Соглашаюсь с тем что указанные мною данные будут переданы только тем поставщикам, у которых вы сделали заказ'),
          onChanged: (bool? value) {
            // todo?
          }),
      SizedBox(height: 30.0),
      RaisedButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: Text(
          'Принять соглашение',
          style: TextStyle(fontSize: 20.0),
        ),
        textColor: Colors.white,
        elevation: 7.0,
        color: Colors.blue,
      ),
    ]);
  }
}
