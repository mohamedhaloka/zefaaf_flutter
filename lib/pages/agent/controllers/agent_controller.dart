import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/http.service.dart';

import '../models/agent_modle.dart';

class AgentController extends GetxController {
  //init appController to use all vars in it
  final appController = Get.find<AppController>();
  //this list include all agents model
  List<AgentModel> agents = <AgentModel>[];
  //this var for showing loading before get data from api
  RxBool loading = true.obs;

  bool isSpecificAgent = Get.arguments;

  @override
  void onInit() {
    if (isSpecificAgent) {
      getSpecificAgent();
    } else {
      getAllAgents();
    }
    super.onInit();
  }

  Future<void> getSpecificAgent() async {
    String url = "${Request.urlBase}getPackages2";

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
    );
    var responseDecoded = json.decode(response.body);
    if (response.statusCode == 200) {
      agents.add(AgentModel.fromJson(responseDecoded['agent']));

      loading(false);
    } else {
      loading(false);
    }
  }

  Future<void> getAllAgents() async {
    String url = "${Request.urlBase}getAgents";

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
    );
    var responseDecoded = json.decode(response.body);
    if (response.statusCode == 200) {
      for (var agent in responseDecoded['data']) {
        agents.add(AgentModel.fromJson(agent));
      }

      loading(false);
    } else {
      loading(false);
    }
  }

  launchWhatsAppUri(String phoneNumber, String message) async {
    // Convert the WhatsAppUnilink instance to a Ur
    // The "launch" method is part of "url_launcher".
    await launchUrl(Uri.parse('whatsapp://send?phone=${phoneNumber}'
        "&text="));
  }

//   void launchURL(String url) async => await canLaunchUrl(Uri.parse(url))
//       ? await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
//       : throw 'Could not launch $url';
// }
}
