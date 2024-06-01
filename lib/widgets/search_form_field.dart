import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  SearchTextField(
      {required this.controller,
      required this.tittle,
      this.fillColor,
      this.searchIconColor,
      this.onPress,
      this.border});
  TextEditingController? controller;
  Color? fillColor, border, searchIconColor;
  void Function()? onPress;
  String? tittle;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: tittle,
        hintStyle: TextStyle(color: border ?? Colors.white),
        suffixIcon: InkWell(
          onTap: onPress,
          child: Icon(
            Icons.search,
            color: searchIconColor ?? Colors.white,
          ),
        ),
        fillColor: fillColor ?? Colors.blue[800]!.withOpacity(0.5),
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: border ?? Colors.white),
            borderRadius: BorderRadius.circular(40.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: border ?? Colors.white),
            borderRadius: BorderRadius.circular(40.0)),
      ),
    );
  }
}
