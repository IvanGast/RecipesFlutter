import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLogin = true;
  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _repeatPasswordController;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    _isLogin ? "Sign in" : "Sign up",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                      hintText: "Email",
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  _isLogin
                      ? Text("")
                      : TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 16),
                            border: InputBorder.none,
                            hintText: "Full Name",
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                  TextFormField(
                    obscureText: _isObscure,
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
                      border: InputBorder.none,
                      hintText: "Password",
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      obscureText: _isObscure,
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
                        border: InputBorder.none,
                        hintText: "Repeat Password",
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: _changeScreen,
                              child: Text(
                                !_isLogin ? "or Sign in" : "or Sign up",
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.amber),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                              ))),
                      Container(
                          margin: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () => _submit(context),
                              child: Text("Submit",
                                  style: TextStyle(fontSize: 16)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.amber),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                              ))),
                    ],
                  )
                ],
              ),
            ),
          ]),
    );
  }

  void _changeScreen() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit(BuildContext ctx) {
    Navigator.of(ctx).popAndPushNamed("/recipes-list");
    if (_isLogin) {
      _signIn(ctx);
    } else {
      _signUp(ctx);
    }
  }

  void _signIn(BuildContext ctx) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.value.text,
          password: _passwordController.value.text);
      Navigator.of(ctx).popAndPushNamed("/recipes-list");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void _signUp(BuildContext ctx) async {
    try {
      String email = _emailController.value.text;
      String password = _passwordController.value.text;
      User user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => value.user);
      addUserToDB(UserModel(
          email: email,
          name: _nameController.value.text,
          uid: user.uid,
          pictureUrl: ""));
      Navigator.of(ctx).popAndPushNamed("/recipes-list");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void addUserToDB(UserModel user) {
    final _reference = FirebaseFirestore.instance.collection("Users");
    _reference.doc(user.uid).set(user.toJson());
  }
}
