import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageModal {
  int? id, owner, type, parent, parentType, played;
  String? message, messageTime, messageDate, messageTimeOnly, voiceTime;
  dynamic parentMessage;
  AudioPlayer? assetsAudioPlayer = AudioPlayer();
  Rx<IconData>? plyBtn = Icons.play_arrow.obs;
  int? readed;
  MessageModal(
      {this.id,
      this.message,
      this.type,
      this.parentMessage,
      this.messageDate,
      this.voiceTime,
      this.assetsAudioPlayer,
      this.messageTimeOnly,
      this.plyBtn,
      this.parent,
      this.parentType,
      this.played,
      this.messageTime,
      this.owner,
      this.readed});

  MessageModal.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    messageTime = map['messageTime'];
    message = map['message'];
    messageTimeOnly = map['messageTimeOnly'];
    parentType = map['parentType'];
    messageDate = map['messageDate'];
    voiceTime = map['voiceTime'];
    parent = map['parent'];
    played = map['played'];
    parentMessage = map['parentMessage'];
    type = map['type'];
    owner = map['owner'];
    readed = map['readed'];
  }
}
