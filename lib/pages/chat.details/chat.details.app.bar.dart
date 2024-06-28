import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import '../../appController.dart';
import '../user_details/user_details.view.dart';
import 'chat.details.controller.dart';

chatDetailsAppBar(User user, ChatDetailsController controller,
    Function onWillPOP, bool inUserDetails) {
  return AppBar(
    leadingWidth: 0,
    toolbarHeight: 80,
    backgroundColor: Colors.transparent,
    title: FittedBox(
      child: InkWell(
        onTap: inUserDetails
            ? null
            : () {
                if (user.id == null) return;
                Get.to(() => UserDetails(
                    isFavourite: false, userId: user.id!, inChatRoom: true));
              },
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: controller.appController.isMan.value == 0
                  ? Get.theme.colorScheme.secondary
                  : Get.theme.primaryColor,
              backgroundImage: user.userImage == "" || user.userImage == null
                  ? AssetImage(controller.appController.isMan.value == 0
                      ? "assets/images/register_landing/female.png"
                      : "assets/images/register_landing/male.png")
                  : NetworkImage(
                          "https://zefaafapi.com/uploadFolder/small/${user.userImage}")
                      as ImageProvider,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: controller.userDetails.packageLevel == 0 ? 8 : 14,
                  height: controller.userDetails.packageLevel == 0 ? 8 : 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.socket.userAvailable.value == 1
                        ? Colors.green
                        : controller.socket.userAvailable.value == 0
                            ? Colors.grey
                            : Colors.red,
                  ),
                  child: Get.find<AppController>().isMan.value == 0 &&
                          controller.userDetails.packageLevel != 0
                      ? Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(
                            "assets/images/home/crown.png",
                            height: 4,
                            width: 4,
                          ),
                        )
                      : Get.find<AppController>().isMan.value == 1 &&
                              (controller.userDetails.packageLevel == 1 ||
                                  controller.userDetails.packageLevel == 2 ||
                                  controller.userDetails.packageLevel == 3)
                          ? const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            )
                          : Get.find<AppController>().isMan.value == 1 &&
                                  controller.userDetails.packageLevel == 4
                              ? Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset(
                                    "assets/images/platinum.png",
                                    height: 13,
                                    width: 13,
                                  ),
                                )
                              : Get.find<AppController>().isMan.value == 1 &&
                                      controller.userDetails.packageLevel == 5
                                  ? Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Image.asset(
                                        "assets/images/diamond.png",
                                        height: 13,
                                        width: 13,
                                      ),
                                    )
                                  : const SizedBox(),
                ),
              ),
            ),
            const CustomSizedBox(
              widthNum: 0.02,
              heightNum: 0.0,
            ),
            controller.loading.value
                ? const SizedBox()
                : controller.ignoreToChat.value
                    ? const SizedBox()
                    : Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${user.userName}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                    Get.find<AppController>().isMan.value ==
                                                0 &&
                                            Get.find<AppController>()
                                                    .userData
                                                    .value
                                                    .packageLevel! <=
                                                2
                                        ? "ميزة تحديد الموقع للعضويات الذهبية"
                                        : Get.find<AppController>()
                                                        .isMan
                                                        .value ==
                                                    1 &&
                                                Get.find<AppController>()
                                                        .userData
                                                        .value
                                                        .packageLevel ==
                                                    6
                                            ? 'ميزة تحديد الموقع للعضويات الوردية'
                                            : "${user.detectedCountry}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: controller.appController.isMan
                                                    .value ==
                                                0
                                            ? Get.theme.colorScheme.secondary
                                            : Get.theme.primaryColor,
                                        fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          width: 1,
                                          color: controller.appController.isMan
                                                      .value ==
                                                  0
                                              ? Colors.white
                                              : Colors.black)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 10,
                                        color: controller.appController.isMan
                                                    .value ==
                                                0
                                            ? Colors.grey[300]
                                            : Colors.black,
                                      ),
                                      Text(
                                        "${user.residentCountryName}، ${user.cityName}",
                                        style: TextStyle(
                                            color: controller.appController
                                                        .isMan.value ==
                                                    0
                                                ? Colors.grey[300]
                                                : Colors.black,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                controller.socket.userAvailable.value == 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("آخر ظهور",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 8)),
                                          timeConverter(
                                            dateTime: DateTime.parse(
                                                    user.lastAccess.toString())
                                                .add(Duration(
                                                    hours: controller
                                                        .appController
                                                        .timeZoneOffset
                                                        .value)),
                                            dateTime2: user.lastAccessDate,
                                            time: user.lastAccess.toString(),
                                            dateTimeStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 8),
                                          )
                                        ],
                                      )
                                    : user.available == 2
                                        ? const Text("مشغول الآن",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 8))
                                        : controller.socket.userAvailable
                                                    .value ==
                                                1
                                            ? const Text("متصل الآن",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 8))
                                            : const SizedBox()
                              ],
                            ),
                            Text(
                              controller.socket.userStatue.value,
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      controller.appController.isMan.value == 0
                                          ? Get.theme.colorScheme.secondary
                                          : Get.theme.primaryColor),
                            ),
                          ],
                        ))
          ],
        ),
      ),
    ),
    actions: [
      controller.ignoreToChat.value
          ? const SizedBox()
          : PopupMenuButton<String>(
              onSelected: controller.choiceAction,
              icon: const Icon(Icons.more_vert_sharp),
              tooltip: "خيارات إضافية",
              itemBuilder: (BuildContext context) {
                return controller.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
      IconButton(
        icon: const Icon(Icons.arrow_forward),
        color: Colors.white,
        onPressed: () {
          onWillPOP();
        },
      )
    ],
    elevation: 0.0,
    leading: Container(),
  );
}

Widget timeConverter({dateTime, dateTime2, dateTimeStyle, time}) {
  return Text(
    dateTime == null
        ? ""
        : "${checkDate(dateTime.toString())} في ${DateTimeUtil.convertTime(time.toString())}",
    style: dateTimeStyle,
  );
}

String checkDate(String dateString) {
  DateTime checkedTime = DateTime.parse(dateString);
  DateTime currentTime = DateTime.now();

  if ((currentTime.year == checkedTime.year) &&
      (currentTime.month == checkedTime.month) &&
      (currentTime.day == checkedTime.day)) {
    return "اليوم";
  } else if ((currentTime.year == checkedTime.year) &&
      (currentTime.month == checkedTime.month)) {
    if ((currentTime.day - checkedTime.day) == 1) {
      return "آمس";
    } else if ((currentTime.day - checkedTime.day) == -1) {
      return "آمس";
    } else {
      return DateTimeUtil.convertToNameOfDay(dateString);
    }
  }
  return DateTimeUtil.convertDate(dateString);
}
