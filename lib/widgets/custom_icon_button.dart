import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/theme.dart';

class CustomRaisedIconButton extends StatefulWidget {
  const CustomRaisedIconButton(
      {required this.tittle,
      required this.onPress,
      this.color,
      this.icon,
      this.asset,
      this.fontSize = 14,
      this.height = 54});

  final Function()? onPress;
  final double fontSize;
  final String tittle;
  final String? asset;
  final Color? color;
  final IconData? icon;
  final double height;
  @override
  _CustomRaisedIconButtonState createState() => _CustomRaisedIconButtonState();
}

class _CustomRaisedIconButtonState extends State<CustomRaisedIconButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPress,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          padding: const EdgeInsets.all(0),
          backgroundColor: widget.color ?? Colors.blue[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.height / 6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.asset == null
                ? Icon(
                    widget.icon,
                    color: AppTheme.WHITE,
                  )
                : SvgPicture.asset(
                    widget.asset ?? '',
                    color: AppTheme.WHITE,
                  ),
            const SizedBox(width: 20),
            Text(
              widget.tittle,
              style: Get.textTheme.bodyText2!
                  .copyWith(color: AppTheme.WHITE, fontSize: widget.fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
