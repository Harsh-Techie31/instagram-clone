import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user-provider.dart';
import 'package:instagram_flutter/utils/dimensions.dart';
import 'package:provider/provider.dart';


class ResponsiveLayout extends StatefulWidget {
  final Widget webScreen;
  final Widget mobileScreen;
  const ResponsiveLayout(
      {super.key, required this.webScreen, required this.mobileScreen});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();

  }

  void addData() async{
    // print("Responsive layout caledd!!!!!!!!!!!!!!!!!!!!");
    UserProvider _userProvider = Provider.of(context,listen : false);
    // print("REACHED TILL HEREEEEEEEEEEEE2222222222222222222222222");
    await _userProvider.refreshUser();
    // print("REACHED TILL HEREEEEEEEEEEEE");
    // print("User after refresh: ${_userProvider.getUser}");

  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webscreenSize) {
        return widget.webScreen;
      } else {
        return widget.mobileScreen;
      }
    });
  }
}
