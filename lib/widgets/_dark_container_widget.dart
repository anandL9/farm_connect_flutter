import 'package:flutter/material.dart';

class DarkContainerWidget extends StatelessWidget {
  final String title, subtitle;

  const DarkContainerWidget({Key? key, this.title = '', this.subtitle = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          color: Colors.black26,
          borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Column(
        children: [
          Text(
            '$subtitle:',
            style: const TextStyle(fontSize: 12, color: Colors.white60),
          ),
          Text(title),
        ],
      ),
    );
  }
}
