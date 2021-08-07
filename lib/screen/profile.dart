import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_app/model/user_model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _repeatPasswordController;
  UserModel _userModel;
  File _pickedImage;
  final _storage = FirebaseStorage.instance;
  final _reference = FirebaseFirestore.instance.collection("Users");
  bool _isObscure = true;

  final picker = ImagePicker();

  _getUser() {
    User user = FirebaseAuth.instance.currentUser;
    _reference.doc(user.uid).get().then((element) {
      setState(() {
        _userModel = UserModel.fromMap(element.data());
        _emailController.text = _userModel.email;
        _nameController.text = _userModel.name;
      });
    });
  }

  Future<void> _changePhoto() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveNewImage() async {
    String imageName = _pickedImage.path
        .substring(_pickedImage.path.lastIndexOf("/"),
            _pickedImage.path.lastIndexOf("."))
        .replaceAll("/", "");
    final byteData = _pickedImage.readAsBytesSync();
    await _pickedImage.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    TaskSnapshot taskSnapshot = await _storage
        .ref('/images/' + _userModel.uid + '/$imageName')
        .putFile(_pickedImage);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    _userModel.pictureUrl = downloadUrl;
    _proceedSaving();
  }

  _proceedSaving() {
    _userModel.email = _emailController.value.text;
    _userModel.name = _nameController.value.text;
    _reference.doc(_userModel.uid).update(_userModel.toJson());
  }

  void _saveProfile() async {
    if (_pickedImage != null) {
      await _saveNewImage();
    } else {
      _proceedSaving();
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.amber,
          elevation: 0.0,
        ),
        backgroundColor: Colors.amber,
        body: ListView(children: [
          Column(children: [
            Container(
              margin: EdgeInsets.all(10.0),
              width: double.infinity,
              height: 250,
              child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: _pickedImage != null
                      ? Image.file(_pickedImage)
                      : _userModel != null
                          ? _userModel.pictureUrl != "" &&
                                  _userModel.pictureUrl != null
                              ? Image.network(_userModel.pictureUrl)
                              : Icon(Icons.add_a_photo, color: Colors.grey)
                          : Icon(Icons.add_a_photo, color: Colors.grey)),
            ),
            Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: _changePhoto,
                    child: Text("Change photo", style: TextStyle(fontSize: 16)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
                    ))),
            Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: _userModel == null
                    ? Text("Loading..")
                    : Column(children: [
                        Row(
                          children: [
                            Text("Email: ", style: TextStyle(fontSize: 16)),
                            Container(
                                width: 250,
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      contentPadding: EdgeInsets.all(5)),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Text("Name: ", style: TextStyle(fontSize: 16)),
                            Container(
                                width: 250,
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      contentPadding: EdgeInsets.all(5)),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Change password", style: TextStyle(fontSize: 24)),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            labelStyle: TextStyle(fontSize: 16),
                            hintText: "New Password",
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                        TextFormField(
                          controller: _repeatPasswordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            labelStyle: TextStyle(fontSize: 16),
                            hintText: "Repeat Password",
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(20),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                onPressed: _saveProfile,
                                child: Text("Save",
                                    style: TextStyle(fontSize: 24)),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(15)),
                                ))),
                      ]))
          ])
        ]));
  }
}
