// import 'dart:isolate';
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
          // print(user!.username);
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

  uploadtoSupabase() async {
    // print("POST BUTTON CLICKED");
    setState(() {
      _isLoading = true;
    });
    try {
      var temp = uuid.v1();
      final path = 'post/${user!.uid}/$temp.jpeg';
      final path2 = 'post/${user!.uid}/$temp';
      final path3 = 'pfp/${user!.uid}';
      // print("REACHED");
      await Supabase.instance.client.storage
          .from('user-images')
          .uploadBinary(path, _file!);

      // print("username : ${user!.username} , postid is : ${temp} and desc : ${_controller.text}");

      String res = await AuthMethods().uploadImg(
          username: user!.username,
          description: _controller.text.isNotEmpty ? _controller.text : " ",
          postId: temp,
          postUrl: await getImageUrl(path2),
          pfpLink: await getImageUrl(path3),
          uid: user!.uid,
          time: DateFormat('yyyy-MM-dd').format(now),
          likes: [],
          comments: []);
      if (res != "success") {
        showSnackBar(res, context);
      } else {
        showSnackBar("Posted !", context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginScreenMobile()),
        // );
        setState(() {
          _isLoading = false;
        });
        clearScreen();
      }

      // ignore: use_build_context_synchronously
      // showSnackBar("Posted !", context);
    } catch (err) {
      // print("########## ERROR : ${err.toString()}");
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
            const Divider(height: 1, thickness: 1), // Top divider

            // Option: Take a Photo
            _buildDialogOption(
              context,
              label: "Take a Photo",
              icon: Icons.camera_alt_outlined,
              onTap: () async {
                Navigator.pop(context);
                Uint8List? file = await pickImage(ImageSource.camera);
                Uint8List finalFile = await compressImageToBelow2MB(file!);
                setState(() {
                  _file = finalFile;
                });
              },
            ),

            const Divider(height: 1, thickness: 1), // Divider between options

            // Option: Choose a Photo
            _buildDialogOption(
              context,
              label: "Choose a Photo",
              icon: Icons.photo_library_outlined,
              onTap: () async {
                Navigator.pop(context);
                Uint8List? file = await pickImage(ImageSource.gallery);
                Uint8List finalFile2 = await compressImageToBelow2MB(file!);
                setState(() {
                  _file = finalFile2;
                });
              },
            ),

            const Divider(height: 1, thickness: 1), // Divider before Cancel

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
            const SizedBox(width: 16), // Space between icon and text
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
    //   print("############# USER :${user!.uid}");
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
                IconButton(
                    onPressed: () {
                      logout();
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator(
                        color: blueColor,
                      )
                    : const Padding(padding: EdgeInsets.all(0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                      future: getImageUrl(
                          "pfp/${user!.uid}"), // Use future to get image URL
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          ); // Show loading indicator while fetching
                        }

                        if (snapshot.hasError) {
                          return const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.error),
                          ); // Show error icon if there's an error
                        }

                        final imageUrL = snapshot.data!;
                        return CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(imageUrL),
                          radius: 30,
                        );
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _controller,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Add a Caption...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
