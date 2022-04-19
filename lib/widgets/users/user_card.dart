import 'package:flutter/material.dart';
import 'package:simple_chat/screens/chat_screen.dart';
import 'package:simple_chat/services/database.dart';

import '../auth/auth_form.dart';

class UserCard extends StatelessWidget {
  final DatabaseService _services = DatabaseService();
  final String userUid;
  final String username;
  final String userImage;
  final Key key;

  UserCard(
      {required this.userUid,
      required this.username,
      required this.userImage,
      required this.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var result;
        await _services
            .searchChat(currentUid, userUid)
            .then((value) => result = value);
        if (!result) {
          await _services.createNewChat(currentUid, userUid);
        }
        var chatUid;
        await _services
            .getChatUid(currentUid, userUid)
            .then((value) => chatUid = value);

        Navigator.of(context).pushReplacementNamed(ChatScreen.routeName,
            arguments: [username, userImage, chatUid]);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: AssetImage('assets/images/smile2.png'),
              foregroundImage: NetworkImage(userImage),
              radius: 35,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              username,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
