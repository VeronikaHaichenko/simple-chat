// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_chat/services/auth.dart';
import 'package:simple_chat/widgets/auth/user_picker_image.dart';

import 'login_part.dart';

String currentUid = '';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';
  File? _userImage;

  void _pickedImage(File? image) {
    if (image != null) {
      _userImage = image;
    } else {
      _userImage = null;
    }
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      if (_isLogin) {
        dynamic result = await _auth.signIn(
            _userEmail.trim(), _userPassword.trim(), context);
        currentUid = result.uid;
        // print(result.uid);
      } else {
        dynamic result = await _auth.signUp(_userImage, _userName.trim(),
            _userEmail.trim(), _userPassword.trim(), context);
        currentUid = result.uid;
        // print(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isLogin ? LoginPart() : UserImagePicker(_pickedImage),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!_isLogin)
                  TextFormField(
                    cursorColor: Colors.white60,
                    key: ValueKey('username'),
                    style: TextStyle(color: Colors.white),
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: Text(
                        'Username',
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length < 4) {
                        return 'Please, enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  cursorColor: Colors.white60,
                  style: TextStyle(color: Colors.white),
                  key: ValueKey('userEmail'),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      print('error email');
                      return 'Please, enter the valid email address.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  cursorColor: Colors.white60,
                  style: TextStyle(color: Colors.white),
                  key: ValueKey('password'),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Password',
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Please, enter at least 6 symbols.';
                    }
                    _userPassword = value;
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (!_isLogin)
                  TextFormField(
                    cursorColor: Colors.white60,
                    style: TextStyle(color: Colors.white),
                    key: ValueKey('confirmPass'),
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text(
                        'Confirm Password',
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ),
                    validator: (value) {
                      if (value != _userPassword) {
                        return 'Your passwords do not match';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 15,
                ),
                // if (widget.isLoading) CircularProgressIndicator(),
                // if (!widget.isLoading)
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _trySubmit,
                  child: Text(
                    _isLogin ? 'Sign In' : 'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // if (!widget.isLoading)
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Create new account'
                        : 'I already have an account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
