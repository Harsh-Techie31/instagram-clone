import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/explore_feed.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  TextEditingController _textcontroller = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    _textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          
          // enabled: false,
          controller: _textcontroller,
          decoration:  InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: const Icon(Icons.search),
            hintText: "Search"),

          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),
      backgroundColor: mobileBackgroundColor,
      body: searchQuery== "" ? const ExploreImages() : FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("users") // Assuming "users" is the correct collection name
            .where('username', isGreaterThanOrEqualTo: searchQuery)
            .where('username', isLessThan: searchQuery + 'z')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return ListTile(
                // leading: user['pfpUrl'] != null
                //     ? CircleAvatar(
                //         backgroundImage: CachedNetworkImageProvider(user['pfpUrl']),
                //       )
                //     : null,
                title: Text(user['username']),
              );
            },
          );
        },
      ),
    );
  }
}

