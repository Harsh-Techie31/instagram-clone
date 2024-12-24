import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Future<Uint8List> compress1Image(Uint8List imageBytes) async {
  return await compute(_compressImage, imageBytes);
}

Uint8List _compressImage(Uint8List imageBytes) {
  const int maxWidth = 1024; // Maximum width for image (adjust as needed)
  const int maxHeight = 1024; // Maximum height for image (adjust as needed)
  const int minQuality = 60; // Minimum quality for compression
  const int maxQuality = 85; // Maximum quality for compression
  
  // Decode the image
  img.Image? originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    throw Exception("Failed to decode the image.");
  }

  print("Original image size: ${imageBytes.lengthInBytes} bytes");
  
  // Resize if the image is too large
  if (originalImage.width > maxWidth || originalImage.height > maxHeight) {
    print("Resizing image...");
    originalImage = img.copyResize(originalImage, width: maxWidth, height: maxHeight);
  }

  // Try different qualities (binary search approach for a more flexible strategy)
  int low = minQuality;
  int high = maxQuality;
  Uint8List? bestCompressed;

  while (low <= high) {
    int mid = (low + high) ~/ 2;
    print("Trying quality: $mid...");

    // Compress the image
    Uint8List compressedBytes = Uint8List.fromList(
      img.encodeJpg(originalImage, quality: mid),
    );

    print("Compressed image at quality $mid: ${compressedBytes.lengthInBytes} bytes");

    // Check if the image is small enough
    if (compressedBytes.lengthInBytes <= 600 * 1024) { // Allow max size of 600KB
      bestCompressed = compressedBytes;
      high = mid - 1; // Try for a smaller size
      print("Compression successful, trying smaller quality.");
    } else {
      low = mid + 1; // Increase quality for a better result
      print("Compression still too large, trying higher quality.");
    }
  }

  if (bestCompressed == null) {
    throw Exception("Unable to compress image to an acceptable size.");
  }

  print("Final compressed image size: ${bestCompressed.lengthInBytes} bytes");
  return bestCompressed;
}
