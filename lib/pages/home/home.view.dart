import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:zeffaf/pages/chat.list/view.dart';
import 'package:zeffaf/pages/search_filter/serachFilter.view.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/cards/mutual_card.dart';

import '../../widgets/app_header.dart';
import 'header.dart';
import 'home.controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final controller = Get.find<HomeController>();
  @override
  void initState() {
    _loadAd();
    controller.updateByToken(false);
    super.initState();
  }

  BannerAd? _bannerAd;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    final String adUnitId = Platform.isAndroid
        ? 'ca-app-pub-4507353466512419/7558017972'
        : 'ca-app-pub-4507353466512419/9094587893';

    final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          debugPrint(
              'BannerAd success to load: ${ad.responseInfo?.toString()}');
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[400]
          : Colors.grey[700],
      body: Obx(
        () => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BaseAppHeader(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[400]
                  : Colors.grey[700],
              headerLength: 350,
              position: statusBarHeight > 50.0
                  ? Get.height * 0.15
                  : Get.height * 0.118,
              centerTitle: true,
              title: Image.asset(
                "assets/images/log_in/logo-white.png",
                height: 60,
                width: 60,
              ),
              actions: [
                if (controller.weather.value.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        controller.weather.value,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/weather_icon.png',
                        width: 35,
                        height: 35,
                      )
                    ],
                  )
                ],
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => Get.to(() => SearchFilter()),
                ),
              ],
              leading: message(controller),
              refresh: () => controller.updateByToken(false),
              body: const HomeHeader(),
              children: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          if (_bannerAd != null) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                width: double.infinity,
                                color: Theme.of(context).backgroundColor,
                                height: AdSize.banner.height.toDouble(),
                                child: AdWidget(
                                  ad: _bannerAd!,
                                  key: ValueKey(_bannerAd!.hashCode),
                                ),
                              ),
                            ),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "المتواجدون في بلدك",
                                style: Get.textTheme.bodyText2!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              InkWell(
                                onTap: () async {
                                  await Get.toNamed("/SearchResult",
                                      arguments: [
                                        context,
                                        0,
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        90,
                                        18,
                                        '',
                                        '',
                                        '',
                                        ''
                                      ]);
                                },
                                child: Text(
                                  "more".tr,
                                  style: Get.textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 110),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) => MutualCard(controller.users[index]),
                      childCount: controller.users.length,
                    ),
                  ),
                )
              ],
            ),
            if (controller.news.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: NewsTicker(
                  htmlTexts: controller.news
                      .map((element) => element.data ?? '   ')
                      .toList(),
                  isMan: controller.appController.isMan.value == 0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget message(HomeController controller) {
    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Icon(
              Icons.message_outlined,
              color: AppTheme.WHITE,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Obx(() => controller.appController.newChats.value == 0
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Get.find<HomeController>()
                                  .appController
                                  .isMan
                                  .value ==
                              0
                          ? Get.theme.colorScheme.secondary
                          : Get.theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      controller.appController.newChats.value.toString(),
                      style: TextStyle(color: AppTheme.WHITE),
                    ),
                  )),
          ),
        ],
      ),
      onTap: () => Get.to(() => const ChatList()),
    );
  }
}

class NewsTicker extends StatefulWidget {
  final List<String> htmlTexts;
  final bool isMan;

  NewsTicker({required this.htmlTexts, required this.isMan});

  @override
  _NewsTickerState createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker> {
  ScrollController _scrollController = ScrollController();
  late Timer _timer;
  final double _scrollSpeed = 1.0;
  bool _scrollForward = true;

  @override
  void initState() {
    super.initState();
    _startScrolling();
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double pixels = _scrollController.position.pixels;

        if (_scrollForward) {
          pixels += _scrollSpeed;
          if (pixels >= maxScroll) {
            pixels = maxScroll;
            _scrollForward = false;
          }
        } else {
          pixels -= _scrollSpeed;
          if (pixels <= 0) {
            pixels = 0;
            _scrollForward = true;
          }
        }

        _scrollController.jumpTo(pixels);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 65),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        border: Border.all(
          color: widget.isMan
              ? Get.theme.primaryColor
              : Get.theme.colorScheme.secondary,
        ),
        color: Theme.of(context).backgroundColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Center(
          child: Text(
            htmlToPlainText(widget.htmlTexts.join(widget.isMan ? '🔸' : '🔹')),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  String htmlToPlainText(String htmlText) {
    // Parse the HTML text
    dom.Document document = html_parser.parse(htmlText);

    // Extract the plain text from the parsed document
    return document.body?.text ?? '';
  }
}
