import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:instagram_flutter/models/user-models.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> comment;
  final String postId;
  final Userm userM;

  const CommentCard({
    super.key,
    required this.comment,
    required this.postId,
    required this.userM,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
    
  }

  // Add a comment to Firestore
  

  // Format timestamp
  // String formatTimestamp(Timestamp? timestamp) {
  //   if (timestamp == null) return "Just now";
  //   final dateTime = timestamp.toDate();
  //   return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  // }

  @override
  Widget build(BuildContext context) {
    final commentData = widget.comment;

    return Card(
      color: mobileBackgroundColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(commentData["pfp"] ??
                  "https://via.placeholder.com/150"), // Fallback image
            ),
            const SizedBox(width: 12.0),

            // Username, Date, and Comment
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Username
                      Text(
                        commentData["username"] ?? "Unknown User",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // Date
                      Text(
                        (commentData["timestamp"]),
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),

                  // Comment Text
                  Text(
                    commentData["comment"] ?? "No comment fetched",
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Like Button
            IconButton(
              onPressed: () => print("Liked comment!"), // Placeholder function
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
