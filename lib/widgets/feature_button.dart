import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  final String label;
  final Color? boxColor;
  final Color? textColor;
  final VoidCallback onTap;

  const FeatureButton({
    super.key,
    required this.label,
    this.boxColor,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 350,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: boxColor,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor ?? Colors.black),
          ),
        ),
      ),
    );
  }
}
