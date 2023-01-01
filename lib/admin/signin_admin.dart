import 'package:church_finder/admin/admin_page.dart';
import 'package:church_finder/screens/home.dart';
import 'package:church_finder/screens/signup.dart';
import 'package:church_finder/utils/colors_utils.dart';
import 'package:church_finder/widgets/widget.dart';
import 'package:flutter/material.dart';

class adminPage extends StatefulWidget {
  const adminPage({super.key});

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 76, 121, 245),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 120,
                color: Colors.white,
              ),
              SizedBox(
                height: 30,
              ),
              reuseableText("Enter Admin Username", Icons.person_outline, false,
                  _emailTextController),
              SizedBox(
                height: 20,
              ),
              reuseableText("Enter Admin Password", Icons.lock_outline, true,
                  _passwordTextController),
              SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, true, () async {
                if (_emailTextController.text.isEmpty ||
                    _passwordTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Make sure all the fields are completed!')),
                  );
                } else {
                  if (_emailTextController.text.toString() == "admin" &&
                      _passwordTextController.text.toString() == "admin") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => adminHome()));
                  }
                }
              }),
            ],
          ),
        )),
      ),
    );
  }
}
