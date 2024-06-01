import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';

import '../../services/http.service.dart';

class PostsAPI {
  static increaseBlogView(
      {required String blogId, required AppController appController}) async {
    String url = "${Request.urlBase}updateBlogViews";

    http.Response response = await http.post(Uri.parse(url),
        body: {'blogId': blogId},
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

    if (response.statusCode == 200) {
    } else {}
  }
}
