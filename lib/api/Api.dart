import 'dart:async';
import 'package:laxtop/api/ApiCore.dart';
import 'package:laxtop/api/models/ApiNewInvoice.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/api/models/ApiRespInvoice.dart';
import 'package:laxtop/api/models/ApiSupplierPromo.dart';
import 'package:laxtop/model/AuthorizedUserData.dart';
import 'package:laxtop/model/GeoLocation.dart';
import 'package:laxtop/model/InvoiceData.dart';
import 'package:laxtop/model/InvoicePreviewBinary.dart';
import 'package:laxtop/model/SignInDetails.dart';
import 'package:laxtop/model/SpotSupplierSequence.dart';
import 'package:laxtop/model/SupplierCatalog.dart';
import 'package:laxtop/model/SupplierInfo.dart';
import 'package:laxtop/model/UserData.dart';
import 'package:laxtop/model/spot/NewSpot.dart';
import 'package:laxtop/model/spot/Spot.dart';
import 'package:laxtop/model/spot/SpotNearby.dart';
import 'package:laxtop/model/spot/SpotOrg.dart';
import 'package:laxtop/storage/BasicData.dart';

abstract class Api {
  static int _spotId = 0;

  static void spotIdChangeCallback() {
    _spotId = BasicData().spotId ?? 0;
  }

  static Future<ApiResp<UserData>> getUserData() async {
    ApiResp<UserData> apiResp = await ApiCore.get('get-user-data');
    return apiResp;
  }

  static Future<ApiResp<SpotSupplierSequence>> setSupplierSequence(
      SpotSupplierSequence userSpot) async {
    ApiResp<SpotSupplierSequence> apiResp =
        await ApiCore.post('set-supplier-sequence', userSpot);
    return apiResp;
  }

  static Future<ApiResp<SupplierCatalog>> getSupplierCatalog(
      int supplierId) async {
    ApiResp<SupplierCatalog> apiResp =
        await ApiCore.get('get-supplier-catalog/$supplierId');
    return apiResp;
  }

  static Future<ApiResp<ApiRespInvoice>> setNewInvoice(
      ApiNewInvoice apiNewInvoice) async {
    ApiResp<ApiRespInvoice> apiResp =
        await ApiCore.post('set-new-invoice/$_spotId', apiNewInvoice);
    return apiResp;
  }

  static Future<ApiResp<InvoiceData>> getInvoiceData(int creationId) async {
    ApiResp<ApiRespInvoice> apiResp =
        await ApiCore.get('get-invoice/$_spotId/$creationId');

    ApiResp<InvoiceData> newApiResp =
        apiResp.map((ApiRespInvoice apiRespInvoice) {
      return apiRespInvoice.toInvoiceData();
    });

    return newApiResp;
  }

  static Future<ApiResp<InvoicePreviewBinary>> getLastInvoicePreviewList({
    int limit = 0,
  }) async {
    ApiResp<InvoicePreviewBinary> apiResp =
        await ApiCore.get('get-last-invoice-preview-list/$_spotId/$limit');
    return apiResp;
  }

  static Future<ApiResp<SupplierInfo>> getSupplierInfo(int supplierId) async {
    return ApiCore.get('get-supplier-info/$supplierId');
  }

  static Future<ApiResp<List<SpotNearby>>> getSpotsNearby(
      GeoLocation location) async {
    ApiResp<DataWrapper> apiResp = await ApiCore.post<DataWrapper, GeoLocation>(
        'get-spots-nearby', location);
    ApiResp<List<dynamic>> unwrappedAdiResp = apiResp.unwrap<List<dynamic>>();
    return unwrappedAdiResp.map((List<dynamic> data) {
      return data.map((e) => SpotNearby.fromJson(e)).toList(growable: false);
    });
  }

  static Future<ApiResp<AuthorizedUserData>> firebaseLogin(
      SignInDetails signInDetails) async {
    return ApiCore.post('firebase-login', signInDetails);
  }

  static Future<ApiResp<String>> setUserName(String name) async {
    ApiResp<DataWrapper> apiResp =
        await ApiCore.post('set-user-name', {'data': name});

    return apiResp.unwrap<String>();
  }

  static Future<ApiResp<bool>> setUserLicenseAccepted(bool accepted) async {
    ApiResp<DataWrapper> apiResp =
        await ApiCore.post('set-user-license-accepted', {'data': accepted});
    return apiResp.unwrap<bool>();
  }

  static Future<ApiResp<Spot>> addExistingSpot(
      int spotId, GeoLocation location) async {
    ApiResp<Spot> apiResp =
        await ApiCore.post('add-existing-spot/$spotId', location);
    return apiResp;
  }

  static Future<ApiResp<Spot>> setNewSpot(NewSpot newSpot) async {
    ApiResp<Spot> apiResp = await ApiCore.post('set-new-spot', newSpot);
    return apiResp;
  }

  static Future<ApiResp<Spot>> setSpotOrganization(SpotOrg spotOrg) async {
    ApiResp<Spot> apiResp =
        await ApiCore.post('set-spot-organization/$_spotId', spotOrg);
    return apiResp;
  }

  static Future<ApiResp<Spot>> setSpotImage(String base64Image) async {
    ApiResp<Spot> apiResp =
        await ApiCore.post('set-spot-image/$_spotId', {'base64': base64Image});
    return apiResp;
  }

  static Future<ApiResp<List<ApiSupplierPromo>>> getPromos() async {
    ApiResp<DataWrapper> apiResp = await ApiCore.get('get-promos');

    ApiResp<List<ApiSupplierPromo>> apiResp2 =
        apiResp.mapResp((DataWrapper dataWrapper) {
      return (dataWrapper.data as List<dynamic>)
          .map(
              (json) => ApiSupplierPromo.fromJson(json as Map<String, dynamic>))
          .toList(growable: false);
    });
    return apiResp2;
  }

  static Future<ApiResp<DataWrapper>> logout() async {
    // never ApiResp.result
    return ApiCore.post<DataWrapper, String>('logout', '');
  }
}

T deserialize<T>(Map<String, dynamic> json) {
  switch (T) {
    case UserData:
      return UserData.fromJson(json) as T;
    case SpotSupplierSequence:
      return SpotSupplierSequence.fromJson(json) as T;
    case SupplierCatalog:
      return SupplierCatalog.fromJson(json) as T;
    case SupplierInfo:
      return SupplierInfo.fromJson(json) as T;
    case InvoicePreviewBinary:
      return InvoicePreviewBinary.fromJson(json) as T;
    case ApiRespInvoice:
      return ApiRespInvoice.fromJson(json) as T;
    case AuthorizedUserData:
      return AuthorizedUserData.fromJson(json) as T;
    case DataWrapper:
      return DataWrapper.fromJson(json) as T;
    case Spot:
      return Spot.fromJson(json) as T;
  }

  print("-------------------");
  print("Can not deserialize type:");
  print(T);

  throw "Can not deserialize type";
}

class DataWrapper<T> {
  final T data;

  DataWrapper(this.data) : assert(data != null);

  // wrapper is for primitives, so that have to be ok
  factory DataWrapper.fromJson(Map<String, dynamic> json) {
    return DataWrapper(json['data']);
  }

  // wrapper is for primitives, so that have to be ok
  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
      };
}
