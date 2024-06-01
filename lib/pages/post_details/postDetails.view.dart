import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/post.dart';
import 'package:zeffaf/pages/post_details/PostDetails.controller.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/widgets/custom_image.dart';

import '../../widgets/app_header.dart';

class PostDetails extends GetView<PostDetailsController> {
  final Post post;
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Get.theme.brightness == Brightness.light
          ? Colors.grey[300]
          : Colors.grey[900],
      body: BaseAppHeader(
        backgroundColor: Get.theme.brightness == Brightness.light
            ? Colors.grey[300]
            : Colors.grey[900],
        title: Text("articles".tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Get.back(),
          )
        ],
        children: [
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          DateTimeUtil.convertTimeWithDate(post.postDateTime),
                          style: Get.textTheme.bodyText2!
                              .copyWith(color: Get.theme.colorScheme.secondary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          post.title ?? '',
                          style: Get.textTheme.bodyText2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      cachedNetworkImage(post.featureImage ?? '',
                          radius: 15.0,
                          height: 230.0,
                          width: Get.mediaQuery.size.width),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: HtmlWidget(
                          post.post!,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  const PostDetails({required this.post});
}
