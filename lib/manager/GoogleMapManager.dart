import 'package:laxtop/manager/Manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class GoogleMapData {
  MapType mapType;
  Set<Marker> markers;
  CameraPosition cameraPosition;

  GoogleMapData(this.mapType, this.markers, this.cameraPosition);
}

class GoogleMapManager extends Manager {
  GoogleMapData googleMapData;

  final BehaviorSubject<GoogleMapData> _googleMapData =
      BehaviorSubject<GoogleMapData>();

  Stream<GoogleMapData> get googleMapData$ => _googleMapData.stream;

  factory GoogleMapManager(LatLng defaultPosition) {
    final GoogleMapData googleMapData = GoogleMapData(
        MapType.normal,
        {},
        CameraPosition(
          target: defaultPosition,
          zoom: 11.0,
        ));
    final googleMapManager = GoogleMapManager._internal(googleMapData);
    googleMapManager._googleMapData.add(googleMapData);
    return googleMapManager;
  }

  GoogleMapManager._internal(this.googleMapData);

  void changeMapType() {
    googleMapData.mapType = googleMapData.mapType == MapType.normal
        ? MapType.satellite
        : MapType.normal;
    _googleMapData.add(googleMapData);
  }

  void setMarker(Marker marker) {
    googleMapData.markers = {marker};
    _googleMapData.add(googleMapData);
  }

  void onCameraMove(CameraPosition cameraPosition) {
    googleMapData.cameraPosition = cameraPosition;
    // no need notify
  }

  LatLng getCameraPosition() => googleMapData.cameraPosition.target;

  Future<T> manage<T>(Future<T> Function(GoogleMapManager) func) async {
    T data = await func(this);
    this.dispose();
    return data;
  }

  @override
  void dispose() {
    _googleMapData.close();
  }
}
