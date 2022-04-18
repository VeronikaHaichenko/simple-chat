import 'package:flutter/material.dart';

class LoginPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundImage: AssetImage('assets/images/smile2.png'),
          radius: 45,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'SIMPLE CHAT',
          style: Theme.of(context).textTheme.headline2,
        ),
      ],
    );
  }
}
