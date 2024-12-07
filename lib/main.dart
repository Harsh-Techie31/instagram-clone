import 'package:flutter/material.dart';
import 'package:instagram_flutter/responsive/mobilescreenlayout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_builder.dart';
import 'package:instagram_flutter/responsive/webscreenlayout.dart';
import 'package:instagram_flutter/utils/colors.dart';

void main() {
  // debugPaintSizeEnabled : false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner : false,
      
      theme: ThemeData.dark(),
      home:const  ResponsiveLayout(webScreen:  WebScreenLayout(), mobileScreen:  MobileScreenLayout()),
    );
  }
}
