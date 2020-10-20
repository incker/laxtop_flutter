import 'package:flutter/material.dart';

Widget defaultOnError(BuildContext context, Object error) =>
    Text(error.toString());

Widget defaultOnWaiting(BuildContext context) =>
    Center(child: CircularProgressIndicator());
