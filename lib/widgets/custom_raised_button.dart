import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/progress.dart';

class CustomRaisedButton extends StatefulWidget {
  CustomRaisedButton(
      {this.tittle,
      @required this.onPress,
      this.loading,
      this.color,
      this.child,
      this.isChild = false,
      this.padding,
      this.width,
      this.fontSize,
      this.height = 54});

  double? padding;
  final Function()? onPress;
  final Widget? child;
  final double? fontSize;
  final String? tittle;
  final Color? color;
  final double? height, width;
  final bool? loading;
  final bool? isChild;
  @override
  _CustomRaisedButtonState createState() => _CustomRaisedButtonState();
}

class _CustomRaisedButtonState extends State<CustomRaisedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        onPressed: widget.loading == true ? null : widget.onPress,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          padding: EdgeInsets.all(widget.padding ?? 0),
          backgroundColor: widget.color ?? Colors.blue[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.height! / 6)),
        ),
        child: Center(
          child: widget.loading == true
              ? circularDefaultProgress(context,
                  color: Get.find<AppController>().isMan.value == 0
                      ? Get.theme.colorScheme.secondary
                      : Get.theme.primaryColor)
              : (widget.isChild ?? false)
                  ? widget.child
                  : Text(
                      "${widget.tittle}",
                      textAlign: TextAlign.center,
                      style: widget.fontSize == null
                          ? Get.textTheme.bodyText2!
                              .copyWith(color: AppTheme.WHITE)
                          : Get.textTheme.bodyText2!.copyWith(
                              color: AppTheme.WHITE, fontSize: widget.fontSize),
                    ),
        ),
      ),
    );
  }
}
