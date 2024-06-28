import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/agent/views/widgets/agent_box.dart';
import 'package:zeffaf/pages/app_messages/AppMessage.loader.dart';
import 'package:zeffaf/widgets/app_header.dart';

import '../../../utils/package_item.dart';
import '../controllers/agent_controller.dart';

class AgentView extends GetView<AgentController> {
  const AgentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: controller.appController.isMan.value == 0
      //       ? Get.theme.primaryColor
      //       : Get.theme.colorScheme.secondary,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () => Get.toNamed('/AddAgent'),
      // ),
      body: BaseAppHeader(
        headerLength: 100,
        title: Text(
          controller.isSpecificAgent ? 'وكيل بلدك' : "agents".tr,
          style: Get.textTheme.bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Get.back();
            },
          ),
        ],
        refresh: () async {
          controller.agents.clear();
          controller.loading(true);
          if (controller.isSpecificAgent) {
            await controller.getSpecificAgent();
          } else {
            await controller.getAllAgents();
          }
        },
        children: [
          Obx(() => controller.loading.value
              ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return AppMessageLoader();
                  }, childCount: 20)))
              : SliverList(
                  delegate: SliverChildListDelegate([
                    if (controller.agents.isNotEmpty) ...[
                      AgentBox(
                        controller.appController,
                        controller.agents.first,
                        controller,
                      ),
                      SizedBox(
                        height: 540,
                        child: PageView.builder(
                          itemCount:
                              controller.agents.first.agentPackages.length,
                          itemBuilder: (context, index) => packagesOption(
                            isMan: controller.appController.isMan,
                            image: controller
                                .agents.first.agentPackages[index].image
                                .toString(),
                            onPress: () {},
                            title: controller
                                    .agents.first.agentPackages[index].title ??
                                '',
                          ),
                        ),
                      )
                    ]
                  ]),
                ))
        ],
      ),
    );
  }
}
