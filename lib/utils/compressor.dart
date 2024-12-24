import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Compress image to below 2MB in a background isolate
Future<Uint8List> compressImageToBelow2MB(Uint8List imageBytes) async {
  return await compute(_compressImage, imageBytes);
}

/// Compression logic runs in a background thread
Uint8List _compressImage(Uint8List imageBytes) {
  const int maxSizeInBytes = 500 * 1024; 

  // Decode the image to get its original format
  img.Image? originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    throw Exception("Failed to decode the image.");
  }

  int low = 10;   // Minimum quality
  int high = 100; // Maximum quality
  Uint8List? bestCompressed;

  while (low <= high) {
    int mid = (low + high) ~/ 2;

    // Compress the image with the current quality
    Uint8List compressedBytes = Uint8List.fromList(
      img.encodeJpg(originalImage, quality: mid),
    );

    // Check the size of the compressed image
    if (compressedBytes.lengthInBytes <= maxSizeInBytes) {
      bestCompressed = compressedBytes;
      high = mid - 1; // Try for a smaller size
    } else {
      low = mid + 1; // Increase quality to reduce compression
    }
  }

  if (bestCompressed == null) {
    throw Exception("Unable to compress image below 2MB.");
  }

  return bestCompressed;
}
