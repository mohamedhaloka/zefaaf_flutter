import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/message.details.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/chat.details/chat.details.controller.dart';
import 'package:zeffaf/utils/audio/PositionSeekWidget.dart';

class RecordMessage extends StatefulWidget {
  RecordMessage(
      {required this.messageDetails,
      required this.index,
      required this.selectedIndex,
      required this.userDetails});
  MessageModal messageDetails;
  int index, selectedIndex;
  User userDetails;

  @override
  _RecordMessageState createState() => _RecordMessageState();
}

class _RecordMessageState extends State<RecordMessage> {
  final controller = Get.find<ChatDetailsController>();
  Rx<Duration> duration = const Duration().obs;
  Rx<Duration> position = const Duration().obs;

  late StreamSubscription<Duration> durationSubscription, positionSubscription;
  late StreamSubscription<PlayerState> audioPlayerStateSubscription;

  @override
  Widget build(BuildContext context) {
    MessageModal messageModal = widget.messageDetails;
    return Row(
      children: <Widget>[
        Visibility(
          visible: messageModal.owner == 0 ? true : false,
          child: buildUserPhotoCircle(
              controller.appController.profileImg.value,
              controller.appController.isMan.value == 0
                  ? "assets/images/register_landing/male.png"
                  : "assets/images/register_landing/female.png",
              messageModal),
        ),
        InkWell(
          onTap: () async {
            if (messageModal.plyBtn!.value == Icons.play_arrow) {
              try {
                if (messageModal.owner == 1) {
                  controller.readRecord(messageModal.id);
                  messageModal.played = 1;
                }
                setState(() {});

                await checkAudioPath(
                    widget.index,
                    messageModal.message!,
                    messageModal.assetsAudioPlayer!,
                    messageModal.plyBtn!.value,
                    controller.messages);

                setState(() {});
              } catch (e) {
                onPlayError();
                messageModal.plyBtn = Icons.play_arrow.obs;
                setState(() {});
              }
            } else {
              messageModal.plyBtn = Icons.play_arrow.obs;
              messageModal.assetsAudioPlayer!.stop();
              setState(() {});
            }

            audioPlayerStateSubscription = messageModal
                .assetsAudioPlayer!.onPlayerStateChanged
                .listen((event) {
              if (event == PlayerState.completed ||
                  event == PlayerState.stopped) {
                messageModal.plyBtn = Icons.play_arrow.obs;
                setState(() {});
              }
            });
          },
          child: Icon(
            messageModal.plyBtn!.value,
            color: Colors.black,
          ),
        ),
        Obx(() => PositionSeekWidget(
              currentPosition: position.value,
              duration: duration.value,
              recordTime: messageModal.voiceTime!,
              seekTo: (to) {
                messageModal.assetsAudioPlayer!.seek(to);
              },
            )),
        Visibility(
          visible: messageModal.owner == 1 ? true : false,
          child: buildUserPhotoCircle(
              widget.userDetails.userImage,
              controller.appController.isMan.value == 0
                  ? "assets/images/register_landing/female.png"
                  : "assets/images/register_landing/male.png",
              messageModal),
        ),
      ],
    );
  }

  buildUserPhotoCircle(userImage, imageSrc, MessageModal messageDetails) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 1,
              color:
                  messageDetails.played == 1 ? Colors.blue : Colors.grey[400]!),
          image: DecorationImage(
              image: userImage == "" || userImage == null
                  ? AssetImage(imageSrc)
                  : NetworkImage(
                          "https://zefaafapi.com/uploadFolder/small/$userImage")
                      as ImageProvider,
              fit: BoxFit.cover)),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Image.asset(
          'assets/images/mic-outfill.png',
          width: 12,
          color: messageDetails.played == 1 ? Colors.blue : Colors.grey[400],
        ),
      ),
    );
  }

  Future checkAudioPath(int index, String message, AudioPlayer myPlayer,
      IconData plyIcon, List<MessageModal> messages) async {
    print(message);
    if (message.contains('zefaaf')) {
      myPlayer.stop();
      await myPlayer.play(DeviceFileSource(message));
    } else {
      log('play audio ${'https://zefaafapi.com/$message'}');
      myPlayer.stop();
      await myPlayer.play(UrlSource("https://zefaafapi.com/$message"));
    }

    for (int i = 0; i < messages.length; i++) {
      if (i != index) {
        messages[i].assetsAudioPlayer!.stop();
        messages[i].plyBtn!.value = Icons.play_arrow;
      }
      if (i == index) {
        // messages[i].containerWidth.value = 230.0;
        messages[i].plyBtn!.value = Icons.pause_outlined;
        // messages[i].isSelected.value = true;
      }
    }

    durationSubscription = myPlayer.onDurationChanged.listen((event) {
      duration(event);
    });
    positionSubscription = myPlayer.onPositionChanged.listen((event) {
      position(event);
    });
  }

  onPlayError() {
    Get.dialog(AlertDialog(
      title: const Text("عفواً!"),
      content: const Text("يوجد خطأ في تشغيل الملف الصوتي"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.appController.isMan.value == 0
                ? Get.theme.primaryColor
                : Get.theme.colorScheme.secondary,
          ),
          child: const Text("حسناً"),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    try {
      durationSubscription.cancel();
    } catch (_) {}
    try {
      positionSubscription.cancel();
    } catch (_) {}
    try {
      audioPlayerStateSubscription.cancel();
    } catch (_) {}
    super.dispose();
  }
}
