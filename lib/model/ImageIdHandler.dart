import 'package:laxtop/api/ApiCore.dart';

abstract class ImageIdHandler {
  static final Map<int, String> _cache = {};

  int getImageId();

  String _idToPath() {
    int imageId = getImageId();
    return _cache.containsKey(imageId)
        ? _cache[imageId]!
        : _cache[imageId] = _idToPathTransform(imageId);
  }

  static String _idToPathTransform(int imageId) {
    final String radix36Id = imageId.toRadixString(36).padLeft(7, '0');
    return radix36Id.substring(0, 3) +
        '/' +
        radix36Id.substring(3, 5) +
        '/' +
        radix36Id.substring(5, 7);
  }

  bool hasImage() => getImageId() != 0;

  bool hasNotImage() => getImageId() == 0;

  String filenameInCache() => '${getImageId()}.jpg';

  String originalImage() => '${ApiCore.domain}i/o/${_idToPath()}.jpg';

  String thumbnailImage() => '${ApiCore.domain}i/t/${_idToPath()}.jpg';
}
