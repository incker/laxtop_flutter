import 'package:flutter/material.dart';
import 'package:laxtop/api/models/ApiResp.dart';
import 'package:laxtop/libs/FutureBuilderWrapper.dart';
import 'package:laxtop/libs/defaultWidgets.dart';

/// Common wrapper for FutureBuilder
/// has default onError and onWaiting functions

class FutureApiResp<T> extends StatelessWidget {
  final Future<ApiResp<T>> future;
  final Function(BuildContext, T) onSuccess;
  final Function(BuildContext, Object) onError;
  final Function(BuildContext) onWaiting;

  FutureApiResp(
      {required this.future,
      required this.onSuccess,
      this.onError = defaultOnError,
      this.onWaiting = defaultOnWaiting,
      Key? key})
      : super(key: key);

  Widget build(BuildContext context) {
    return FutureBuilder<ApiResp<T>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<ApiResp<T>> snapshot) {
        if (snapshot.hasError) {
          return onError(context, snapshot.error!);
        } else if (snapshot.hasData) {
          // have to be always success
          final ApiResp<T> apiResp = snapshot.data!;
          return FutureBuilderWrapper<T>(
            future: apiResp.handle(context),
            onSuccess: onSuccess,
            onWaiting: onWaiting,
            onError: onError,
          );
        }
        return onWaiting(context);
      },
    );
  }
}
