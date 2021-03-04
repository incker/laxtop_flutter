import 'package:flutter/material.dart';
import 'package:laxtop/libs/defaultWidgets.dart';

/// Common wrapper for StreamBuilder
/// has default onError and onWaiting functions

class Observer<T> extends StatelessWidget {
  final Stream<T> stream;
  final Function(BuildContext, T) onSuccess;
  final Function(BuildContext, Object) onError;
  final Function(BuildContext) onWaiting;

  Observer(
      {required this.stream,
      required this.onSuccess,
      this.onError = defaultOnError,
      this.onWaiting = defaultOnWaiting,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return onError(context, snapshot.error!);
        } else if (snapshot.hasData) {
          T data = snapshot.data!;
          return onSuccess(context, data);
        }
        return onWaiting(context);
      },
    );
  }
}
