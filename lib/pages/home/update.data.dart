import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/socketService.dart';

import '../../services/http.service.dart';

class UpdateData {
  static loginByToken(
      {required String pushToken,
      required String notificationOpenDate,
      required String detectedCountryName,
      required String apiToken,
      required String mobileType,
      required AppController appController,
      required bool restart,
      required SocketService socket,
      required Function logOut,
      required FirebaseMessaging firebaseMessaging}) async {
    print("This is the detected country name: $detectedCountryName");
    String url = "${Request.urlBase}loginByToken";

    var loginByTokenBody = {
      'deviceToken': pushToken,
      'notificationOpenDate': notificationOpenDate,
      'mobileType': mobileType,
      'detectedCountry':
          detectedCountryName.trim().isEmpty ? 'unknown' : detectedCountryName
    };

    log(loginByTokenBody.toString(), name: 'MAP');
    var loginByTokenHeader = {'Authorization': 'Bearer $apiToken'};

    http.Response response = await http.post(Uri.parse(url),
        body: loginByTokenBody, headers: loginByTokenHeader);

    var data = json.decode(response.body);

    if (data['status'] == "success") {
      var result = json.decode(response.body);
      appController.updateUserDate(result);
      appController.updateAPiToken(json.decode(response.body)['token']);

      appController
          .updateGender(json.decode(response.body)['data'][0]['gender']);

      appController
          .saveStatue(json.decode(response.body)['data'][0]['available']);

      if (restart) {
        final countryId = appController.userData.value.residentCountryId;
        firebaseMessaging.subscribeToTopic('all');
        firebaseMessaging.subscribeToTopic('country-$countryId');

        if (appController.isMan.value == 0) {
          firebaseMessaging.subscribeToTopic('man');
        } else {
          firebaseMessaging.subscribeToTopic('woman');
        }

        socket.initSocket(json.decode(response.body)['data'][0]['userName'],
            json.decode(response.body)['token']);
      }
    } else if (data['status'] == "error") {
      logOut();
    }
  }
}
