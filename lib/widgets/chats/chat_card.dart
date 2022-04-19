import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../screens/chat_screen.dart';

class ChatCard extends StatelessWidget {
  final String chatUid;
  final String username;
  final String userImage;
  String lastMessage;
  final DateTime createdAtDate;

  ChatCard({
    required this.chatUid,
    required this.username,
    required this.userImage,
    required this.lastMessage,
    required this.createdAtDate,
  });

  @override
  Widget build(BuildContext context) {
    if (lastMessage.length > 13) {
      lastMessage = lastMessage.substring(0, 13) + '...';
      print(lastMessage);
    }
    String createdAt = DateFormat().add_MMMMd().add_Hm().format(createdAtDate);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ChatScreen.routeName,
            arguments: [username, userImage, chatUid]);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundImage: NetworkImage(userImage),
              radius: 35,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lastMessage,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        createdAt,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
