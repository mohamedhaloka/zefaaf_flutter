import 'package:flutter/material.dart';

class NoInternetChecker extends StatelessWidget {
  const NoInternetChecker({super.key});

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return SliverFillRemaining(
      child: Center(
        child: Image.asset(
          "assets/images/no-internet.png",
          width: 100,
          height: 100,
          color: lightMode ? null : Colors.grey[200],
        ),
      ),
    );
  }
}
