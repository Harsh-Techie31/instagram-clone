import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/post-models.dart';
import 'package:instagram_flutter/models/user-models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sup;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Userm> getUserInfo() async {
    User u = _auth.currentUser!;
    // print("HERE IN GETUSER FUNCTION RIGHT NOW #######################");
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(u.uid).get();
    // print("#############################Fetched user data: ${snap.data()}");

    return Userm.fromsnap(snap);
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required Uint8List file}) async {
    var res = "Some error occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final path = 'pfp/${cred.user!.uid}.jpeg';
        // print("REACHED");
        await sup.Supabase.instance.client.storage
            .from('user-images')
            .uploadBinary(path, file);

        Userm hey = Userm(
            email: email,
            uid: cred.user!.uid,
            username: username,
            followers: [],
            following: []);

        await _firestore
            .collection("users")
            .doc(cred.user?.uid)
            .set(hey.toJson());

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadImg({
    required String username,
    required String description,
    required String postId,
    required String postUrl,
    required String pfpLink,
    required String uid,
    required String time,
    required List likes,
  }) async {
    var res = "Some error occured1111";
    print("REACHED BEFORE THE FIRESTORE CALL00000");

    try {
      if (username.isNotEmpty && description.isNotEmpty && postId.isNotEmpty) {
        // UserCredential cred = await _auth.createUserWithEmailAndPassword(
        //     email: email, password: password);
        // final path = 'pfp/${cred.user!.uid}.jpeg';
        // // print("REACHED");
        // await sup.Supabase.instance.client.storage
        //     .from('user-images')
        //     .uploadBinary(path, file);

        Postm post = Postm(
          username: username,
          description: description,
          postId: postId,
          postUrl: postUrl,
          pfpLink: pfpLink,
          uid: uid,
          time: time,
          likes: likes,
        );
        // print("REACHED BEFORE THE FIRESTORE CALL");
        await _firestore
            .collection("posts") // Main collection
            .doc(postId) // Document under "posts" named as uid
            // .collection("user-posts") // Subcollection inside the uid document
            // .doc(postId) // Document under "user_posts" with postId as the ID
            .set(post.toJson()); // Save the data
        // print("REACHED BEFORE THE FIRESTORE CALL2222");
        res = "success";
      }else{
        // print("REACHED BEFORE THE FIRESTORE CALLCHIRTSMAS");
      }
    } catch (err) {
      // print("REACHED BEFORE THE FIRESTORE CALL3333");
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "sucess";
      } else {
        res = "Fill all the details!!";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
