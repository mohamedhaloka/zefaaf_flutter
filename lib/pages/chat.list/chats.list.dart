import 'package:flutter/material.dart';
import 'package:zeffaf/models/user.chats.dart';
import 'package:zeffaf/pages/chat.list/chat.body.dart';

class ChatsList extends StatelessWidget {
  ChatsList({
    required this.chats,
    required this.filter,
  });
  List<UserChats> chats;
  String filter;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: chats.length, //productInfo.length
        itemBuilder: (context, index) {
          return filter == ""
              ? ChatBody(
                  userChats: chats[index],
                )
              : chats[index]
                      .otherName!
                      .toLowerCase()
                      .contains(filter.toLowerCase())
                  ? ChatBody(
                      userChats: chats[index],
                    )
                  : Container();
        },
      ),
    );
  }
}
