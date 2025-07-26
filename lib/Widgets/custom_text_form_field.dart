import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.labelText,
    this.paddingTop = 10.0,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String labelText;
  final IconData icon;
  final TextInputType keyboardType;
  final double paddingTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: paddingTop, bottom: 10, left: 15, right: 15),
      child: TextFormField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.blue),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.blue[500]),
              prefixIcon: Icon(
                icon,
                color: Colors.blue,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 3,
                ),
              ))),
    );
  }
}
