import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/postCard.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset(
          'assets/insta.svg',
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          height: 42,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send_outlined,
                size: 25,
                color: primaryColor,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot ){
          // print("hello");
          if(snapshot.connectionState == ConnectionState.waiting){
            // print("Inside waiting");
            return const Center(
              child:  CircularProgressIndicator(),
            );
          }
          // print("I HAVE ");
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts available'),
            );
          }

          // return Text("body11");
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index) => PostsCard(
              snap :snapshot.data!.docs[index].data(),
            ));
            // itemBuilder: (context,index) => Text(snapshot.data!.docs[index].data()['username']));
        }),
    );
  }
}