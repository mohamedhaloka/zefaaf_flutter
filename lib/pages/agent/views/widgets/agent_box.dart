import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/agent/controllers/agent_controller.dart';

import '../../models/agent_modle.dart';

class AgentBox extends StatelessWidget {
  AgentBox(this.appController, this.agent, this.c);
  AppController appController;
  AgentModel agent;
  AgentController c;
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: lightMode ? Colors.grey[100] : Colors.grey[800],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    image(
                        'agent',
                        4.0,
                        appController.isMan.value == 0
                            ? Get.theme.primaryColor
                            : Get.theme.colorScheme.secondary),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        agent.name.toString(),
                        style: Get.textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: appController.isMan.value == 0
                                ? Get.theme.primaryColor
                                : Get.theme.colorScheme.secondary,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              if ((agent.countryName ?? '').isNotEmpty) ...[
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      image(
                          'place',
                          5.0,
                          appController.isMan.value == 0
                              ? Get.theme.primaryColor
                              : Get.theme.colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        agent.countryName.toString(),
                        style: Get.textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildIcon(
                  title: agent.email.toString(),
                  icon: 'mail',
                  mode: lightMode,
                  size: 4.5,
                  flex: 7,
                  onTap: () {
                    return launchUrl(Uri.parse('mailto:${agent.email}'));
                  }),
              const SizedBox(width: 12),
              _buildIcon(
                  title: agent.mobile.toString(),
                  icon: 'phone',
                  mode: lightMode,
                  flex: 5,
                  onTap: () async =>
                      await launchUrl(Uri.parse('tel:${agent.mobile}'))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildIcon(
                  title: agent.whats.toString(),
                  icon: 'whats',
                  mode: lightMode,
                  color: Colors.green,
                  flex: 7,
                  onTap: () async =>
                      await c.launchWhatsAppUri(agent.whats.toString(), "")),
              if ((agent.localValue ?? '').isNotEmpty) ...[
                const SizedBox(width: 20),
                _buildIcon(
                    title: agent.localValue.toString(),
                    icon: 'money',
                    mode: lightMode,
                    flex: 5,
                    onTap: null),
              ],
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIcon({icon, title, size, onTap, mode, flex, Color? color}) =>
      Expanded(
        flex: flex,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              image(
                  icon,
                  size ?? 6.0,
                  color ??
                      (c.appController.isMan.value == 0
                          ? Get.theme.primaryColor
                          : Get.theme.colorScheme.secondary)),
              const SizedBox(
                width: 12,
              ),
              Expanded(child: Text(title))
            ],
          ),
        ),
      );

  Widget image(imgName, scale, Color color) => Image.asset(
        'assets/images/agents/$imgName.png',
        scale: scale,
        color: color,
      );
}
