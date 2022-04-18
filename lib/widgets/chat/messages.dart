import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/services/database.dart';
import 'package:simple_chat/widgets/auth/auth_form.dart';

import 'message_buble.dart';

class Messages extends StatelessWidget {
  final _service = DatabaseService();
  String chatUid;

  Messages(this.chatUid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.getMessagesFromChat(chatUid),
      builder: (ctx, messagesSnapshot) {
        if (messagesSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final messDocs = messagesSnapshot.data!.docs;
        return messDocs.isEmpty
            ? Center(
                child: Text(
                  'No messages yet.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                reverse: true,
                itemCount: messDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  message: messDocs[index]['text'],
                  timestamp: messDocs[index]['createdAt'],
                  isMe: messDocs[index]['userId'] == currentUid,
                  key: ValueKey(messDocs[index].id),
                ),
              );
      },
    );
  }
}
