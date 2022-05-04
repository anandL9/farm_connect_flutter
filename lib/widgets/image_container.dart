import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final void Function() onCancelTap, onViewTap, onAddTap;

  const ImageContainer(
      {Key? key,
      required this.imagePath,
      required this.onCancelTap,
      required this.onViewTap,
      required this.onAddTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, top: 5.0),
      child: Container(
        width: 80,
        height: 100,
        decoration: DottedDecoration(
            shape: Shape.box,
            strokeWidth: 2,
            borderRadius: BorderRadius.circular(5.0)),
        child: imagePath != ''
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(imagePath),
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: onCancelTap,
                      child: const Icon(
                        Icons.cancel_outlined,
                        size: 15,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 5,
                      left: 5,
                      child: GestureDetector(
                        onTap: onViewTap,
                        child: const Icon(
                          CupertinoIcons.eye,
                          size: 17,
                        ),
                      )),
                ],
              )
            : Center(
                child: IconButton(
                  onPressed: onAddTap,
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              ),
      ),
    );
  }
}
