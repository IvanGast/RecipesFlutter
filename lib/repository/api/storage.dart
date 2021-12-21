import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage{
  final _storage = FirebaseStorage.instance;

  Future<List<String>> addImages(List<File> images, String recipeId) =>
      Future.wait(images.map((img) async {
        String imageName = img.path
            .substring(img.path.lastIndexOf("/"), img.path.lastIndexOf("."))
            .replaceAll("/", "");
        final byteData = img.readAsBytesSync();
        await img.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        await _storage.ref('/images/$recipeId/$imageName').putFile(img);
        final String name = img.path
            .substring(img.path.lastIndexOf("/"), img.path.lastIndexOf("."));
        return name;
      }).toList());
}
