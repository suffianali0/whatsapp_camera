import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

enum ImageType { file, network, asset }

class ViewImage extends StatefulWidget {
  ///
  /// image path: network url, file path or asset
  ///
  final String image;

  ///
  /// define the image type
  ///
  final ImageType imageType;
  const ViewImage({
    super.key,
    required this.image,
    this.imageType = ImageType.file,
  });

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: PhotoView(
        enablePanAlways: true,
        imageProvider: imageProvider,
        maxScale: 3.0,
        onScaleEnd: (context, details, controllerValue) {
          var pixelsPerSecond2 = details.velocity.pixelsPerSecond;
          var position = controllerValue.position;
          log('${pixelsPerSecond2.dx} ${pixelsPerSecond2.dy} ${position.dx} ${position.dy}',
              name: 'controller_values');

          if (pixelsPerSecond2.dx < 0 ||
              pixelsPerSecond2.dy < 0 ||
              position.dx < 0 ||
              position.dy < 0) {
            // Navigator.pop(context);
          }
        },
      ),
    );
  }

  ImageProvider get imageProvider {
    if (widget.imageType == ImageType.file) {
      return FileImage(File(widget.image));
    } else if (widget.imageType == ImageType.network) {
      return NetworkImage(widget.image);
    } else {
      return AssetImage(widget.image);
    }
  }
}
