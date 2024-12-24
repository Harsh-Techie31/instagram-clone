import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:instagram_flutter/models/user-models.dart';
// import 'package:instagram_flutter/providers/user-provider.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/screens/add-post.dart';
import 'package:instagram_flutter/screens/explore.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/profile.dart';
import 'package:instagram_flutter/utils/colors.dart';
// import 'package:instagram_flutter/utils/postCard.dart';
import 'package:instagram_flutter/utils/utils.dart';
// import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  

  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void pageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    // Userm? _user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      // appBar: AppBar(
      //     leading: IconButton(
      //         onPressed: logout, icon: const Icon(Icons.logout_outlined))),
      backgroundColor: mobileBackgroundColor,
      body: PageView(
        controller: pageController,
        onPageChanged: pageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children:   [
          const FeedScreen(),
          const ExplorePage(),
          const  AddPost(),
           ProfilePage(uid : FirebaseAuth.instance.currentUser!.uid),
          //  ProfilePage(uid : "QEM4NF8ByYbEbi8nhZwdjExxPLP2"),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.transparent,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
