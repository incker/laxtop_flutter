import 'package:laxtop/manager/Manager.dart';
import 'package:laxtop/manager/Validation.dart';
import 'package:rxdart/rxdart.dart';

class InputFieldManager extends Manager {
  final BehaviorSubject<String> _fieldValue;
  final Stream<String> stream$;

  Sink<String> get inField => _fieldValue.sink;

  bool get hasValue => _fieldValue.hasValue;

  factory InputFieldManager(String defaultValue,
      {String Function(String) validation}) {
    final BehaviorSubject<String> _fieldValue =
        BehaviorSubject<String>.seeded(defaultValue);

    Stream<String> stream = (validation == null)
        ? _fieldValue.stream
        : _fieldValue.stream
            .transform(Validation.newStreamTransformer(validation));

    return InputFieldManager._internal(_fieldValue, stream);
  }

  InputFieldManager._internal(this._fieldValue, this.stream$);

  String value() {
    return _fieldValue.value;
  }

  void addError(String error) {
    _fieldValue.addError(error);
  }

  Future<T> manage<T>(Future<T> Function(InputFieldManager) func) async {
    T data = await func(this);
    this.dispose();
    return data;
  }

  void dispose() {
    _fieldValue.close();
  }
}
