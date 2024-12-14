import 'package:cloud_firestore/cloud_firestore.dart';

class Userm {
  final String email;
  final String uid;
  final String username;
  final List followers;
  final List following;

  const Userm({
    required this.email,
    required this.uid,
    required this.username,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "followers": followers,
        "following": following,
      };

  static Userm fromsnap(DocumentSnapshot snap) {
  var snapshot = snap.data() as Map<String, dynamic>;

  return Userm(
    email: snapshot['email'] ?? '',  // Default to an empty string if 'email' is null
    uid: snapshot['uid'] ?? '',      // Default to an empty string if 'uid' is null
    username: snapshot['username'] ?? '', // Default to an empty string if 'username' is null
    followers: snapshot['followers'] ?? [], // Default to an empty list if 'followers' is null
    following: snapshot['following'] ?? [], // Default to an empty list if 'following' is null
  );
}

}
