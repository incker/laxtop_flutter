import 'package:flutter/material.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';

Future<bool> applySpotAddress(
    BuildContext context, SpotAddress spotAddress) async {
  bool applied = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => SpotAddressScreen(spotAddress, needApply: true)),
  );
  return applied == true;
}

class SpotAddressScreen extends StatelessWidget {
  final SpotAddress spotAddress;
  final bool needApply;

  SpotAddressScreen(this.spotAddress, {needApply: bool, Key key})
      : needApply = (needApply == true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(needApply ? 'Подтвердите адрес' : 'Адрес'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _ItemInfo('Адрес', spotAddress.address),
          spotAddress.spotName.isNotEmpty
              ? _ItemInfo(spotAddress.spotType, spotAddress.spotName)
              : _ItemInfo('Тип Объекта', spotAddress.spotType),
          SizedBox(height: 40.0),
          if (needApply) _SpotAddressApplyButton(),

          // skip editing feature for now. Maybe it is not needed at all
          /*
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    onPressed: () {
                    },
                    child: Text(
                      'Редактировать',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    textColor: Colors.white,
                    elevation: 7.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _SpotAddressApplyButton(),
                ),
              ),
            ],
          )
          */
        ],
      ),
    );
  }
}

class _ItemInfo extends StatelessWidget {
  final String title;
  final String description;

  _ItemInfo(this.title, this.description, {Key key}) : super(key: key);

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

class _SpotAddressApplyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: Text(
          'Подтверждаю',
          style: TextStyle(fontSize: 20.0),
        ),
        textColor: Colors.white,
        elevation: 7.0,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
