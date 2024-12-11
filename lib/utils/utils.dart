import 'package:flutter/material.dart';

void showSnackBar(
  String content, 
  BuildContext context, 
  [Duration duration = const Duration(seconds: 2)] // Optional positional parameter
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: duration, // Use the passed duration if provided
    ),
  );
}
