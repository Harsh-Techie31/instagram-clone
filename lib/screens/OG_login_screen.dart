import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobilescreenlayout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_builder.dart';
import 'package:instagram_flutter/responsive/webscreenlayout.dart';
// import 'package:instagram_flutter/screens/add-post.dart';
import 'package:instagram_flutter/screens/sign_up_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widget/text_input_field.dart';

class LoginScreenMobile extends StatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  State<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _pwTextController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _pwTextController.dispose();
    super.dispose();
  }

  void LoginUser()async{
    setState(() {
      _isLoading = true;
    });
    String output = await AuthMethods().loginUser(email: _emailTextController.text , password: _pwTextController.text);

    if(output =="sucess"){
      showSnackBar("Logged In Succesfully !!", context,Duration(seconds: 1));
      //TODO : show the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResponsiveLayout(webScreen: WebScreenLayout(), mobileScreen: MobileScreenLayout())),
        // MaterialPageRoute(builder: (context) => const AddPost()),
      );

    }else{
        showSnackBar(output, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF833AB4), // Purple
            Color(0xFFFF5E3A), // Orange
            Color(0xFFFFC837), // Yellow
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox(
            height: screenHeight, // Set the height of the screen to the device height
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: screenHeight * 0.15,
                  ),
                  SvgPicture.asset(
                    'assets/insta.svg',
                    colorFilter:
                        const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    height: 64,
                  ),
                  SizedBox(
                      height: screenHeight * 0.08), // Adjust spacing dynamically
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
                    onPressed: LoginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor,),): const Text(
                      "Log In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                
                  // Removed the Google login part
                  const Spacer(),
                  const Divider(),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreenMobile()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 3, 3, 5)),
                          ),
                          Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 56, 126, 231)),
                          ),
                        ],
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
