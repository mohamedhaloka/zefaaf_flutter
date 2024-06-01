import 'package:flutter/material.dart';

class PageViewContent extends StatelessWidget {
  PageViewContent({required this.index});

  int index;

  List<String> tittle = [
    "إبحث عن شريك حياتك بأخلاق إسلامية",
    "سجل بياناتك بكل سهولة وسرية",
    "إرتباط أبدي لحياة سعيدة وهنية",
  ];
  @override
  Widget build(BuildContext context) {
    return index == 3
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/onboarding/${index + 1}.png",
                width: 280,
              ),
              Text(
                tittle[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black),
              ),
            ],
          );
  }
}
