import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/post.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/widgets/custom_image.dart';

class PostsCard extends StatelessWidget {
  final Post post;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedNetworkImage(post.featureImage ?? '',
                  radius: 15.0,
                  height: 200.0,
                  topOnly: true,
                  width: Get.mediaQuery.size.width),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0, left: 12.0, top: 4.0, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateTimeUtil.convertTimeWithDate(post.postDateTime),
                      style: Get.textTheme.bodyText2!
                          .copyWith(color: Get.theme.colorScheme.secondary),
                    ),
                    Text(
                      post.title ?? '',
                      maxLines: 2,
                      style: Get.textTheme.bodyText2!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  const PostsCard(this.post, this.onTap);
}
