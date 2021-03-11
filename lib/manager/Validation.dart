import 'dart:async';

mixin Validation {
  static String notEmpty(String value) {
    if (value == '') {
      return 'Поле не должно быть пустым';
    }
    return '';
  }

  static String validateAmount(String value) {
    RegExp regExp = RegExp(r'\d');
    if (!regExp.hasMatch(value)) {
      return 'Введите целое натуральное число';
    } else if (value.startsWith('-')) {
      return 'Не может быть отрицательным';
    } else if (value.contains('.') || value.contains(',')) {
      return 'Не может быть дробным';
    }
    return '';
  }

  static String Function(String) getSpaceCleaner() {
    final RegExp regex = RegExp(r'\s+');
    return (value) => value.trim().replaceAll(regex, ' ');
  }

  static StreamTransformer<String, String> newStreamTransformer(
      String Function(String) func) {
    return StreamTransformer<String, String>.fromHandlers(
        handleData: (String value, sink) {
      String error = func(value);
      if (error == '') {
        sink.add(value);
      } else {
        sink.add(value);
        sink.addError(error);
      }
    });
  }
}
