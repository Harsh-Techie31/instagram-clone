import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? func;
  final Color bg;
  final Color borderC;
  final Color textColor;
  final String label;
  const FollowButton({
    super.key,
    this.func,
    required this.borderC,
    required this.textColor,
    required this.label,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Set a reasonable height for the button
      width: 250,
      child: TextButton(
        onPressed: func,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // No padding needed
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: borderC),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
