import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobilescreenlayout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_builder.dart';
import 'package:instagram_flutter/responsive/webscreenlayout.dart';
import 'package:instagram_flutter/screens/OG_login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/compressor.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widget/text_input_field.dart';
import 'package:http/http.dart' as http;

class SignupScreenMobile extends StatefulWidget {
  const SignupScreenMobile({super.key});

  @override
  State<SignupScreenMobile> createState() => _SignupScreenMobileState();
}

class _SignupScreenMobileState extends State<SignupScreenMobile> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _pwTextController = TextEditingController();
  final TextEditingController _idTextController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _profileImage;

  // Default profile image URL
  final String _defaultImageUrl =
      "https://media.istockphoto.com/id/1397556857/vector/avatar-13.jpg?s=612x612&w=0&k=20&c=n4kOY_OEVVIMkiCNOnFbCxM0yQBiKVea-ylQG62JErI=";

  // Convert network image to Uint8List
  Future<Uint8List> _networkImageToUint8List(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      showSnackBar('Error loading image: $e', context);
      rethrow;
    }
  }

  // Handle image selection
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              // Uint8List finalFile1 = await compressImage(file!);
              setState(() {
                _profileImage = file;
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
              // Uint8List finalFile2 = await compressImage(file!);
              setState(() {
                _profileImage = file;
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
          Icon(icon, size: 24, color: isCancel ? Colors.red : Colors.lightBlue[600]),
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

  // Sign up user
  void _signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    Uint8List profileImage = _profileImage ??
        await _networkImageToUint8List(_defaultImageUrl); // Use default if no image selected

    String output = await AuthMethods().signUpUser(
      email: _emailTextController.text,
      password: _pwTextController.text,
      username: _idTextController.text,
      file: profileImage,
    );

    if (output != "success") {
      showSnackBar(output, context);
    } else {
      showSnackBar("Signed Up Successfully", context, Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResponsiveLayout(webScreen: WebScreenLayout(),mobileScreen: MobileScreenLayout(),)),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _pwTextController.dispose();
    _idTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF833AB4), Color(0xFFFF5E3A), Color(0xFFFFC837)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: _profileImage != null
                              ? MemoryImage(_profileImage!)
                              : NetworkImage(_defaultImageUrl) as ImageProvider,
                        ),
                        Positioned(
                          bottom: -5,
                          left: 80,
                          child: IconButton(
                            onPressed: () => _selectImage(context),
                            icon: const Icon(Icons.add_a_photo),
                            color: Colors.black,
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  TextFieldInput(
                    textEditingController: _idTextController,
                    hintText: "Enter your Username",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: _emailTextController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: _pwTextController,
                    hintText: "Enter your password",
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signUpUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: primaryColor),
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenMobile()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Log in.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}