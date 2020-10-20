import 'dart:async';
import 'package:flutter/material.dart';
import 'package:laxtop/libs/Observer.dart';
import 'package:laxtop/manager/GoogleMapManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:laxtop/model/GeoLocation.dart';
import 'package:laxtop/screen/registration/OfferAddLocationScreen.dart';

Future<GeoLocation> getGoogleMapPosition(
    BuildContext context, GeoLocation initialGeoLocation) async {
  if (await acceptOfferAddLocation(context) == false) {
    return null;
  }
  final LatLng selectedPosition =
      await GoogleMapManager(initialGeoLocation.toLatLng())
          .manage<LatLng>((GoogleMapManager googleMapManager) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => _GoogleMapScreen(googleMapManager)),
    );
  });
  if (selectedPosition != null) {
    return GeoLocation.fromLatLng(selectedPosition);
  } else {
    return null;
  }
}

class _GoogleMapScreen extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();
  final GoogleMapManager _googleMapManager;

  _GoogleMapScreen(this._googleMapManager);

  final test = (() {
    print('redraw GoogleMapScreen');
  })();

  void setPosition(BuildContext context, LatLng position) {
    Navigator.pop(context, position);
  }

  void _onMapTypeButtonPressed() {
    _googleMapManager.changeMapType();
  }

  void _onAddMarkerButtonPressed() {
    final LatLng position = _googleMapManager.getCameraPosition();
    _googleMapManager.setMarker(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: 'Место доставки',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Укажите место доставки'),
        actions: [
          Observer<GoogleMapData>(
              stream: _googleMapManager.googleMapData$,
              onSuccess: (BuildContext context, GoogleMapData googleMapData) {
                return googleMapData.markers.isEmpty
                    ? Container()
                    : FlatButton(
                        key: ObjectKey(0),
                        textColor: Colors.white,
                        onPressed: () {
                          print(googleMapData.cameraPosition.target.toString());

                          setPosition(
                              context, googleMapData.cameraPosition.target);
                        },
                        child: Text('Готово',
                            style: const TextStyle(fontSize: 20.0)),
                      );
              }),
        ],
        // backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: <Widget>[
          Observer<GoogleMapData>(
              stream: _googleMapManager.googleMapData$,
              onSuccess: (BuildContext context, GoogleMapData googleMapData) {
                print('map redraw');
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: googleMapData.cameraPosition,
                  mapType: googleMapData.mapType,
                  markers: googleMapData.markers,
                  onCameraMove: _googleMapManager.onCameraMove,
                );
              }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'btn1',
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.deepOrangeAccent,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  SizedBox(height: 16.0),
                  FloatingActionButton(
                    heroTag: 'btn2',
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.deepOrangeAccent,
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: IgnorePointer(
                    child: Column(
                  children: <Widget>[
                    Spacer(),
                    Icon(
                      Icons.add,
                      color: Colors.grey[800],
                    ),
                    Spacer(),
                  ],
                ))),
          ),
        ],
      ),
    );
  }
}
