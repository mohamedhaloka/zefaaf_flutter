import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/favorites/favorites.controller.dart';
import 'package:zeffaf/pages/home/home.controller.dart';
import 'package:zeffaf/pages/more/more.controller.dart';
import 'package:zeffaf/widgets/system_dialog.dart';

import '../appController.dart';
import '../pages/favorites/favorites.view.dart';
import '../pages/home/home.view.dart';
import '../pages/more/more.view.dart';
import '../pages/myAccount/myAccount.view.dart';
import '../pages/notifications/notifications.view.dart';
import '../utils/theme.dart';

class BottomTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomTabsController>(() => BottomTabsController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<MoreController>(() => MoreController());
  }
}

class BottomTabsController extends GetxController {
  final RxInt _selectedIndex = 0.obs;
  get selectedIndex => _selectedIndex.value;
  final appController = Get.find<AppController>();
  void setSelectedIndex(index) => _selectedIndex.value = index;

  dynamic arg = Get.arguments;

  @override
  void onInit() {
    setSelectedIndex(0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (arg == null) return;

      showWelcomeDialog();
    });

    super.onInit();
  }

  void showWelcomeDialog() {
    final isMan = appController.isMan.value == 0;
    Get.dialog(SystemDialog(
      title: "رسالة ترحيبية من الإدارة لك",
      iconPath: 'assets/images/message_from_zefaaf.svg',
      iconColor:
          !isMan ? Get.theme.primaryColor : Get.theme.colorScheme.secondary,
      buttonText: 'مشاهدة',
      onPress: () {
        Get.back();
        Get.toNamed('/MessageFromZefaafView');
      },
      showBackBtn: true,
      isMan: isMan,
    ));
  }

  final List<PageItem> widgetOptions = const <PageItem>[
    PageItem(id: 0, text: 'الرئيسية', icon: 'home', child: Home()),
    PageItem(
        id: 1,
        text: 'الإشعارات',
        icon: 'notification',
        child: Notifications(notInTab: false)),
    PageItem(id: 2, text: 'حسابي', icon: 'account', child: MyAccount(false)),
    PageItem(id: 3, text: 'المفضلة', icon: 'favorite', child: Favorites()),
    PageItem(id: 4, text: 'المزيد', icon: 'more', child: More()),
  ];
}

class PageItem {
  final int id;
  final String text, icon;
  final Widget child;
  const PageItem(
      {required this.id,
      required this.text,
      required this.icon,
      required this.child});
}

class BottomTabsHome extends StatefulWidget {
  const BottomTabsHome({super.key});

  @override
  State<BottomTabsHome> createState() => _BottomTabsHomeState();
}

class _BottomTabsHomeState extends State<BottomTabsHome> {
  final controller = Get.find<BottomTabsController>();

  @override
  Widget build(context) => Obx(
        () => Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: controller.widgetOptions
                    .elementAt(controller.selectedIndex)
                    .child,
              ),
              const _BottomBar(),
            ],
          ),
        ),
      );
}

class _BottomBar extends GetView<BottomTabsController> {
  const _BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: 80,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 60,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 3,
                          blurRadius: 8)
                    ]),
                child: Row(
                  children: controller.widgetOptions.map((e) {
                    final isSelected = e.id == controller.selectedIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () => controller.setSelectedIndex(e.id),
                        child: Column(
                          children: [
                            if (e.id != 2) ...[
                              Expanded(
                                child: SvgPicture.asset(
                                  'assets/images/home/tabs/${e.icon}.svg',
                                  height: 16,
                                  width: 16,
                                  color: e.id == 2
                                      ? AppTheme.WHITE
                                      : isSelected
                                          ? Get.find<AppController>()
                                                      .isMan
                                                      .value ==
                                                  0
                                              ? Get.theme.primaryColor
                                              : Get.theme.colorScheme.secondary
                                          : Colors.grey[400],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Get.find<AppController>()
                                                      .isMan
                                                      .value ==
                                                  0
                                              ? Get.theme.primaryColor
                                              : Get.theme.colorScheme.secondary
                                          : Colors.grey[400],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              )
                            ]
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                top: 0,
                child: InkWell(
                  onTap: () => controller.setSelectedIndex(2),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    child: CircleAvatar(
                      backgroundColor:
                          Get.find<AppController>().isMan.value == 0
                              ? Get.theme.primaryColor
                              : Get.theme.colorScheme.secondary,
                      child: Icon(
                        Icons.person,
                        color: AppTheme.WHITE,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
