import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String errorText,
    {errorTitle: 'Что-то не так 😔'}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          errorTitle,
          style: TextStyle(color: Colors.red),
        ),
        content: SelectableText(errorText),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
