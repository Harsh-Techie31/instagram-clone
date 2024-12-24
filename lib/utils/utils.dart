import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

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


Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  
  // print('No image selected');
  return null;
}


Future<Uint8List> networkImageToUint8List(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // The bodyBytes contain the image data in Uint8List format
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image, Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching image: $e');
  }
}

