import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user-models.dart';
import 'package:instagram_flutter/providers/user-provider.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  Userm? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        try {
          user = Provider.of<UserProvider>(context, listen: false).getUser;
          print(user!.username);
        } catch (err) {
          print(err.toString());
        }
      });
    });
  }

   void logout()async {
    FirebaseAuth _authL = FirebaseAuth.instance;
    try{
      await _authL.signOut();
      showSnackBar("Logged out Succesfully", context ,Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenMobile()),
      );
      
    }catch(err){
      showSnackBar(err.toString(), context);

    }
    
  }

  uploadtoSupabase() async {
    print("POST BUTTON CLICKED");
    try {
      final path = 'post/${user!.uid}';
      print("REACHED");
      await Supabase.instance.client.storage
          .from('user-images')
          .uploadBinary(path, _file!);
    } catch (err) {
      print("########## ERROR : ${err.toString()}");
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Pick an Image", style: TextStyle(fontSize: 24)),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text(
                  "    Take a Photo",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SimpleDialogOption(
                child: const Text(
                  "    Choose a Photo",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? file = await pickImage(ImageSource.gallery);

                  setState(() {
                    _file = file;
                  });
                },
              )
            ],
          );
        });
  }


  Future<String> getImageUrl(String imagePath) async {
    try {
      final response = await Supabase.instance.client.storage.from('user-images').getPublicUrl('pfp/${imagePath}.jpeg');
      return response;  // Returns the public URL of the image
    } catch (e) {
      throw Exception('Error fetching image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
      final Userm? user = Provider.of<UserProvider>(context, listen: false).getUser;
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
                  onPressed: () {},
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
                    IconButton(onPressed: (){

                      logout();

                      

                    }, icon: const Icon(Icons.logout))
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     FutureBuilder<String>(
                      future: getImageUrl(user!.uid), // Use future to get image URL
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircleAvatar(
                            radius: 30,
                            child: CircularProgressIndicator(),
                          ); // Show loading indicator while fetching
                        }

                        if (snapshot.hasError) {
                          return const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.error),
                          ); // Show error icon if there's an error
                        }

                        final imageUrl = snapshot.data!;
                        return CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 30,
                        );
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
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
