import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';


class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: webBackgroundColor,
      body:  Center(child: Text("WEB")),
    );
  }
}

