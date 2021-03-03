import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:laxtop/model/spot/SelectedSpot.dart';
import 'package:laxtop/model/spot/SpotAddress.dart';
import 'package:laxtop/model/spot/SpotNearby.dart';
import 'package:laxtop/screen/registration/add_spot/ChangeSpotAdressScreen.dart';
import 'package:laxtop/screen/registration/add_spot/SpotsNearbyGridScreen.dart';

Future<SelectedSpot> showSpotCarousel(
    BuildContext context, List<SpotNearby> spotsNearby, int index) async {
  return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SpotsNearbyCarouselScreen(spotsNearby, index)));
}

class SpotsNearbyCarouselScreen extends StatelessWidget {
  final List<SpotNearby> spotsNearby;
  final PageController pageController;
  final int dropSlideIndex;

  SpotsNearbyCarouselScreen(this.spotsNearby, int initialPage)
      : dropSlideIndex = spotsNearby.length + 1,
        pageController = PageController(
          initialPage: initialPage,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (int pageNum) {
          if (pageNum >= dropSlideIndex) {
            Navigator.pop(context);
          }
        },
        children: [
          for (SpotNearby spot in spotsNearby)
            Scaffold(
              appBar: AppBar(
                title: Text(spot.address.address),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Выбрать'),
                    onPressed: () {
                      Navigator.pop(context, SelectedSpot.selectSpot(spot));
                    },
                  ),
                ],
              ),
              body: SpotInfoStory(spot),
            ),
          Scaffold(
            appBar: AppBar(
              title: Text('Создать новую'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Добавить'),
                  onPressed: () async {
                    // TODO

                    SpotAddress spotAddress = await changeSpotAddress(
                        context, SpotAddress('', '', ''));

                    if (spotAddress != null) {
                      Navigator.pop(context, SelectedSpot.newSpot(spotAddress));
                    }
                  },
                ),
              ],
            ),
            body: AddNewSpot(),
          ),
          Text(''),
        ],
      ),
    );
  }
}

class SpotInfoStory extends StatelessWidget {
  final SpotNearby spot;

  SpotInfoStory(this.spot);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  image: NetworkImage(spot.imageId.original()),
                  fit: BoxFit.cover)),
        ),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(spot.imageId.original()),
                  fit: BoxFit.contain)),
        ),
      ],
    );
  }
}
