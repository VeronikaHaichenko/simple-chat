import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simple_chat/screens/auth_screen.dart';
import 'package:simple_chat/screens/chat_screen.dart';
import 'package:simple_chat/screens/chats_screen.dart';
import 'package:simple_chat/screens/splash_screen.dart';
import 'package:simple_chat/screens/users_screen.dart';
import 'package:simple_chat/widgets/auth/auth_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final log = Logger();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (ctx, appSnapshot) {
        return MaterialApp(
          title: 'Simple Chat',
          theme: ThemeData(
            accentColor: Color(0xff4F8480),
            // accentColor: Color.fromARGB(255, 78, 185, 12),
            primaryColor: Color(0xff0F3B39),
            // primaryColor: Colors.lightGreenAccent[700],
            // backgroundColor: Colors.black54,
            scaffoldBackgroundColor: Color(0xff195E5B),
            // scaffoldBackgroundColor: Color(0xff195E5B),
            // scaffoldBackgroundColor: Colors.black54,
            textTheme: TextTheme(
              headline1: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headline2: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              bodyText1: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              focusColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              errorStyle: TextStyle(color: Colors.white),
            ),
          ),
          home: appSnapshot.connectionState == ConnectionState.waiting
              ? SplashScreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SplashScreen();
                    }
                    if (userSnapshot.hasData) {
                      final User user = userSnapshot.data as User;
                      currentUid = user.uid;
                      log.d(currentUid);
                      return ChatsScreen();
                    }
                    return AuthScreen();
                  },
                ),
          routes: {
            UsersScreen.routeName: (context) => UsersScreen(),
            ChatScreen.routeName: (context) => ChatScreen(),
          },
        );
      },
    );
  }
}
