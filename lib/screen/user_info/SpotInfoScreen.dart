import 'package:flutter/material.dart';
import 'package:laxtop/model/spot/Spot.dart';

class SpotInfoScreen extends StatelessWidget {
  final Spot spot;

  SpotInfoScreen(this.spot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot.address.address),
      ),
      body: ListView(
        children: <Widget>[
          _ItemInfo('Адрес', spot.address.address),
          spot.address.spotName.isNotEmpty
              ? _ItemInfo(spot.address.spotType, spot.address.spotName)
              : _ItemInfo('Тип Объекта', spot.address.spotType),
          _ItemInfo(spot.spotOrg.orgType, spot.spotOrg.orgName),
          if (spot.hasImage())
            Image.network(
              spot.originalImage(),
            ),
        ],
      ),
    );
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
