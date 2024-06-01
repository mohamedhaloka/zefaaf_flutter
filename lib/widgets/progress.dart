import 'package:flutter/material.dart';

circularMainProgress(BuildContext context, {Color? color}) {
  return Center(
    child: LinearProgressIndicator(
      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation(
        color ?? Theme.of(context).colorScheme.secondary,
      ),
    ),
  );
}

circularDefaultProgress(BuildContext context, {Color? color}) {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation(
        color ?? Theme.of(context).colorScheme.secondary,
      ),
    ),
  );
}

linearProgress() {
  return const LinearProgressIndicator(
    valueColor: AlwaysStoppedAnimation(
      Colors.black54,
    ),
  );
}
