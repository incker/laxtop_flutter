import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laxtop/libs/RxTextField.dart';
import 'package:laxtop/manager/InputFieldManager.dart';
import 'package:laxtop/manager/Validation.dart';
import 'package:laxtop/model/Product.dart';

Future<int?> changeProductAmount(
    BuildContext context, Product product, int amount) async {
  if (amount == 0) {
    amount = 1;
  }
  return InputFieldManager(amount.toString(),
          validation: Validation.validateAmount)
      .manage<int?>((InputFieldManager inputAmountManager) {
    return Navigator.push<int?>(
      context,
      MaterialPageRoute(
          builder: (context) => SelectProductAmountScreen(
                product,
                inputAmountManager,
              )),
    );
  });
}

class SelectProductAmountScreen extends StatelessWidget {
  final InputFieldManager inputAmountManager;
  final Product product;
  final TextEditingController _textFieldController;

  factory SelectProductAmountScreen(
      Product product, InputFieldManager inputAmountManager,
      {Key? key}) {
    final TextEditingController textFieldController = TextEditingController();
    textFieldController.text = inputAmountManager.value();

    textFieldController.selection = TextSelection(
        baseOffset: 0, extentOffset: textFieldController.text.length);

    return SelectProductAmountScreen._internal(
        textFieldController, product, inputAmountManager,
        key: key);
  }

  SelectProductAmountScreen._internal(
      this._textFieldController, this.product, this.inputAmountManager,
      {Key? key})
      : super(key: key);

  void apply(BuildContext context) {
    String value = _textFieldController.text
        .replaceAllMapped(RegExp(r'[^\d]'), (Match m) => '');

    int? amount = int.tryParse(value);
    if (amount != null) {
      Navigator.pop(context, amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Количество товара'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(product.name,
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 30.0),
              Text(
                'Количество:',
                style: TextStyle(fontSize: 20.0),
              ),
              Stack(alignment: const Alignment(1.0, 0.0), children: <Widget>[
                RxTextField<String>(
                  autofocus: true,
                  controller: _textFieldController,
                  subscribe: inputAmountManager.stream$,
                  dispatch: inputAmountManager.inField.add,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'\d'))
                  ],
                  onSubmitted: (value) {
                    apply(context);
                  },
                  style: TextStyle(fontSize: 40.0),
                ),
                FloatingActionButton(
                  backgroundColor: Color(0x00000000),
                  highlightElevation: 0.0,
                  child: Icon(
                    Icons.cancel,
                    size: 35.0,
                    color: Colors.grey[500],
                  ),
                  elevation: 0,
                  onPressed: _textFieldController.clear,
                ),
              ]),
              SizedBox(height: 50.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context, 0);
                        },
                        child: Text('Удалить позицию'),
                        color: Colors.brown,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: RaisedButton(
                        onPressed: () {
                          apply(context);
                        },
                        child: Text('Сохранить'),
                        color: Colors.blue,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
