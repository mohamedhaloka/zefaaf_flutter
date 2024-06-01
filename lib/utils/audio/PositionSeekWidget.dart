import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;
  final Color? sliderColor, buttonColor;
  final String recordTime;

  const PositionSeekWidget({
    required this.currentPosition,
    required this.recordTime,
    this.sliderColor,
    this.buttonColor,
    required this.duration,
    required this.seekTo,
  });

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 115,
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 20,
            child: Slider(
              min: 0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: (percent * widget.duration.inMilliseconds.toDouble() >
                      widget.duration.inMilliseconds.toDouble())
                  ? 0.0
                  : (percent * widget.duration.inMilliseconds.toDouble()),
              activeColor:
                  widget.buttonColor ?? Get.theme.scaffoldBackgroundColor,
              inactiveColor: widget.sliderColor ?? Colors.grey[300],
              onChangeEnd: (newValue) {
                log('onChangeEnd  $newValue');
                setState(() {
                  listenOnlyUserInterraction = false;
                  widget.seekTo(Duration(milliseconds: newValue.floor()));
                });
              },
              onChangeStart: (_) => _,
              onChanged: (_) => _,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  durationToString(widget.currentPosition),
                  style: Get.theme.textTheme.bodyText1!.copyWith(
                      fontSize: 8, color: Get.theme.scaffoldBackgroundColor),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  durationToString(widget.duration) == "00:00"
                      ? widget.recordTime
                      : durationToString(widget.duration),
                  style: Get.theme.textTheme.bodyText1!.copyWith(
                      fontSize: 8, color: Get.theme.scaffoldBackgroundColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  String twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
