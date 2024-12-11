import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';


class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  void logout()async {
    FirebaseAuth _authL = FirebaseAuth.instance;
    try{
      await _authL.signOut();
      showSnackBar("Logged out Succesfully", context ,Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenMobile()),
      );
      
    }catch(err){
      showSnackBar(err.toString(), context);

    }
    
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: mobileBackgroundColor,
      body : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("MOBILE" ,style: TextStyle(color: Colors.yellow),)),
          const Center(child: Text("Log out from below" ,style: TextStyle(color: Colors.yellow),)),
          IconButton(onPressed: logout
          , icon: const Icon(Icons.logout_outlined))
        ],
      ),


    );
  }
}

