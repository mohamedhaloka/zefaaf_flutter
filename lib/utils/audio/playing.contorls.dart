import 'package:flutter/material.dart';

class PlayingControls extends StatelessWidget {
  final bool isPlaylist;
  final int index;
  final List<IconData> iconStatue;
  final Function() onPrevious;
  final Function() onPlay;

  const PlayingControls({
    this.isPlaylist = false,
    required this.onPrevious,
    required this.index,
    required this.iconStatue,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: InkWell(
        onTap: onPlay,
        child: Icon(
          iconStatue[index],
          color: Colors.black,
          size: 25,
        ),
      ),
    );
  }
}
