import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExploreImages extends StatelessWidget {
  const ExploreImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection("posts").get(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts available'),
            );
          }

          // Retrieve image URLs from Firestore
          final List<String> images = snapshot.data!.docs
              .map((doc) => doc.data()['postUrl'] as String)
              .toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns
              crossAxisSpacing: 8, // Horizontal spacing between tiles
              mainAxisSpacing: 8, // Vertical spacing between tiles
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _buildGridTile(images[index]);
            },
          );
        },
      ),
    );
  }
}

Widget _buildGridTile(String imageUrl) {
  return ClipRRect(
    // borderRadius: BorderRadius.circular(8), // Optional for rounded corners
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover, // Fit the image within the grid tile
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.error, color: Colors.red),
        );
      },
    ),
  );
}
