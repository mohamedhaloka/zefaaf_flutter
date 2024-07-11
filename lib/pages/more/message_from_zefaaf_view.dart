import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/app_header.dart';

class MessageFromZefaafView extends StatelessWidget {
  const MessageFromZefaafView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: BaseAppHeader(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Get.back(),
          )
        ],
        title: Text(
          "رسالة من زفاف",
          style: Get.textTheme.bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        children: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: HtmlWidget(
                    '''
                        <p>رسالة ترحيبية من الإدارة لك</p>
                        <iframe width="420" height="315"
src="https://www.youtube.com/embed/tgbNymZ7vqY?autoplay=1&mute=1">
</iframe>
                        ''',
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
