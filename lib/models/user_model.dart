import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/widgets/chat/messages.dart';

class UserModel {
  final String uid;

  UserModel({required this.uid});
}
