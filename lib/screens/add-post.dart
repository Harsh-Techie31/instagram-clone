import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user-models.dart';
import 'package:instagram_flutter/providers/user-provider.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/compressor.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  Userm? user;
  bool _isLoading = false;
  bool _isCompressing = false; // Flag to track image compression status
  var uuid = const Uuid();
  TextEditingController _controller = TextEditingController();

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        try {
          user = Provider.of<UserProvider>(context, listen: false).getUser;
        } catch (err) {
          // print(err.toString());
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  

  uploadtoSupabase() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var temp = uuid.v1();
      final path = 'post/${user!.uid}/$temp.jpeg';
      final path2 = 'post/${user!.uid}/$temp';
      final path3 = 'pfp/${user!.uid}';
      await Supabase.instance.client.storage
          .from('user-images')
          .uploadBinary(path, _file!);

      String res = await AuthMethods().uploadImg(
        username: user!.username,
        description: _controller.text.isNotEmpty ? _controller.text : " ",
        postId: temp,
        postUrl: await getImageUrl(path2),
        pfpLink: await getImageUrl(path3),
        uid: user!.uid,
        time: DateFormat('yyyy-MM-dd').format(now),
        likes: [],
        comments: [],
      );
      if (res != "success") {
        showSnackBar(res, context);
      } else {
        showSnackBar("Posted!", context);
        setState(() {
          _isLoading = false;
        });
        clearScreen();
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Center(
            child: Text(
              "Pick an Image",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          children: [
            const Divider(height: 1, thickness: 1),

            // Option: Take a Photo
            _buildDialogOption(
              context,
              label: "Take a Photo",
              icon: Icons.camera_alt_outlined,
              onTap: () async {
                Navigator.pop(context);
                Uint8List? file = await pickImage(
                  ImageSource.camera,
                );
                if (file != null) {
                  // setState(() {
                  //   _isCompressing = true;  // Set compressing flag to true
                  // });
                  // Uint8List finalFile = await compressImage(file);
                  setState(() {
                    _file = file;
                    // _isCompressing = false;  // Set compressing flag to false once done
                  });
                }
              },
            ),

            const Divider(height: 1, thickness: 1),

            // Option: Choose a Photo
            _buildDialogOption(context,
                label: "Choose a Photo",
                icon: Icons.photo_library_outlined, onTap: () async {
              Navigator.pop(context);
              setState(() {
                _isCompressing =
                    true; // Show the loading indicator when picking image
              });
              Uint8List? file = await pickImage(ImageSource.gallery);
              // if (file != null) {
              // Delay to simulate processing (to show progress)
              // setState(() {
              //   _isCompressing = true;  // Start compression
              // }
              // );
              // Uint8List finalFile2 = await compressImage(file);
              setState(() {
                _file = file;
                _isCompressing = false; // Stop compression
              });
            }),

            const Divider(height: 1, thickness: 1),

            // Cancel Option
            _buildDialogOption(
              context,
              label: "Cancel",
              icon: Icons.close,
              isCancel: true,
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogOption(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap,
      bool isCancel = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            Icon(icon,
                size: 24, color: isCancel ? Colors.red : Colors.lightBlue[600]),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isCancel ? Colors.red : Colors.lightBlue[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getImageUrl(String imagePath) async {
    try {
      final response = Supabase.instance.client.storage
          .from('user-images')
          .getPublicUrl('$imagePath.jpeg');
      return response; // Returns the public URL of the image
    } catch (e) {
      throw Exception('Error fetching image URL: $e');
    }
  }

  void clearScreen() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Userm? user =
        Provider.of<UserProvider>(context, listen: false).getUser;

    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () => _selectImage(context),
                icon: const Icon(Icons.upload)))
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    clearScreen();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 27,
                  )),
              backgroundColor: Colors.transparent,
              title: const Text("Post To"),
              actions: [
                TextButton(
                    onPressed: () {
                      uploadtoSupabase();
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          fontSize: 19,
                          color: blueColor,
                          fontWeight: FontWeight.bold),
                    )),
                
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator(
                        color: blueColor,
                      )
                    : const Padding(padding: EdgeInsets.all(0)),
                // const Divider(),
                _isCompressing
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Image.memory(
                        _file!,
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                      ),

                const Divider(
                  thickness: 1.5,
                ),
                // SizedBox(height: ,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    FutureBuilder<String>(
                      future: getImageUrl(
                          "pfp/${user!.uid}"), // Use future to get image URL
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.error),
                          );
                        }

                        final String imageUrl = snapshot.data!;
                        return CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 30,
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            hintStyle: TextStyle(fontSize: 17),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));
  }
}
