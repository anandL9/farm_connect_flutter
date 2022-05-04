import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final List<String> dataList;
  final String hintText;
  final void Function(String) onValueChanges;

  const DropDownWidget(
      {Key? key,
      required this.dataList,
      this.hintText = '',
      required this.onValueChanges})
      : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  // String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      hint: Text(widget.hintText),
      elevation: 16,
      onChanged: (String? newValue) {
        widget.onValueChanges(newValue!);
      },
      items: widget.dataList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
