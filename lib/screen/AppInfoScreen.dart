import 'package:flutter/material.dart';
import 'package:laxtop/storage/BasicData.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoScreen extends StatelessWidget {
  final String appVersion = BasicData().version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('О программе'),
        ),
        body: ListView(
          children: <Widget>[
            _ItemInfo('Версия', appVersion),
            InkWell(
                child: _ItemInfo('Тех поддержка в телеграме', '@incker'),
                onTap: () => launch('https://t.me/incker')),
          ],
        ));
  }
}

class _ItemInfo extends StatelessWidget {
  final String title;
  final String description;

  _ItemInfo(this.title, this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 12.0),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 25.0),
                )
              ]),
        ),
      ),
    );
  }
}
