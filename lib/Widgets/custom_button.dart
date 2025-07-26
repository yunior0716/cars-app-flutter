import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.height,
    required this.text,
    required this.onPressed,
  });

  final double height;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue)),
            onPressed: () => onPressed(),
            child: Text(text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ))),
      ),
    );
  }
}
