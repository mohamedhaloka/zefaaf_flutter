import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';

class BaseAppHeader extends StatelessWidget {
  final List<Widget>? children;
  final List<Widget>? actions;
  final Widget? body;
  final ScrollController? controller;
  final Widget? title;
  final Function? refresh;
  final Widget? curveTitle;
  final Widget? leading;
  final double? headerLength;
  final double? position;
  final double? toolbarHeight;
  final double? collapsedHeight;
  final double? leadingWidth;
  final double? rightPosition;
  final Color? backgroundColor;
  final double? leftPosition;
  final bool? centerTitle;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Get.theme.primaryColor,
      color: Colors.white,
      onRefresh: () async {
        if (refresh != null) {
          refresh!();
        }
      },
      child: CustomScrollView(
        controller: controller,
        primary: false,
        clipBehavior: Clip.none,
        slivers: <Widget>[
          SliverAppBar(
            leadingWidth: leadingWidth ?? 60,
            toolbarHeight: toolbarHeight ?? 60,
            collapsedHeight: collapsedHeight ?? 90,
            backgroundColor: Get.theme.cardColor,
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            elevation: 0,
            pinned: true,
            floating: true,
            title: title,
            leading: leading,
            centerTitle: centerTitle,
            actions: actions,
            flexibleSpace: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          Get.find<AppController>().isMan.value == 0
                              ? "assets/images/home/male.png"
                              : "assets/images/home/female.png",
                          width: double.infinity,
                          height: (headerLength ?? 0) + 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Get.theme.scaffoldBackgroundColor
                                    : Colors.grey[900]),
                      ),
                    ],
                  ),
                ),
                if (body != null)
                  Positioned(
                      top: position,
                      left: leftPosition ?? 0,
                      right: rightPosition ?? 0,
                      child: body!),
                Container(
                  height: 25,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: backgroundColor ??
                        (Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[700]),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (curveTitle != null) curveTitle!,
                    ],
                  ),
                )
              ],
            ),
            expandedHeight: headerLength,
          ),
          ...?children,
        ],
      ),
    );
  }

  const BaseAppHeader(
      {required this.children,
      this.actions,
      this.backgroundColor,
      this.body,
      this.toolbarHeight,
      this.position = 90,
      this.title,
      this.leadingWidth,
      this.controller,
      this.rightPosition,
      this.leftPosition,
      this.leading,
      this.collapsedHeight,
      this.centerTitle = false,
      this.refresh,
      this.headerLength = 100,
      this.curveTitle});
}
