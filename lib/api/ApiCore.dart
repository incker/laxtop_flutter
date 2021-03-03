import 'dart:async';
import 'dart:convert' show json, utf8;
import 'package:flutter/foundation.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiFieldErrors.dart';
import 'package:http/http.dart' as http;
import 'package:laxtop/api/models/ApiRequestError.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/storage/BasicData.dart';

abstract class ApiCore {
  static final String domain = (() {
    return 'https://laxtop.com/';
    if (kReleaseMode) {
      return 'https://laxtop.com/';
    } else {
      // IPv4 from ipconfig
      String ip = '192.168.1.186';
      return 'http://$ip:3000/';
    }
  })();

  static final String baseUrl = '${domain}api/user/';

  static Map<String, String> headers = {
    'x-api-key': '',
    'Accept': 'application/json',
  };

  static Map<String, String> postHeaders = {
    'x-api-key': '',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static void _setApiKey(String apiKey) {
    headers['x-api-key'] = apiKey;
    postHeaders['x-api-key'] = apiKey;
  }

  static void tokenChangeCallback() {
    _setApiKey(BasicData().token);
  }

  static Map<String, dynamic> handleResp(http.Response response) {
    String body = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      try {
        return json.decode(body);
      } catch (e) {
        throw (ApiRequestError(ApiError.ResponseNotJson, 200, '$e', body));
      }
    } else {
      if (response.statusCode == 401) {
        throw ApiRequestError(ApiError.NotLoggedIn, 401, '', body);
      }
      ApiRequestError apiRequestError = ApiRequestError(
          ApiError.ResponseStatusNotOk, response.statusCode, '', body);
      throw apiRequestError;
    }
  }

  static Future<Map<String, dynamic>> _get(String path) {
    return http.get(baseUrl + path, headers: headers).then(handleResp);
  }

  static Future<Map<String, dynamic>> _post(String path, String jsonBody) {
    return http
        .post(baseUrl + path, headers: postHeaders, body: jsonBody)
        .then(handleResp);
  }

  static Future<ApiResp<T>> post<T, D>(String url, D data) async {
    Map<String, dynamic> resp;
    try {
      resp = await ApiCore._post(url, json.encode(data));
    } on ApiRequestError catch (apiRequestError) {
      // нужно выводить принты а то без обработчика я даже не узнаю что ошибка
      print('Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print('$apiRequestError');
      return ApiResp.requestError(apiRequestError);
    } catch (error) {
      // нужно выводить принты а то без обработчика я даже не узнаю что ошибка
      print('Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print('$error');
      return ApiResp.requestError(
          ApiRequestError(ApiError.ResponseStatusNotOk, 0, '', '$error'));
    }

    if (resp['errors'] != null) {
      List<List<String>> errors = (resp['errors'] as List)
          .map((err) => (err as List)
              .map((field) => field as String)
              .toList(growable: false))
          .toList(growable: false);

      return ApiResp.fieldErrors(ApiFieldErrors(errors));
    }

    T resultData = deserialize<T>(resp);
    return ApiResp<T>.result(resultData);
  }

  static Future<ApiResp<T>> get<T>(String url) async {
    Map<String, dynamic> resp;

    try {
      resp = await ApiCore._get(url);
    } on ApiRequestError catch (apiRequestError) {
      // нужно выводить принты а то без обработчика я даже не узнаю что ошибка
      print('Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print('$apiRequestError');
      return ApiResp.requestError(apiRequestError);
    } catch (error) {
      // нужно выводить принты а то без обработчика я даже не узнаю что ошибка
      print('Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print('$error');
      return ApiResp.requestError(
          ApiRequestError(ApiError.ResponseStatusNotOk, 0, '', '$error'));
    }

    if (resp['errors'] != null) {
      return ApiResp.fieldErrors(ApiFieldErrors(resp['errors']));
    }

    T resultData = deserialize<T>(resp);
    return ApiResp<T>.result(resultData);
  }
}
