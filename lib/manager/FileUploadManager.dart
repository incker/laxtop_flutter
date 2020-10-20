import 'dart:io';
import 'package:laxtop/manager/Manager.dart';
import 'package:rxdart/rxdart.dart';

class FileUploadManager extends Manager {
  final BehaviorSubject<File> _subjectFile = BehaviorSubject<File>();

  Stream<File> get stream$ => _subjectFile.stream;

  Sink<File> get inFile => _subjectFile.sink;

  bool get hasValue => _subjectFile.hasValue;

  File value() {
    return _subjectFile.value;
  }

  void addError(File error) {
    _subjectFile.addError(error);
  }

  Future<T> manage<T>(Future<T> Function(FileUploadManager) func) async {
    T data = await func(this);
    this.dispose();
    return data;
  }

  void dispose() {
    _subjectFile.close();
  }
}
