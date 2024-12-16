import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:intl/intl.dart' as intl;

class PostsCard extends StatelessWidget {
  final snap;
  const PostsCard({super.key, required this.snap});
  // const PostsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: mobileBackgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // child: Container(
      // padding:
      //     const EdgeInsets.only(left: 20, right: 20, bottom: 120, top: 120),
      
        // Add a nested container for border
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.yellow, // Border color
        //     width: 2, // Border thickness
        //   ),
        //   borderRadius:
        //       BorderRadius.circular(10), // Rounded corners for the border
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // // SizedBox(height: 100),
            Row(
              children: [
                 Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(snap['pfpLink']),
                  ),
                ),
                const SizedBox(width: 10), // Space beside the avatar
                 Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Text(
                      "  ${snap['username']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      size: 28,
                      color: Colors.white,
                    ))
              ],
            ),
            // const Divider(),
            Container(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              // height: 250, // Fixed height for the image
              width: double.infinity, // Full width of the card
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child:  AspectRatio(
                aspectRatio: 4 / 3,
                child: Image(
                  image: NetworkImage(snap['postUrl'],
                  ),
                  fit: BoxFit.cover, // Cover the entire container
                ),
              ),
            ),

            Row(
              children: [
                IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border_outlined)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.insert_comment_outlined)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                const Spacer(),
                IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_outline_outlined)),
              ],
            ),
             Align(
              alignment: Alignment.centerLeft, // Align text to the left
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0), // Optional padding for spacing
                child: Text(
                  "${snap['likes'].length} likes",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: TextDirection.ltr,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Text(
                    "${snap['username']}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  "  ${snap['description']}",
                  style:const  TextStyle(fontSize: 14),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft, // Align text to the left
              child: Padding(
                padding:
                    EdgeInsets.only(left: 14.0), // Optional padding for spacing
                child: Text(
                  "View all 200 Comments",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Align(
              
              alignment: Alignment.centerLeft, // Align text to the left
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 14.0), // Optional padding for spacing
                child: Text(
                  intl.DateFormat("MMM dd, yyyy").format(DateTime.parse(snap['time'])),
                  style: const  TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,)
          ],
        ),
      
      // ),
    );
  }
}
