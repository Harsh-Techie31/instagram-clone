import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/firebase_options.dart';
import 'package:instagram_flutter/responsive/mobilescreenlayout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_builder.dart';
import 'package:instagram_flutter/responsive/webscreenlayout.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
// import 'package:instagram_flutter/screens/sign_up_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        // home:const  ResponsiveLayout(webScreen:  WebScreenLayout(), mobileScreen: LoginScreenMobile()),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreen: WebScreenLayout(),
                      mobileScreen: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(color: primaryColor,),);
              }

              return const LoginScreenMobile();
            }));
  }
}
