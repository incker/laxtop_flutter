import 'package:laxtop/api/ApiCore.dart';
import 'package:hive/hive.dart';

part 'ImageId.g.dart';

@HiveType(typeId: 15)
class ImageId {
  static final Map<int, ImageId> _cache = {};
  @HiveField(0)
  final int id;
  final String _path;

  const ImageId._inner(this.id, this._path) : assert(_path != null);

  factory ImageId(int imageId) {
    if (_cache.containsKey(imageId)) {
      return _cache[imageId]!;
    } else {
      final String radix36Id = imageId.toRadixString(36).padLeft(7, '0');
      return _cache[imageId] = ImageId._inner(
          imageId,
          radix36Id.substring(0, 3) +
              '/' +
              radix36Id.substring(3, 5) +
              '/' +
              radix36Id.substring(5, 7));
    }
  }

  bool hasImage() => id != 0;

  bool hasNotImage() => id == 0;

  String filenameInCache() => '$id.jpg';

  String original() => '${ApiCore.domain}i/o/$_path.jpg';

  String thumbnail() => '${ApiCore.domain}i/t/$_path.jpg';
}



/*
TODO better?
abstract class ImageIdManager {
  static final Map<int, String> _cache = {};

  static idToPath(int imageId) => _cache.containsKey(imageId)
      ? _cache[imageId]!
      : _cache[imageId] = _idToPath(imageId);

  static String _idToPath(int imageId) {
    final String radix36Id = imageId.toRadixString(36).padLeft(7, '0');
    return radix36Id.substring(0, 3) +
        '/' +
        radix36Id.substring(3, 5) +
        '/' +
        radix36Id.substring(5, 7);
  }
}
*/