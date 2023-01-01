import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:church_finder/screens/home.dart';
import 'package:church_finder/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;

import '../utils/colors_utils.dart';

class addChurch extends StatefulWidget {
  const addChurch({super.key});

  @override
  State<addChurch> createState() => _addChurchState();
}

class _addChurchState extends State<addChurch> {
  TextEditingController _churchname = TextEditingController();
  TextEditingController _place = TextEditingController();
  TextEditingController _pasnam = TextEditingController();
  TextEditingController _numb = TextEditingController();
  TextEditingController _desc = TextEditingController();
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  String NAME = "";
  String imageUrl = "";
  XFile? file;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "    Add Your Church",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
          child: Column(children: <Widget>[
            Icon(
              (Icons.location_city),
              color: Colors.white,
              size: 120,
            ),
            const SizedBox(
              height: 30,
            ),
            reuseableText(
                "Enter Church Name", Icons.church_rounded, false, _churchname),
            SizedBox(
              height: 20,
            ),
            reuseableText(
              "Enter Landmark or common location name",
              Icons.landscape_outlined,
              false,
              _place,
            ),
            SizedBox(
              height: 20,
            ),
            reuseableText(
              "Enter the Name of your Head pastor",
              Icons.person_add_alt_1_outlined,
              false,
              _pasnam,
            ),
            SizedBox(
              height: 20,
            ),
            reuseableText(
              "Enter Phone Number",
              Icons.phone_android_outlined,
              false,
              _numb,
            ),
            SizedBox(
              height: 20,
            ),
            reuseableText(
              "Tell us about your Church Briefy",
              Icons.note_add_outlined,
              false,
              _desc,
            ),
            SizedBox(
              height: 20,
            ),
            IconButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);

                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');
                  Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);
                  try {
                    await referenceImageToUpload.putFile(File(file!.path));

                    imageUrl = await referenceImageToUpload.getDownloadURL();
                    if (imageUrl == null) {
                      Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                        semanticsValue: "Loading ...",
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image Added!! Sign Up')),
                      );
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(' Something went wrong!!')),
                    );
                  }
                },
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 45,
                )),
            SizedBox(
              height: 5,
            ),
            Text("  Add Image"),
            SizedBox(
              height: 6,
            ),
            Text("  Wait for image confirmation before signing Up"),
            SizedBox(
              height: 20,
            ),
            signInSignUpButton(context, false, () async {
              if (_churchname.text.isEmpty ||
                  _place.text.isEmpty ||
                  _pasnam.text.isEmpty ||
                  _numb.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(' Complete all text fields!!')),
                );
              } else {
                try {
                  final loc.LocationData _locationResult =
                      await location.getLocation();

                  final datas = {
                    "Name": _churchname.text,
                    "latitude": _locationResult.latitude.toString(),
                    "longitude": _locationResult.longitude.toString(),
                    "place": _place.text,
                    "imageUrl": imageUrl,
                    "state": false,
                    "PastorName": _pasnam.text,
                    "Number": _numb.text,
                    "Description": _desc.text
                  };

                  FirebaseFirestore.instance
                      .collection("Churches")
                      .doc(_churchname.text.toString())
                      .set(datas)
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen())));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Church Added')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error Try again!')),
                  );
                }
              }
            })
          ]),
        )),
      ),
    );
  }
}
