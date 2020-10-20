class Option<T> {
  T data;

  Option({this.data});

  bool get isSome => data != null;

  bool get isNone => data == null;
}
