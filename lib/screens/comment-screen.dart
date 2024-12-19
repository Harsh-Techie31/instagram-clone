import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user-models.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/comment-card.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentScreen extends StatefulWidget {
  final String postID;
  final Userm user;
  const CommentScreen({super.key , required this.postID,required this.user});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  // DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // print('Formatted Date: $formattedDate'); // Output: 2024-12-20

  // Format the time
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
  // print('Formatted Time: $formattedTime'); // Output: 14:30:45

  // Combine date and time
  String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  // Dummy  username
  // final String username = "Username11"; 

  // To store comments
  // List<String> comments = ["Great post!", "Nice photo!"];
  
  void addComment() async {
    print("ADD COMMENT CALLED");
    if (_commentController.text.isNotEmpty) {
      try {
        final commentData = {
          "pfp": Supabase.instance.client.storage
              .from('user-images')
              .getPublicUrl('pfp/${widget.user.uid}.jpeg'),
          "username": widget.user.username,
          "comment": _commentController.text,
          "timestamp": formattedDateTime,
        };

        await FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.postID)
            .update({
          "comments": FieldValue.arrayUnion([commentData])
        });

        _commentController.clear(); // Clear input field
      } catch (e) {
        print("Error adding comment: $e");
      }
    }
    print("ADD COMMENT CALLED22");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").doc(widget.postID).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        // builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot ){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(
              child: Text("No comments yet!"),
            );
          }

          final comments = snapshot.data!.data()!["comments"] as List<dynamic>?;
          if (comments == null || comments.isEmpty) {
            return const Center(
              child: Text("No comments yet!"),
            );
          }
          return ListView.builder(
            cacheExtent: 9999,
            itemCount: comments.length,
            itemBuilder: (context,index) => CommentCard(userM: widget.user,postId: widget.postID,
              comment :comments[index],
            ));
        }),

      bottomNavigationBar: BottomAppBar(
        color: mobileBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top : 8, right: 8,left : 2),
          child: Row(
            children: [
              // Profile Picture (CircleAvatar)
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    Supabase.instance.client.storage
              .from('user-images')
              .getPublicUrl('pfp/${widget.user.uid}.jpeg')),
              ),
              const SizedBox(width: 8.0), // Spacing between avatar and text field

              // Comment TextField with the username hint
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Comment as ${widget.user.username}",
                    hintStyle: const TextStyle(
                      color:  Color.fromARGB(255, 202, 199, 199)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    // filled: true,
                    // fillColor: Colors.white,
                  ),
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),

              const SizedBox(width: 8.0), // Spacing between TextField and Button

              // Post Button
              IconButton(
                onPressed: addComment, // Add the new comment
                icon:const Icon(Icons.send),
                color: Colors.blue, // Blue color for the post button
              ),
            ],
          ),
        ),
      ),
    );
  }
}
