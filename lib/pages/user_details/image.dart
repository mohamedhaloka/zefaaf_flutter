import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/utils/theme.dart';

import 'image.viewer.dart';

class ImageAction extends StatelessWidget {
  final String? image;
  final int isLive;
  final int isPremium;
  final Widget center;
  final bool loading;
  final User user;
  final Function() cancelRequestPhotoOnTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                maxScale: 100,
                scaleEnabled: true,
                child: InkWell(
                  onTap: (user.allowImage == "0" &&
                          (user.requestImage == "0" ||
                              user.requestImage == "1") &&
                          image == "")
                      ? () {}
                      : () {
                          Get.to(() => ImageViewer(
                                imageSrc: image,
                              ));
                        },
                  child: ClipRRect(
                    child: Container(
                        height: 107,
                        width: 107,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Get.theme.colorScheme.secondary),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: image == "" || image == null
                                  ? AssetImage(Get.find<AppController>()
                                              .isMan
                                              .value ==
                                          0
                                      ? "assets/images/register_landing/female.png"
                                      : "assets/images/register_landing/male.png")
                                  : NetworkImage(
                                          "https://zefaafapi.com/uploadFolder/small/$image")
                                      as ImageProvider,
                              fit: BoxFit.cover),
                        ),
                        child: center),
                  ),
                ),
              ),
              if (isLive == 0 || isLive == 1 || isLive == 2)
                loading
                    ? SizedBox(
                        width: 22.0,
                        height: 22.0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!.withOpacity(0.6),
                          highlightColor: Colors.grey[100]!.withOpacity(0.6),
                          child: Container(
                            color: Colors.red,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                        child: Container(
                          width: isPremium == 0 ? 15 : 22,
                          height: isPremium == 0 ? 15 : 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLive == 2
                                ? Colors.red
                                : isLive == 1
                                    ? AppTheme.GREEN
                                    : Colors.grey,
                          ),
                          child: Get.find<AppController>().isMan.value == 0 &&
                                  isPremium != 0
                              ? Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset(
                                    "assets/images/home/crown.png",
                                    height: 13,
                                    width: 13,
                                  ),
                                )
                              : Get.find<AppController>().isMan.value == 1 &&
                                      (isPremium == 1 ||
                                          isPremium == 2 ||
                                          isPremium == 3)
                                  ? const Icon(
                                      Icons.star,
                                      size: 18,
                                      color: Colors.amber,
                                    )
                                  : Get.find<AppController>().isMan.value ==
                                              1 &&
                                          isPremium == 4
                                      ? Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Image.asset(
                                            "assets/images/platinum.png",
                                            height: 13,
                                            width: 13,
                                          ),
                                        )
                                      : Get.find<AppController>().isMan.value ==
                                                  1 &&
                                              isPremium == 5
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Image.asset(
                                                "assets/images/diamond.png",
                                                height: 13,
                                                width: 13,
                                              ),
                                            )
                                          : const SizedBox(),
                        ),
                      ),
              Positioned(
                left: 4,
                top: 4,
                child: loading
                    ? const SizedBox()
                    : (user.allowImage == "0" && user.requestImage == "1") ||
                            (user.allowImage == "1")
                        ? Tooltip(
                            message: 'إلغاء طلب مشاهدة الصورة',
                            child: InkWell(
                                onTap: cancelRequestPhotoOnTap,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red[700],
                                  radius: 10.5,
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                  ),
                                )),
                          )
                        : const SizedBox(),
              )
            ],
          ),
        ],
      ),
    );
  }

  const ImageAction(this.user, this.image, this.center, this.isLive,
      this.isPremium, this.loading, this.cancelRequestPhotoOnTap);
}
