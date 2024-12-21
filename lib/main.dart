import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/firebase_options.dart';
import 'package:instagram_flutter/providers/user-provider.dart';
import 'package:instagram_flutter/responsive/mobilescreenlayout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_builder.dart';
import 'package:instagram_flutter/responsive/webscreenlayout.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/screens/explore.dart';
// import 'package:instagram_flutter/screens/add-post.dart';
// import 'package:instagram_flutter/screens/sign_up_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: "https://exqcfblyyjpgslpiwolj.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV4cWNmYmx5eWpwZ3NscGl3b2xqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3Nzg4MDQsImV4cCI6MjA0OTM1NDgwNH0.mcZxzLC_ZZQx2Xh4w7mnoNPK8hWNrPVTfkT3YEbOxno");

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
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
                        mobileScreen:
                            // ExplorePage()); //TODO: change it to mobile screen later
                            MobileScreenLayout()); //TODO: change it to mobile screen later
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }

                return const LoginScreenMobile();
              })),
    );
  }
}
