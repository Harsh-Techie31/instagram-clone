import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List> compressImageToBelow2MB(Uint8List imageBytes) async {
  const int maxSizeInBytes = 500 * 1024; // 2MB

  // Decode the image to get its original format
  img.Image? originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    throw Exception("Failed to decode the image.");
  }

  int quality = 100; // Start with the best quality
  Uint8List compressedBytes = Uint8List.fromList(imageBytes);

  while (compressedBytes.lengthInBytes > maxSizeInBytes && quality > 10) {
    quality -= 10; // Reduce quality by 10% each iteration

    // Compress the image to JPEG with the current quality
    compressedBytes = Uint8List.fromList(
      img.encodeJpg(originalImage, quality: quality),
    );
  }

  if (compressedBytes.lengthInBytes > maxSizeInBytes) {
    throw Exception("Unable to compress image below 2MB.");
  }

  return compressedBytes;
}