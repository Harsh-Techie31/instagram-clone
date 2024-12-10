import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/firebase_options.dart';
import 'package:instagram_flutter/responsive/mobilescreenlayout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_builder.dart';
import 'package:instagram_flutter/responsive/webscreenlayout.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/screens/sign_up_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
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
      home:const  ResponsiveLayout(webScreen:  WebScreenLayout(), mobileScreen:  SignupScreenMobile()),
    );
  }
}
