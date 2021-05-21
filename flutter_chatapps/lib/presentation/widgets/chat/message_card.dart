import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  MessageCard(
    this.message,
    this.isMe,
    this.userId,
  );

  final String message;
  final bool isMe;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.purple,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text("Loading...");
                    }

                    final user = userSnapshot.data;
                    return Text(
                      user['username'],
                      style: TextStyle(
                          color: isMe ? Colors.purple : Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  }),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.black : Colors.white,
                ),
                overflow: TextOverflow.clip,
                maxLines: 2,
                textAlign: isMe ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
