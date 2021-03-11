import 'package:flutter/material.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/libs/FutureApiResp.dart';
import 'package:laxtop/libs/PreCache.dart';
import 'package:laxtop/libs/defaultWidgets.dart';
import 'package:laxtop/model/GeoLocation.dart';
import 'package:laxtop/model/spot/SelectedSpot.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';
import 'package:laxtop/model/spot/SpotNearby.dart';
import 'package:laxtop/screen/registration/add_spot/ChangeSpotAddressScreen.dart';
import 'package:laxtop/screen/registration/add_spot/SpotsNearbyCarouselScreen.dart';
import 'package:laxtop/screen/user_info/SpotAddressScreen.dart';

Future<SelectedSpot?> selectSpotOrCreate(
    BuildContext? context, GeoLocation location) async {
  if (context == null) {
    return null;
  }

  SelectedSpot? selectedSpot = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SpotsNearbyGridScreen(location)),
  );
  return selectedSpot;
}

class SpotsNearbyGridScreen extends StatelessWidget {
  final PreCache<Widget> preCache = PreCache<Widget>();
  final Future<ApiResp<List<SpotNearby>>> waitingSpotsNearby;

  SpotsNearbyGridScreen(GeoLocation location)
      : waitingSpotsNearby = Api.getSpotsNearby(location);

  void onSpotTap(BuildContext context, List<SpotNearby> spotsNearby,
      SpotNearby spot) async {
    final int index = spotsNearby.indexOf(spot);
    SelectedSpot? selectedSpot =
        await showSpotCarousel(context, spotsNearby, index);

    if (selectedSpot != null && selectedSpot.spot != null) {
      bool applied =
          await applySpotAddress(context, selectedSpot.spot!.address);
      if (applied) {
        Navigator.pop(context, selectedSpot);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return preCache.data(() => FutureApiResp<List<SpotNearby>>(
        future: waitingSpotsNearby,
        onSuccess: (BuildContext context, List<SpotNearby> spotsNearby) {
          return preCache.forceSet(Scaffold(
            appBar: AppBar(
              title: spotsNearby.isEmpty
                  ? Text('Добавте вашу точку')
                  : Text('Выберите вашу точку'),
            ),
            body: GridView.count(
              shrinkWrap: true,
              childAspectRatio: 9 / 16, // (1080 / 1920),
              crossAxisCount: 3,
              children: [
                for (SpotNearby spot in spotsNearby)
                  InkWell(
                    child: SpotInfoStory(spot),
                    onTap: () {
                      onSpotTap(context, spotsNearby, spot);
                    },
                  ),
                AddNewSpot(),
              ],
            ),
          ));
        },
        onWaiting: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Поиск объектов...'),
            ),
            body: defaultOnWaiting(context),
          );
        }));
  }
}

class AddNewSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('https://goodnets.ru/template/ico/add.png'),
                fit: BoxFit.contain)),
      ),
      onTap: () async {
        SpotAddress? newSpotAddress =
            await changeSpotAddress(context, SpotAddress('', '', ''));

        if (newSpotAddress != null) {
          Navigator.pop(context, SelectedSpot.newSpot(newSpotAddress));
        }
      },
    );
  }
}
