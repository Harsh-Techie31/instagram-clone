import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cached_network_image/cached_network_image.dart';

class PostsCard extends StatefulWidget {
  final snap;
  const PostsCard({super.key, required this.snap});

  @override
  State<PostsCard> createState() => _PostsCardState();
}

class _PostsCardState extends State<PostsCard>
    with SingleTickerProviderStateMixin {


  
  bool _isLiked = false;
  bool _showHeart = false;
  late AnimationController _animationController;
  AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateLikes()async{
    await _authMethods.likePost(
      widget.snap['postId'],
      widget.snap['uid'],
      widget.snap['likes'],
    );
  }

  void _handleDoubleTap()  {    
  
     updateLikes();
    
    
    
    setState(() {
      _isLiked = !_isLiked;
      _showHeart = true;
    });

    _animationController.forward().then((value) {
      _animationController.reverse().then((_) {
        setState(() {
          _showHeart = false;
        });
      });
    });

    // print("Leaving double tap");
  }

  @override
  Widget build(BuildContext context) {
    _isLiked = widget.snap['likes'].contains(widget.snap['uid']);
    return Card(

      
      color: mobileBackgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(widget.snap['pfpLink']),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(
                    "  ${widget.snap['username']}",
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
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            width: double.infinity,
            child: GestureDetector(
              onDoubleTap: _handleDoubleTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.snap['postUrl'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  if (_showHeart)
                    ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 1.5).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        // color: Color(0xFFED4956),
                        color: Color(0xFFFF3040),
                        size: 100,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                    updateLikes();
                  });
                },
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                  color: _isLiked ? const Color(0xFFFF3040) : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.insert_comment_outlined),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_outline_outlined),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "${widget.snap['likes'].length} likes",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text(
                  "${widget.snap['username']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                "  ${widget.snap['description']}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 14.0),
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
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(
                intl.DateFormat("MMM dd, yyyy")
                    .format(DateTime.parse(widget.snap['time'])),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
