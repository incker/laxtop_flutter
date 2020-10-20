import 'package:flutter/material.dart';
import 'package:laxtop/libs/defaultWidgets.dart';

/// Common wrapper for FutureBuilder
/// has default onError and onWaiting functions

class FutureBuilderWrapper<T> extends StatelessWidget {
  final Future<T> future;
  final Function(BuildContext, T) onSuccess;
  final Function(BuildContext, Object) onError;
  final Function(BuildContext) onWaiting;

  FutureBuilderWrapper(
      {@required this.future,
      @required this.onSuccess,
      this.onError = defaultOnError,
      this.onWaiting = defaultOnWaiting,
      Key key})
      : super(key: key);

  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return onError(context, snapshot.error);
        } else if (snapshot.hasData) {
          T data = snapshot.data;
          return onSuccess(context, data);
        }
        return onWaiting(context);
      },
    );
  }
}
