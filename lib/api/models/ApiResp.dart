import 'package:flutter/material.dart';
import 'package:laxtop/api/Api.dart';
import 'package:laxtop/api/models/ApiFieldErrors.dart';
import 'package:laxtop/api/models/ApiRequestError.dart';
import 'package:laxtop/libs/showErrorDialog.dart';
import 'package:laxtop/storage/HiveHelper.dart';

class ApiResp<T> {
  final T? _result;
  final ApiFieldErrors? _fieldError;
  final ApiRequestError? _requestError;

  ApiResp.result(T _result)
      : this._result = _result,
        _fieldError = null,
        _requestError = null;

  ApiResp.fieldErrors(ApiFieldErrors _fieldError)
      : this._fieldError = _fieldError,
        _result = null,
        _requestError = null;

  ApiResp.requestError(ApiRequestError _requestError)
      : this._requestError = _requestError,
        _result = null,
        _fieldError = null;

  // for DataWrapper
  ApiResp<E> unwrap<E>() {
    if (_result != null) {
      E unwrappedResult = (_result as DataWrapper).data as E;
      return ApiResp.result(unwrappedResult);
    }
    if (_fieldError != null) return ApiResp.fieldErrors(_fieldError!);
    if (_requestError != null) return ApiResp.requestError(_requestError!);
    return unreachableError<E>();
  }

  // mutate result type
  ApiResp<E> mapResp<E>(E Function(T) func) {
    if (_result != null) {
      E res = func(_result!);
      return ApiResp.result(res);
    }
    if (_fieldError != null) return ApiResp.fieldErrors(_fieldError!);
    if (_requestError != null) return ApiResp.requestError(_requestError!);
    return unreachableError<E>();
  }

  ApiResp<E> map<E>(E Function(T) func) {
    if (_result != null) {
      E newResult = func(_result!);
      return ApiResp.result(newResult);
    }
    if (_fieldError != null) return ApiResp.fieldErrors(_fieldError!);
    if (_requestError != null) return ApiResp.requestError(_requestError!);
    return unreachableError<E>();
  }

  ApiResp<E> unreachableError<E>() {
    return ApiResp<E>.fieldErrors(ApiFieldErrors([
      ['other', 'unreachable ApiResp unwrap']
    ]));
  }

  /*
  Future<bool> handleResp(
      {required Function(T) onResult,
      Function(ApiFieldErrors) onFieldError,
      Function(ApiRequestError) onRequestError,
      Function() onAnyError}) async {
    if (result != null) {
      await onResult(result);
      return true;
    } else if (fieldError != null && onFieldError != null) {
      await onFieldError(fieldError);
    } else if (requestError != null && onRequestError != null) {
      onRequestError(requestError);
    } else if (onAnyError != null) {
      await onAnyError();
    }
    return false;
  }
  */

  Future<T?> handle(BuildContext? context) async {
    if (_result != null) {
      return _result!;
    } else if (_fieldError != null) {
      for (List<String> error in _fieldError!.errors) {
        if (context != null) {
          await showErrorDialog(context, '___${error[1]}',
              errorTitle: error[0]);
        }
      }
    } else if (_requestError != null) {
      if (_requestError!.statusCode == 401) {
        // logOut
        if (context != null) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        await HiveHelper.clean(newToken: '');
      } else {
        if (context != null) {
          await showErrorDialog(context, _requestError!.apiError.toString(),
              errorTitle: 'response: ${_requestError!.statusCode}');
        }
      }
    }
    return null;
  }

  Future<void> rawResultAccess(Future<void> Function(T) func) async {
    if (_result != null) {
      await func(_result!);
    }
  }
}
