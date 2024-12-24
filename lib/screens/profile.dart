import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/explore_feed.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widget/textbutton.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  int postlen = 0;
  int following = 0;
  int follower = 0;
  bool _isFollowing = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      userData = snap.data()!;

      var snap2 = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();
      postlen = snap2.docs.length;
      follower = snap.data()!['followers'].length;
      following = snap.data()!['following'].length;

      _isFollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (ee) {
      print(ee.toString());
      showSnackBar(ee.toString(), context);
    }
  }


  void logout() async {
    FirebaseAuth _authL = FirebaseAuth.instance;
    try {
      await _authL.signOut();
      showSnackBar("Logged out Succesfully", context, Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenMobile()),
      );
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return userData['username'] != null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  userData['username'],
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(userData['pfpLink']),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                countWidget("Posts", postlen),
                                countWidget("Following", following),
                                countWidget("Followers", follower),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? FollowButton(
                                    borderC: Colors.grey,
                                    textColor: primaryColor,
                                    label: "Sign Out",
                                    bg: mobileBackgroundColor,
                                    func: () {
                                      logout();
                                    },
                                  )
                                : _isFollowing
                                    ? FollowButton(
                                        borderC: Colors.grey,
                                        textColor: Colors.black,
                                        label: "Unfollow",
                                        bg: Colors.white,
                                        func: () async{
                                          await AuthMethods().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                                          setState(() {
                                            setState(() {
                                            _isFollowing = false;
                                            follower--;
                                          });
                                          });
                                        },
                                      )
                                    : FollowButton(
                                        borderC: blueColor,
                                        textColor: primaryColor,
                                        label: "Follow",
                                        bg: blueColor,
                                        func: () async{
                                          await AuthMethods().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                                          setState(() {
                                            _isFollowing = true;
                                            follower++;
                                          });
                                        },
                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const Divider(
                //   color: Colors.grey,
                //   thickness: 0.5,
                //   indent: 16,
                //   endIndent: 16,
                // ),
                // Add more UI sections here, like posts grid, activity feed, etc.
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Posts!"),
                        );
                      }

                      final List<String> images = snapshot.data!.docs
                          .map((doc) => doc.data()['postUrl'] as String)
                          .toList();
                      if(images.isEmpty){
                        return const Center(
                          child: Text("No Posts!"),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing:
                              8, // Horizontal spacing between tiles
                          mainAxisSpacing: 8, // Vertical spacing between tiles
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return buildGridTile(images[index]);
                        },
                      );
                    })
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

Column countWidget(String label, int count) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        count.toString(),
        style: const TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        label,
        style: const TextStyle(
            fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
      ),
    ],
  );
}
