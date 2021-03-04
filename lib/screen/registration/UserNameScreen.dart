import 'package:flutter/material.dart';
import 'package:laxtop/libs/Observer.dart';
import 'package:laxtop/libs/RxTextField.dart';
import 'package:laxtop/manager/InputFieldManager.dart';
import 'package:laxtop/manager/Validation.dart';

Future<String> inputUserName(BuildContext context) async {
  return InputFieldManager('', validation: Validation.notEmpty)
      .manage((InputFieldManager inputAmountManager) async {
    String? name = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
          builder: (context) => _UserNameScreen(
                inputAmountManager,
              )),
    );
    return name ?? '';
  });
}

class _UserNameScreen extends StatelessWidget {
  final InputFieldManager inputNameManager;

  _UserNameScreen(this.inputNameManager, {Key? key}) : super(key: key);

  void apply(BuildContext context) {
    String value = inputNameManager
        .value()
        .trim()
        .replaceAllMapped(RegExp(r'\s+'), (Match m) => ' ');
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваше Имя'),
        actions: [
          Observer<String>(
            stream: inputNameManager.stream$,
            onSuccess: (BuildContext context, String name) {
              return name.isEmpty
                  ? Container()
                  : FlatButton(
                      key: ObjectKey(0),
                      textColor: Colors.white,
                      onPressed: () {
                        apply(context);
                      },
                      child: Text('Готово',
                          style: const TextStyle(fontSize: 20.0)),
                    );
            },
            onError: (BuildContext context, Object error) => Container(),
          ),
        ],
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                Text(
                  'Как вас зовут?',
                  style: TextStyle(fontSize: 20.0, color: Colors.grey[800]),
                ),
                SizedBox(height: 5.0),
                Text(
                  '(Имя для поставщиков)',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                ),
                RxTextField<String>(
                  autofocus: true,
                  subscribe: inputNameManager.stream$,
                  dispatch: inputNameManager.inField.add,
                  // textAlign: TextAlign.center,
                  onSubmitted: (value) {
                    apply(context);
                  },
                  style: TextStyle(fontSize: 40.0),
                ),
                SizedBox(height: 50.0),
              ],
            )),
      ),
    );
  }
}
