import 'package:flutter/material.dart';
import 'package:flutter_chatapps/presentation/pages/chat/chat_page.dart';

class AppWidgets extends StatelessWidget {
  const AppWidgets({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}
