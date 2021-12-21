import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_app/bloc/user/user_bloc.dart';
import 'package:recipes_app/bloc/user/user_bloc.dart';
import 'package:recipes_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/widget/snackbars.dart';

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
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
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
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTitle(),
                  _buildEmailInput(),
                  if (!_isLogin) _buildNameInput(),
                  _buildPasswordInput(),
                  if (!_isLogin) _buildRepeatPasswordInput(),
                  BlocConsumer<UserBloc, UserState>(
                    listener: (context, state) {
                      if (state is UserLoggedIn) {
                        Navigator.of(context).popAndPushNamed("/recipes-list");
                      } else if (state is UserFailure) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBars.error(state.error));
                      }
                    },
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildToggleButton(),
                          _buildSubmitButton(),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ]),
    );
  }

  Widget _buildTitle() {
    return Text(
      _isLogin ? "Sign in" : "Sign up",
      style: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 16),
        border: InputBorder.none,
        hintText: "Email",
        contentPadding: EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 16),
        border: InputBorder.none,
        hintText: "Full Name",
        contentPadding: EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      obscureText: _isObscure,
      controller: _passwordController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
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
    );
  }

  Widget _buildRepeatPasswordInput() {
    return TextFormField(
      obscureText: _isObscure,
      controller: _repeatPasswordController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
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
    );
  }

  Widget _buildToggleButton() {
    return Container(
      margin: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: _changeScreen,
        child: Text(
          !_isLogin ? "or Sign in" : "or Sign up",
          style: TextStyle(fontSize: 16),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: ElevatedButton(
          onPressed: _submit,
          child: Text("Submit", style: TextStyle(fontSize: 16)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
          )),
    );
  }

  void _changeScreen() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() {
    if (_isLogin) {
      _signIn();
    } else {
      _signUp();
    }
  }

  void _signIn() async {
    _userBloc.add(UserEventSignIn(
      _emailController.value.text,
      _passwordController.value.text,
    ));
  }

  void _signUp() async {
    _userBloc.add(UserEventSignUp(
      _emailController.value.text,
      _nameController.value.text,
      _passwordController.value.text,
    ));

  }
}
