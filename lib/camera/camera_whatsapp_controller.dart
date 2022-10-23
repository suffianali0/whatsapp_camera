import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

class WhatsAppCameraController extends ChangeNotifier {
  WhatsAppCameraController({this.multiple = false});
  final bool multiple;
  final selectedImages = <File>[];
  var images = <Medium>[];

  Future<void> inicialize() async {
    final albums = await PhotoGallery.listAlbums(mediumType: MediumType.image);
    final res = await Future.wait(albums.map((e) => e.listMedia()));
    final index = res.indexWhere((e) => e.album.name == 'All');
    if (index != -1) images.addAll(res[index].items);
    if (index == -1) {
      for (var e in res) {
        images.addAll(e.items);
      }
    }
    notifyListeners();
  }

  Future<void> openGallery() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: multiple,
      type: FileType.image,
    );
    if (res != null) {
      for (var element in res.files) {
        if (element.path != null) selectedImages.add(File(element.path!));
      }
    }
  }

  void captureImage(File file) {}
}
