import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/widgets/chat/messages.dart';

class UserModel {
  final String uid;

  UserModel({required this.uid});
}

class ChatData {
  final String chatUid;
  final String firstUid;
  final String secondUid;
  Stream<QuerySnapshot<Map<String, dynamic>>>? messagesSnaphot;

  ChatData(
      {required this.chatUid,
      required this.firstUid,
      required this.secondUid,
      this.messagesSnaphot});
}
