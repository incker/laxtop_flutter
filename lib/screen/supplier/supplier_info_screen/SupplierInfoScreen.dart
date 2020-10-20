import 'package:flutter/material.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/libs/FutureBuilderWrapper.dart';
import 'package:laxtop/libs/PreCache.dart';
import 'package:laxtop/model/SupplierHeader.dart';
import 'package:laxtop/model/SupplierInfo.dart';
import 'package:laxtop/model/SupplierPhone.dart';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:laxtop/screen/promo/PromoGridScreen.dart';
import 'package:laxtop/libs/showErrorDialog.dart';
import 'package:laxtop/storage/BoxInitializer.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierInfoScreen extends StatelessWidget {
  final PreCache<Future<SupplierInfo>> preCache = PreCache();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SupplierHeader supplierHeader;

  SupplierInfoScreen(this.supplierHeader)
      : super(key: ObjectKey(supplierHeader.id));

  Future<SupplierInfo> getSupplierInfo() async {
    ApiResp<SupplierInfo> apiResp =
        await SupplierInfo.getById(supplierHeader.id);
    return apiResp.handle(_scaffoldKey.currentContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(supplierHeader.name),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          FutureBuilderWrapper<SupplierInfo>(
              future: preCache.data(getSupplierInfo),
              onSuccess: (BuildContext context, SupplierInfo supplierInfo) {
                return Container(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: supplierInfo == null
                        ? Text('Пусто(')
                        : Column(
                            children: [
                              _SupplierTitleWidget(
                                  supplierHeader.name, supplierInfo.about),
                              ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: Colors.blueGrey,
                                ),
                                title: Text(supplierInfo.address),
                                onTap: () {},
                              ),
                              for (SupplierPhone supplierPhone
                                  in supplierInfo.phones)
                                _SupplierPhoneWidget(supplierPhone),
                            ],
                          ));
              },
              onWaiting: (BuildContext context) {
                return Column(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: _SupplierTitleWidget(supplierHeader.name, '')),
                  Center(child: CircularProgressIndicator())
                ]);
              }),
          ValueListenableBuilder<Box<SupplierPromo>>(
              valueListenable: SupplierPromoBox().listenable(),
              builder: (BuildContext context, Box<SupplierPromo> box,
                  Widget _child) {
                final List<SupplierPromo> promos = box.values
                    .where((SupplierPromo promo) =>
                        promo.supplierId == supplierHeader.id &&
                        !promo.isFresh())
                    .toList(growable: false);
                return Container(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: promos.isEmpty
                        ? null
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Aкции поставщика:'),
                              PromoGrid(promos),
                            ],
                          ));
              })
        ],
      ),
    );
  }
}

class _SupplierTitleWidget extends StatelessWidget {
  final String name;
  final String about;

  _SupplierTitleWidget(this.name, this.about);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontSize: 26.0)),
      subtitle: Text(about),
    );
  }
}

class _SupplierPhoneWidget extends StatelessWidget {
  final SupplierPhone supplierPhone;

  _launchURL(BuildContext context) async {
    String url = 'tel:' + supplierPhone.number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await showErrorDialog(context, 'Could not launch $url');
    }
  }

  _SupplierPhoneWidget(this.supplierPhone);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.phone,
        color: Colors.blueGrey,
      ),
      title: Text(supplierPhone.position),
      subtitle: Text(supplierPhone.number),
      onTap: () {
        _launchURL(context);
      },
    );
  }
}
