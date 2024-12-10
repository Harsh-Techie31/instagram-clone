import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    // required Uint8List file

  }) async{
    var res = "Some error occured";

    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty){
      UserCredential cred =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection("users").doc(cred.user?.uid).set({
        "email" : email,
        "password" : password,
        "uid" : cred.user?.uid,        
        "username" : username,
        "followers" : [],
        "following" : []
      });

      res= "sucess";
    }}
    catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
      String res = "Some error occured";

      try{
        if(email.isNotEmpty && password.isNotEmpty){
          await _auth.signInWithEmailAndPassword(email: email, password: password);

          res = "sucess";
        }else{
          res = "Fill all the details!!";
        }

      }catch(err){
        res = err.toString();
      }
      

      return res;
  }


}