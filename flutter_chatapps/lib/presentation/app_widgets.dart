import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapps/presentation/pages/chat/chat_page.dart';

import 'pages/auth/auth_page.dart';

class AppWidgets extends StatelessWidget {
  const AppWidgets({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.deepPurple,
        backgroundColor: Colors.blue,
        buttonTheme: ButtonThemeData().copyWith(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              return ChatPage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
