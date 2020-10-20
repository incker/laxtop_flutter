class PreCache<T> {
  T _data;

  T data(T Function() getData) {
    return _data ?? (_data = getData());
  }

  T forceSet(T data) {
    return (_data = data);
  }

  void drop() {
    _data = null;
  }
}
