import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';


class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: mobileBackgroundColor,
      body : Center(child: Text("MOBILE" ,style: TextStyle(color: Colors.yellow),)),
    );
  }
}

