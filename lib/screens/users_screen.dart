import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/widgets/users/user_card.dart';

class UsersScreen extends StatelessWidget {
  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('SIMPLE CHAT'),
      ),
      //   body: Center(
      //     child: Text(
      //       'No users yet. But you can invite your friends :)',
      //       style: Theme.of(context).textTheme.bodyText1,
      //     ),
      //   ),
      // );
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (ctx, usersSnapshot) {
            if (usersSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 130, 214, 5),
                ),
              );
            }
            final usersDocs = usersSnapshot.data!.docs;
            return usersDocs.length > 1
                ? ListView.builder(
                    itemCount: usersDocs.length,
                    itemBuilder: (ctx, index) {
                      if (usersDocs[index]['user_id'] != user!.uid) {
                        return UserCard(
                          userUid: usersDocs[index]['user_id'],
                          username: usersDocs[index]['username'],
                          userImage: usersDocs[index]['user_image'],
                          key: ValueKey(usersDocs[index].id),
                        );
                      }
                      return Container();
                    },
                  )
                : const Center(
                    child: Text(
                      'No users yet.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
