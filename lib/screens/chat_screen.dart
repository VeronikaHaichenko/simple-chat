// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';
  late String username;
  late String imageUrl;
  // late String userUid;
  late String chatUid;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;
    FirebaseAuth.instance.currentUser;
    final argumets = ModalRoute.of(context)!.settings.arguments as List;
    // userUid = argumets[0];
    username = argumets[0];
    imageUrl = argumets[1];
    chatUid = argumets[2];

    final appBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundImage: NetworkImage(imageUrl),
              radius: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(username),
          ],
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appBar,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).accentColor.withOpacity(0.9)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: (deviceSize.height -
                          appBar.preferredSize.height -
                          paddingTop) *
                      0.8,
                  width: deviceSize.width,
                  child: Messages(chatUid),
                ),
                Container(
                  height: (deviceSize.height -
                          appBar.preferredSize.height -
                          paddingTop) *
                      0.2,
                  width: deviceSize.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: NewMessage(chatUid),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
