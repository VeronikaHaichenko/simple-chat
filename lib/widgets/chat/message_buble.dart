import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final Timestamp timestamp;
  final bool isMe;
  final Key key;

  MessageBubble(
      {required this.message,
      required this.timestamp,
      required this.isMe,
      required this.key});

  @override
  Widget build(BuildContext context) {
    var date = timestamp.toDate().toLocal();
    String createdAt = DateFormat().add_MMMMd().add_Hm().format(date);
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Align(
        alignment: !isMe ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: 90,
          ),
          child: Stack(
            alignment: isMe
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft:
                            !isMe ? Radius.circular(0) : Radius.circular(12),
                        bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(12),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        message,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      createdAt,
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
