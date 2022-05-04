import 'dart:io';
import 'package:flutter/material.dart';

void enlargeImage({required String imageName, required BuildContext context}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: InteractiveViewer(
                    panEnabled: false,
                    minScale: 0.1,
                    maxScale: 5,
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'hero_image',
                      child: Image.file(
                        File(imageName),
                      ),
                    ),
                  ),
                ),
              )));
}
