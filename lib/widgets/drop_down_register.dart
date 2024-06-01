import 'package:flutter/material.dart';

class DropdownRegister extends StatelessWidget {
  DropdownRegister(
      {required this.list,
      required this.tittle,
      required this.onChange,
      required this.dropdownValue});
  List<String> list;
  String tittle;
  ValueChanged<String?> onChange;
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      padding: const EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[400]!)),
      child: DropdownButton<String>(
        value: dropdownValue == "" ? null : dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 2,
        underline: Container(),
        hint: Text(
          tittle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        isExpanded: true,
        onChanged: onChange,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }
}
