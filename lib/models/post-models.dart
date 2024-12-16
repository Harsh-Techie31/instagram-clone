import 'package:cloud_firestore/cloud_firestore.dart';

class Postm {
  final String username;
  final String description;
  final String postId;
  final String postUrl;
  final String pfpLink;
  final String uid;
  final String time;
  final List likes;

  const Postm({
    required this.username,
    required this.description,
    required this.postId,
    required this.postUrl,
    required this.pfpLink,
    required this.uid,
    required this.time,
    required this.likes,
  });

  // Convert Postm object to JSON (Map)
  Map<String, dynamic> toJson() => {
        "username": username,
        "description": description,
        "postId": postId,
        "postUrl": postUrl,
        "pfpLink" : pfpLink,
        "uid": uid,
        "time": time,
        "likes": likes,
      };

  // Convert DocumentSnapshot to Postm object
  static Postm fromsnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Postm(
      username: snapshot['username'] ?? '',         // Default to empty string
      description: snapshot['description'] ?? '',   // Default to empty string
      postId: snapshot['postId'] ?? '',             // Default to empty string
      postUrl: snapshot['postUrl'] ?? '',           // Default to empty string
      pfpLink: snapshot['pfpLink'] ?? '',           // Default to empty string
      uid: snapshot['uid'] ?? '',                   // Default to empty string
      time: snapshot['time'] ?? '',                 // Default to empty string
      likes: snapshot['likes'] ?? [],               // Default to empty list
    );
  }
}
