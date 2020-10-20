void dedup<T>(List<T> list, {removeLast: true}) {
  int shift = removeLast ? 1 : 0;
  T compareItem;
  for (int i = list.length - 1; i >= 0; i--) {
    if (compareItem == (compareItem = list[i])) {
      list.removeAt(i + shift);
    }
  }
}

void dedupBy<T, I>(List<T> list, I Function(T) compare, {removeLast: true}) {
  int shift = removeLast ? 1 : 0;
  I compareItem;
  for (int i = list.length - 1; i >= 0; i--) {
    if (compareItem == (compareItem = compare(list[i]))) {
      list.removeAt(i + shift);
    }
  }
}
