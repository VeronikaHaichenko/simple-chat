import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/models/user_model.dart';
import 'package:simple_chat/services/database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future signIn(String email, String password, BuildContext ctx) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = authResult.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials!';

      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future signUp(File? userImage, String username, String email, String password,
      BuildContext ctx) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = authResult.user;

      var url;
      if (userImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(user!.uid + '.jpg');

        await ref.putFile(userImage);

        url = await ref.getDownloadURL();
      } else {
        url =
            'https://firebasestorage.googleapis.com/v0/b/simple-chat-e134c.appspot.com/o/user_images%2FuserImage.jpg?alt=media&token=9b08e133-99ab-489c-b5f2-03d1481aea77';
      }

      await DatabaseService().updateUserData(
        user!.uid,
        url,
        username,
        email,
      );
      // _uid = user.uid;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials!';

      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

//comment
  Future signOut(BuildContext ctx) async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials!';

      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
