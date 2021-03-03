import 'dart:io';
import 'dart:typed_data';
import 'package:laxtop/model/SupplierPromo.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// image for tests
// 'http://via.placeholder.com/200x150'
// final directory = await getApplicationDocumentsDirectory();

class PromoCacheManager {
  static Directory _promoDir;

  static void setPromoDir(Directory promoDir) {
    _promoDir = promoDir;
  }

  Future<PromoCacheDiff> comparePromoIdsWithCache(List<int> promoIds) async {
    Set<String> promoFileNames =
        promoIds.map((int id) => id.toString()).toSet();

    List<FileSystemEntity> filesToDelete = [];
    Set<String> filesActual = {};

    Stream<FileSystemEntity> stream =
        _promoDir.list(recursive: false, followLinks: false);
    await for (FileSystemEntity entity in stream) {
      String fileNameWithoutExt = parseFileNameWithoutExt(entity.path);
      if (!promoFileNames.contains(fileNameWithoutExt)) {
        print('TO DELETE: ' + entity.path);
        filesToDelete.add(entity);
      } else {
        filesActual.add(fileNameWithoutExt);
      }
    }

    if (filesActual.length == promoFileNames.length) {
      return PromoCacheDiff(List(0), filesToDelete);
    }

    List<int> promosToDownload = [];

    for (int promoId in promoIds) {
      if (!filesActual.contains(promoId.toString())) {
        promosToDownload.add(promoId);
      }
    }

    return PromoCacheDiff(promosToDownload, filesToDelete);
  }

  /// FOR TESTS ONLY
  Future<List<String>> readAllFilesInCache() async {
    List<String> files = [];

    Stream<FileSystemEntity> stream =
        _promoDir.list(recursive: false, followLinks: false);
    await for (FileSystemEntity entity in stream) {
      files.add(entity.path);
    }

    return files;
  }

  static String parseFileNameWithoutExt(String path) {
    final String filename = p.basename(path);
    return filename.split('.').first;
  }

  Future<void> cacheIfNeeded(SupplierPromo supplierPromo) async {
    String filePath = await getFilePath(supplierPromo);
    return downloadFile(supplierPromo.fullUrl, filePath);
  }

  Future<String> getFilePath(SupplierPromo supplierPromo) async {
    final String filename = supplierPromo.imageId.filenameInCache();
    String filePath = p.join(_promoDir.path, filename);
    return filePath;
  }

  static Future<Uint8List> downloadFile(String url, String filePath) async {
    final resp = await http.get(url);
    final Uint8List bytes = resp.bodyBytes;
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    return bytes;
  }
}

class PromoCacheDiff {
  final List<int> promosToDownload;
  final List<FileSystemEntity> filesToDelete;

  PromoCacheDiff(this.promosToDownload, this.filesToDelete)
      : assert(filesToDelete != null),
        assert(promosToDownload != null);

  deleteExpired() {
    for (var file in filesToDelete) {
      // no need to wait
      file.delete();
    }
  }
}

// _getLocalFile good example
// https://stackoverflow.com/questions/49835623/how-to-load-images-with-image-file
