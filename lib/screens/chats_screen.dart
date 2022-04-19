import 'package:flutter/material.dart';
import 'package:simple_chat/models/chat_card_model.dart';
import 'package:simple_chat/screens/splash_screen.dart';
import 'package:simple_chat/services/auth.dart';
import 'package:simple_chat/screens/users_screen.dart';
import 'package:simple_chat/services/database.dart';
import 'package:simple_chat/widgets/chats/chat_card.dart';

class ChatsScreen extends StatelessWidget {
  final Auth _auth = Auth();
  final _service = DatabaseService();
  List<ChatCardModel> chatCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('SIMPLE CHAT'),
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
            iconSize: 30,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _service.getChatData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            log.i(snapshot.data);

            if (snapshot.hasData) {
              List<ChatCardModel> chatCards =
                  snapshot.data as List<ChatCardModel>;
              chatCards.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
              if (chatCards.isNotEmpty) {
                return ListView.builder(
                  itemCount: chatCards.length,
                  itemBuilder: (ctx, index) {
                    return ChatCard(
                      chatUid: chatCards[index].chatUid,
                      username: chatCards[index].username,
                      userImage: chatCards[index].userImageUrl,
                      lastMessage: chatCards[index].lastMessage,
                      createdAtDate: chatCards[index].createdAt,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No chats yet.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  'No chats yet.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          } else {
            return SplashScreen();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(UsersScreen.routeName);
        },
      ),
    );
  }
}
