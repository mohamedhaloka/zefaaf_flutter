import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/message.details.dart';
import 'package:zeffaf/pages/chat.details/chat.details.controller.dart';

class SocketService extends GetxService {
  static const String URI = "https://zefaaf-chat23.herokuapp.com";
  // SocketIOManager manager;
  IO.Socket? socket;
  RxString userStatue = RxString("");
  RxInt userAvailable = RxInt(0);
  RxString roomName = RxString("");
  RxBool readAllMessage = RxBool(false);
  RxBool updatedChatList = RxBool(false);
  RxInt recordId = RxInt(0);

  Future<SocketService> init() async {
    return this;
  }

  void disconnectSocket() {
    socket?.io.disconnect();
    socket?.dispose();
    socket = null;
  }

  void initSocket(String identifier, String token) async {
    IO.cache.clear();
    if (socket != null) {
      socket!.io.disconnect();
    }

    socket = IO.io(
        URI,
        OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({
              'token': token,
              "chatID": identifier,
              "timestamp": DateTime.now().toString()
            })
            .disableAutoConnect() // disable auto-connection

            // for Flutter or Dart VM
            // .setExtraHeaders() // optional
            .build());

    socket!
      ..disconnect()
      ..connect();

    socket!.onConnect((data) {
      log('onConnect');
    });
    socket!.onConnectError((error) {
      log('onConnectError');
    });
    socket!.onConnectTimeout((error) {
      log('onConnectTimeout');
    });

    socket!.onError((error) {
      log('onError');
    });

    socket!.onDisconnect((data) {
      log('onDisconnect');
    });

    socket!.on("receive_message", (jsonData) {
      final appController = Get.find<AppController>();
      var data = json.decode(json.encode(jsonData));
      String senderChatID =
          data['senderChatID'].toLowerCase().toString().trim();
      String otherUserName = roomName.value.toLowerCase().toString().trim();

      updatedChatList.value = !updatedChatList.value;

      if (otherUserName == senderChatID) {
        final chatDetailsController = Get.find<ChatDetailsController>();

        userAvailable(1);
        chatDetailsController.messages.add(MessageModal(
            type: int.parse(data['type']),
            message: data['content'],
            owner: 1,
            played: 0,
            assetsAudioPlayer: AudioPlayer(),
            plyBtn: Icons.play_arrow.obs,
            voiceTime: int.parse(data['type']) == 3
                ? data['voiceTime'].toString()
                : "",
            parent: int.tryParse(data['parent'].toString()) ?? 0,
            parentType: int.tryParse(data['parentType'].toString()) ?? 0,
            parentMessage: data['parentMessage'],
            messageTime: DateTime.now()
                .subtract(Duration(hours: appController.timeZoneOffset.value))
                .toString(),
            readed: 1,
            id: int.parse(data['messageId'])));

        chatDetailsController.playLocal('text_tone');

        Future.delayed(const Duration(milliseconds: 200), () {
          chatDetailsController.scrollController.jumpTo(
              chatDetailsController.scrollController.position.maxScrollExtent);
        });

        //Socket - Send Confirm Readied
        var socketMessage = json.encode({
          'receiverChatID': chatDetailsController.otherUserName,
          'chatId': chatDetailsController.chatId.value
        });
        sendMessage("confirm_readed", [socketMessage]);
      }
    });

    socket!.on("receive_typing", (jsonData) {
      var data = json.decode(json.encode(jsonData));
      if (roomName.value == data['senderChatID']) {
        userAvailable(1);
        userStatue("جاري الكتابة..");
      }
    });

    socket!.on("send_message", (_) => _);

    socket!.on("receive_stop_typing", (jsonData) {
      var data = json.decode(json.encode(jsonData));
      if (roomName.value == data['senderChatID']) {
        userStatue("");
      }
    });

    socket!.on("receive_recording", (jsonData) {
      var data = json.decode(json.encode(jsonData));
      if (roomName.value == data['senderChatID']) {
        userAvailable(1);
        userStatue("جاري تسجيل مقطع صوتي...");
      }
    });

    socket!.on("receive_confirm_readed", (jsonData) {
      var data = json.decode(json.encode(jsonData));
      if (roomName.value == data['senderChatID']) {
        userAvailable(1);
        readAllMessage.value = !readAllMessage.value;
      }
    });

    socket!.on("receive_confirm_playing", (jsonData) {
      var data = json.decode(json.encode(jsonData));
      recordId(data['messageId']);
      if (roomName.value == data['senderChatID']) {
        userAvailable(1);
      }
    });

    socket!.on("receive_stop_recording", (jsonData) {
      var data = json.decode(json.encode(jsonData));
      if (roomName.value == data['senderChatID']) {
        userStatue("");
      }
    });
//------
// //     socket.connect();
  }

  sendMessage(type, message) {
    socket!.emit(type, message);
  }
}
