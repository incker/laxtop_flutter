import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laxtop/libs/Observer.dart';
import 'package:laxtop/manager/FileUploadManager.dart';

Future<String> getSpotImage(BuildContext context) async {
  return FileUploadManager()
      .manage<String>((FileUploadManager fileUploadManager) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => _SpotImagePickerScreen(fileUploadManager)),
    );
  });
}

class _SpotImagePickerScreen extends StatelessWidget {
  final FileUploadManager fileUploadManager;

  _SpotImagePickerScreen(this.fileUploadManager, {Key key})
      : assert(fileUploadManager != null),
        super(key: key);

  // omitted

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    PickedFile file = await picker.getImage(source: ImageSource.gallery);
    if (file != null) {
      fileUploadManager.inFile.add(File(file.path));
    }
  }

  void _pickImageFromCamera() async {
    final picker = ImagePicker();
    PickedFile file = await picker.getImage(source: ImageSource.camera);
    if (file != null) {
      fileUploadManager.inFile.add(File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Фото'),
        actions: <Widget>[
          Observer<File>(
            stream: fileUploadManager.stream$,
            onSuccess: (BuildContext context, File file) {
              return FlatButton(
                textColor: Colors.white,
                onPressed: () async {
                  String base64Image = base64Encode(await file.readAsBytes());
                  Navigator.pop(context, base64Image);
                },
                child: Text('Готово', style: const TextStyle(fontSize: 20.0)),
              );
            },
            onWaiting: (BuildContext context) {
              return Container();
            },
            onError: (BuildContext context, error) {
              return Container();
            },
          )
        ],
      ),
      body: Center(
        child: Observer<File>(
          stream: fileUploadManager.stream$,
          onSuccess: (BuildContext context, File file) {
            return Image.file(file);
          },
          onWaiting: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    // 9 / 16
                    width: 135,
                    height: 240,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.grey[600]),
                    ),
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: Colors.grey[400],
                      size: 40.0,
                    ),
                  ),
                ),
                Text(
                  'Загрузите вертикальное изображение',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                ),
                SizedBox(height: 100.0),
              ],
            );
          },
          onError: (BuildContext context, error) {
            return Text(
              'Pick image error: $error',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _pickImageFromGallery,
            heroTag: 'gallery',
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.photo_library),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: _pickImageFromCamera,
              heroTag: 'camera',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}

/*
// todo разобраться что за дичь retrieveLostData и вернуть
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        return;
      } else {
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }
   */
