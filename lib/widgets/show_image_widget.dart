import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/image_utils.dart';

class ShowImageWidget extends StatelessWidget {
  final String imageName;

  const ShowImageWidget({Key? key, this.imageName = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Visibility(
        visible: imageName.isNotEmpty,
        child: GestureDetector(
          onTap: () {
            enlargeImage(
                imageName: imageName,
                context: context);
          },
          child: Image.file(
            File(imageName),
            fit: BoxFit.fill,
            height: 120,
            width: 120,
          ),
        ),
      ),
    );
  }
}
