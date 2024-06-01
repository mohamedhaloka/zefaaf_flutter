import 'dart:async';
import 'dart:convert';

// import 'package:audioplayers/';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/message.details.dart';
import 'package:zeffaf/models/reply.message.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/chat.list/chat.list.controller.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/utils/toast.dart';

import '../../services/socketService.dart';
import '../new.message/newMessage.view.dart';

class ChatDetailsController extends GetxController {
  //Call AppController to can access all Vars in it
  final appController = Get.find<AppController>();
  //Call SocketController to use it in Socket Service
  final socket = Get.find<SocketService>();
  //Send it in confirmReadied
  RxString chatId = RxString("");
  RxString chatIdForResumeApp = RxString("");
  //It include message
  RxString userMessage = RxString("");
  //Call AppController to can access all Vars in it
  RxInt otherId = RxInt(0);
  RxInt currentPage = RxInt(0);
  //To send it in Socket body
  late String otherUserName;
  //Message controller
  TextEditingController messageContent = TextEditingController();
  //Timer in Recording
  final StopWatchTimer stopWatchTimer = StopWatchTimer();
  AutoScrollController scrollController = AutoScrollController();
  //Audio Player to Control audios
  // final assetsAudioPlayer = AssetsAudioPlayer();
  //Loading chat messages
  RxBool loading = true.obs;
  RxBool ignoreToChat = false.obs;
  String ignoreMessage = ' لا يمكنك مراسلة هذا العضو حالياً';
  int messageId = 0;
  RxString maxRecordTime = RxString('');
  //Loading until send message
  RxBool sendMessageLoading = false.obs;
  //record path
  RxString recordFilePath = RxString("");
  RxInt i = RxInt(0);

  //Recording
  RxBool isPlaying = false.obs;
  RxBool recording = true.obs;
  RxList<Color> messageMentionColor = RxList<Color>([]);
  //All Lists that include all messages
  RxList<MessageModal> messages = RxList([]);
  // RxList<AssetsAudioPlayer> assetsAudioPlugin = RxList([]);
  AudioPlayer assetsAudioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  //Stickers Box
  RxString emojiURL = RxString("");
  RxString stickersURL = RxString("");
  RxList<TabsHeader> tabHeader = RxList([
    TabsHeader(tittle: "رموز تعبيرية", id: 0),
    TabsHeader(tittle: "ملصقات زفاف", id: 1)
  ]);
  RxInt selectedTab = 0.obs;
  RxMap emojiMap = RxMap({});
  RxList emoji = RxList([]);
  RxMap stickersMap = RxMap({});
  RxList stickers = RxList([]);
  RxList recordBox = RxList([]);
  //User Model to put all user data on it
  User userDetails = User();
  //To visible sticter or hid it when press the emoji button
  RxBool visibleSticker = false.obs;
  RxBool readiedAll = false.obs;
  RxBool isBackToChatList = false.obs;
  //PopUp Menu Item
  static String blockUser = 'حظر المستخدم';
  static String sendComplaint = 'إرسال شكوى';
  static String deleteChat = 'حذف المحادثة';

  //Reply Message Options
  RxBool replyContainerOpacity = false.obs;
  RxList<ReplyMessage> replyMessage = RxList<ReplyMessage>([]);
  Rx<ReplyMessage> replyMessageModal = ReplyMessage().obs;

  //close dialog by decrease opacity
  RxBool alertOpacity = RxBool(true);
  RxBool fetch = RxBool(false);

  @override
  void onInit() {
    getStickers();
    socket.readAllMessage.listen((val) {
      readiedAll.value = !readiedAll.value;
      for (int i = 0; i < messages.length; i++) {
        messages.value[i].readed = 2;
      }
    });

    socket.recordId.listen((val) {
      readiedAll.value = !readiedAll.value;
      for (int i = 0; i < messages.length; i++) {
        if (messages.value[i].id == socket.recordId.value) {
          // ignore: invalid_use_of_protected_member
          messages.value[i].played = 1;
        }
      }
    });
    //This is come active when user start typing
    interval(userMessage, (_) {
      startTyping();
    });

    //This is come active when user stop typing
    debounce(userMessage, (_) {
      endTyping();
    });
    super.onInit();
  }

  //Send Socket
  startTyping() {
    var socketMessage = json.encode({
      'receiverChatID': otherUserName,
    });
    socket.sendMessage("send_typing", [socketMessage]);
  }

  endTyping() {
    var socketMessage = json.encode({
      'receiverChatID': otherUserName,
    });
    socket.sendMessage("send_stop_typing", [socketMessage]);
  }

//Function in PopUp Menu
  void choiceAction(String choice) {
    if (choice == blockUser) {
      addToBlock(userDetails.id.toString(), 0.toString());
    } else if (choice == deleteChat) {
      hideChat(chatId.value);
      //
    }
  }

//List in PopUpMenu
  List<String> choices = <String>[blockUser, deleteChat];
//This is used in PopUpMenu in "Block User"
  Future addToBlock(userId, listId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}addToMyFavorites";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'otherId': "$userId", 'listType': "$listId"});

      var data = json.decode(response.body);

      if (data['rowsCount'] == 1) {
        final result = isBackToChatList.value
            ? Get.find<ChatListController>().getChatsList()
            : null;
        Get.back(result: result);
        Get.snackbar("تم بنجاح", "تمت إضافة المستخدم لقائمة التجاهل بنجاح!");
      } else {
        Get.snackbar("حدث خطأ!", "يرجي إعادة المحاولة لاحقاً!");
      }
    } else {
      Get.snackbar("خطأ!", "تأكد من إتصالك بالانترنيت وأعد المحاولة لاحقاً");
    }
  }

  Future hideChat(chatId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}hideChat";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'chatId': "$chatId"});

      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        final result = isBackToChatList.value
            ? Get.find<ChatListController>().getChatsList()
            : null;
        Get.back(result: result);
        Get.snackbar("تم بنجاح", "تم حذف المحادثة بنجاح");
      } else {
        Get.snackbar("حدث خطأ!", "يرجي إعادة المحاولة لاحقاً!");
      }
    } else {
      Get.snackbar("خطأ!", "تأكد من إتصالك بالانترنيت وأعد المحاولة لاحقاً");
    }
  }

  paginationLoadMoreMessage(chatId, page) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        currentPage.value++;
        fetch(true);
        loadMoreMessage(chatId, page);
      }
    });
  }

  loadMoreMessage(chatId, page) async {
    String url = "${Request.urlBase}getMorechatMessages/$chatId/$page";
    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});
    var responseData = json.decode(response.body);
    if (responseData['status'] == "success") {
      List data = responseData['data'];

      if (data.isEmpty) {
        currentPage(page - 1);
      }

      for (var message in responseData['data']) {
        messages.insert(0, MessageModal.fromJson(message));
      }
      fetch(false);
    } else {
      fetch(false);
    }
  }

  //send stop record in socket when user stop record
  stopRecordInSocket() {
    //send stop recording - socket
    var socketRecord = json.encode({
      'receiverChatID': otherUserName,
    });
    socket.sendMessage("send_stop_recording", [socketRecord]);
//
  }

//Function to get Sticker From API
  getStickers() async {
    String url = "${Request.urlBase}getStickers";
    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

    var responseData = json.decode(response.body);

    if (responseData['status'] == "success") {
      //Fetch EMOJI
      emojiURL.value = responseData['stickersDir'];
      emojiMap.value = responseData['stickers'];
      emoji.value = emojiMap.value.values.toList();

      //Fetch Stickers
      stickersURL.value = responseData['zefaafStickersDir'];
      stickersMap.value = responseData['zefaafStickers'];
      stickers.value = stickersMap.value.values.toList();
    } else {}
  }

//This is a Main Function , it can get userDetails and user Messages (from and to) in chat
  Future getChatDetails(otherId) async {
    String url = "${Request.urlBase}openChat";
    http.Response response = await http.post(Uri.parse(url),
        body: {'otherId': otherId, 'reverse': 1.toString()},
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});
    var responseData = json.decode(response.body);

    if (responseData['status'] == "success") {
      //---For socket
      otherUserName = responseData['otherDetails'][0]['userName'];
      //----
      return responseData;
    } else {
      return responseData;
    }
  }

//This is used when user open chat to get all message readied
  sendConfirmReadied() {
    var socketMessage =
        json.encode({'receiverChatID': otherUserName, 'chatId': chatId.value});
    socket.sendMessage("confirm_readed", [socketMessage]);
  }

  //This Function used to send Message Like text or sticker
  sendMessage(message, chatId, type, replyMessage, context) async {
    if (appController.userData.value.premium != 0) {
      //Add Message To Message List
      addMessageBubble(
          otherUserName: otherUserName,
          message: message,
          messageId: "0",
          voiceRecord: "",
          soundName: 'text_tone',
          replyMessageModal: replyMessage,
          type: type);
      //ScrollDown to The last Message
      //End Point
      String url = "${Request.urlBase}sendChatMessage";
      http.Response response = await http.post(Uri.parse(url), body: {
        'message': message,
        'chatId': chatId,
        'type': type,
        'parent': replyMessage == null
            ? 0.toString()
            : replyMessage.parent.toString(),
        'parentMessage':
            replyMessage == null ? "" : replyMessage.parentMessage ?? "",
        'parentType':
            replyMessage == null ? 0.toString() : replyMessage.type.toString()
      }, headers: {
        'Authorization': 'Bearer ${appController.apiToken.value}'
      }).timeout(const Duration(seconds: 5));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);

      var responseData = json.decode(response.body);
      if (responseData['status'] == "success") {
        //hide loading circle
        sendMessageLoading(false);
        //Display Record Icon
        recording(true);
        //Replace Message to Message Id
        messages.last.id = int.parse(responseData['messageId']);
        sendToSocket(
          otherUserName: otherUserName,
          message: message,
          voiceTime: "",
          messageId: responseData['messageId'],
          replyMessageModal: replyMessage,
          type: type,
        );
        //Clear Modal
        replyMessageModal.value.parentMessage = "";
        replyMessageModal.value.parent = 0;
        replyMessageModal.value.type = 0;
      } else {
        if (responseData['abuseFound'] == 1) {
          showToast("لا يجب إستخدام هذه الكلمة!");
          //Clear message
          messageContent.clear();
          //hide loading circle
          sendMessageLoading(false);
          //Display Record Icon
          recording(true);
          //Remove last record
          messages.remove(messages.last);
        } else if (responseData['errorCode'] == 'ignore list') {
          //Remove last record
          messages.remove(messages.last);
          //Display Record Icon
          recording(true);
          //ShowDialog to alarm user
          Get.dialog(AlertDialog(
            title: const Text("خطأ"),
            content: Text("لا تتوافق تطلعات $otherUserName مع ملفك "),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                ),
                child: const Text("حسناً"),
              )
            ],
          ));
        }
      }
    } else {
      upgradeYourAcc();
    }
  }

  sendToSocket(
      {otherUserName,
      message,
      messageId,
      voiceTime,
      type,
      ReplyMessage? replyMessageModal}) {
    //----Send socket message--
    var socketMessage = json.encode({
      'receiverChatID': otherUserName,
      'content': message,
      'type': type,
      'messageId': messageId,
      'voiceTime': voiceTime,
      'parent': replyMessageModal == null ? 0 : replyMessageModal.parent ?? "0",
      'parentType':
          replyMessageModal == null ? 0 : replyMessageModal.type ?? "0",
      'parentMessage':
          replyMessageModal == null ? "" : replyMessageModal.parentMessage ?? ""
    });
    socket.sendMessage("send_message", [socketMessage]);

    //---End of socket
  }

  addMessageBubble(
      {otherUserName,
      message,
      messageId,
      type,
      voiceRecord,
      soundName,
      ReplyMessage? replyMessageModal}) {
    if (alertOpacity.value) {
      alertOpacity(false);
    }
    //--Start Add Message
    messages.add(MessageModal(
        type: int.parse(type),
        message: message,
        // isSelected: false.obs,
        owner: 0,
        played: 0,
        // containerWidth: 120.0.obs,
        voiceTime: voiceRecord,
        assetsAudioPlayer: AudioPlayer(),
        plyBtn: Icons.play_arrow.obs,
        parent: replyMessageModal == null ? 0 : replyMessageModal.parent ?? 0,
        parentType: replyMessageModal == null ? 0 : replyMessageModal.type ?? 0,
        parentMessage: replyMessageModal == null
            ? ""
            : replyMessageModal.parentMessage ?? "",
        messageTime: DateTime.now()
            .subtract(Duration(hours: appController.timeZoneOffset.value))
            .toString(),
        readed: 1,
        id: int.parse(messageId)));
    replyMessage.add(replyMessageModal!);
    messageContent.clear();
    replyContainerOpacity(false);
    playLocal(soundName);
    //--End of Add Message
  }

//To use record use should check permission first
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('slslsl');
        return false;
      }
    }
    return true;
  }

  readRecord(messageId) {
    var socketMessage = json.encode({
      'receiverChatID': otherUserName,
      'chatId': chatId.value,
      'messageId': messageId
    });
    socket.sendMessage("confirm_playing", [socketMessage]);
  }

//Start record so easy
  void startRecord(assetsAudioPlayer) async {
    assetsAudioPlayer.stop();

    for (int i = 0; i < messages.length; i++) {
      messages[i].assetsAudioPlayer!.stop();
    }

    playLocal('record_tone');
    visibleSticker(false);
    Future.delayed(const Duration(milliseconds: 700), () async {
      bool hasPermission = await checkPermission();

      if (hasPermission) {
        isPlaying.value = true;

//send start recording - socket
        var socketMessage = json.encode({
          'receiverChatID': otherUserName,
        });
        socket.sendMessage("send_recording", [socketMessage]);
//
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
        recordFilePath.value = await getFilePath();
        await Record.start(
          path: recordFilePath.value, // required
          encoder: AudioEncoder.AAC, // by default
          bitRate: 128000,
        );
      } else {}
    });
  }

  void showDeleteChatMessageDialog(MessageModal message) =>
      Get.dialog(AlertDialog(
        title: Row(
          children: [
            Text(
              "هل تود حقاً حذف رسالتك؟",
              style: Get.theme.textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              CupertinoIcons.trash,
              color: Colors.red,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              _deleteChatMessage(message.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "نعم",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
            ),
            child: const Text(
              "لا",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ));

  Future<void> _deleteChatMessage(int id) async {
    // loading(true);
    String url = "${Request.urlBase}deleteChatMessage";
    http.Response response = await http.post(
      Uri.parse(url),
      body: {'id': id.toString()},
      headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
    );

    var responseData = json.decode(response.body);
    if (responseData['status'] == "success") {
      messages.removeWhere((element) => element.id == id);

      // loading(false);
    } else {
      // loading(false);
    }
  }

// to get file path , in start record we get file path first and pass it to record
  Future<String> getFilePath() async {
    print("pdkpdrr");
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/zefaaf_${i.value++}.m4a";

    return path;
  }

//To Stop record and timer and send "stop record" to second user in socket
  void stopRecord() async {
    Record.stop();
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    //send stop recording - socket
    var socketRecord = json.encode({
      'receiverChatID': otherUserName,
    });
    socket.sendMessage("send_stop_recording", [socketRecord]);
//
    isPlaying.value = false;
  }

  @override
  void onClose() {
    visibleSticker(false);
    super.onClose();
  }

//This Function to send record to API , This Function like sendMessage >> BUT I CREATE IT TO SEND RECORD
  Future sendAudio(chatId, recordPath, ReplyMessage replyMessage) async {
    if (appController.userData.value.premium != 0) {
      try {
        addMessageBubble(
          otherUserName: otherUserName,
          message: recordPath,
          messageId: "0",
          soundName: 'record_tone',
          voiceRecord: maxRecordTime.value,
          replyMessageModal: replyMessage,
          type: 3.toString(),
        );
        //End Point
        String url = "${Request.urlBase}sendChatMessage";
        //Request to send data to api
        var request = http.MultipartRequest('POST', Uri.parse(url));
        //Header
        request.headers.addAll(
            {'Authorization': 'Bearer ${appController.apiToken.value}'});
        //--Start Data
        request.fields['chatId'] = chatId;
        request.fields['type'] = 3.toString();
        request.fields['voiceTime'] = maxRecordTime.value;
        request.fields['parent'] = replyMessage.parent.toString();
        request.fields['parentMessage'] = replyMessage.parentMessage ?? "";
        request.fields['parentType'] = replyMessage.type.toString();
        //Record
        request.files
            .add(await http.MultipartFile.fromPath('attachment', recordPath));
        //--End Data
        //response of Request
        var response = await request.send();

        scrollController.jumpTo(scrollController.position.maxScrollExtent);

        response.stream.transform(utf8.decoder).listen((event) async {
          var responseData = json.decode(event);
          if (responseData['status'] == "success") {
            messages.last.id = int.parse(responseData['messageId']);
            //Add Message To Message List
            sendToSocket(
              otherUserName: otherUserName,
              message: responseData['message'],
              voiceTime: maxRecordTime.value,
              messageId: responseData['messageId'],
              replyMessageModal: replyMessage,
              type: 3.toString(),
            );
            //Clear Modal
            replyMessageModal.value.parentMessage = "";
            replyMessageModal.value.parent = 0;
            replyMessageModal.value.type = 0;
            return;
          } else if (responseData['errorCode'] == 'ignore list') {
            //Remove last record
            messages.remove(messages.last);
            //ShowDialog to alarm user
            Get.dialog(AlertDialog(
              title: const Text("خطأ"),
              content: Text("لا تتوافق تطلعات $otherUserName مع ملفك "),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor,
                  ),
                  child: const Text("حسناً"),
                )
              ],
            ));
          } else {
            sendMessageLoading(false);
            return;
          }
        }).onError((error) {
          sendMessageLoading(false);
        });
      } catch (e) {}
    } else {
      upgradeYourAcc();
    }
  }

  upgradeYourAcc() {
    Get.dialog(AlertDialog(
      title: Text(
        "قم بترقية باقتك",
        style: Get.theme.textTheme.bodyText1!.copyWith(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: const Text(" لايمكنك إرسال رسالتك حيث أنك على الباقة المجانية"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.toNamed('/packages');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
          ),
          child: const Text("أرغب بترقية الباقة"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.errorColor,
          ),
          child: const Text("شكراً لا أريد"),
        ),
      ],
    ));
  }

  Future playLocal(url) async {
    try {
      //play assets audio
      assetsAudioPlayer.play(AssetSource('sound/$url.mp3'));
      // audioCache.load("sound/$url.mp3");
      // // audioCache.play("sound/$url.mp3");

      return true;
    } catch (_) {
      return false;
    }
  }
}

class TabsHeader {
  String? tittle;
  int? id;

  TabsHeader({this.tittle, this.id});
}
