import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  const Button(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Text(text),
    );
  }
}
