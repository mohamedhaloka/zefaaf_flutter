import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListSelectMultiItemLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Expanded(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                  highlightColor:
                      lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: lightMode ? Colors.white : Colors.grey[500],
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Shimmer.fromColors(
                  baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                  highlightColor:
                      lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                  child: Container(
                    width: 36,
                    height: 26,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: lightMode ? Colors.white : Colors.grey[500]),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Shimmer.fromColors(
                  baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                  highlightColor:
                      lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                  child: Container(
                    width: 88,
                    height: 14,
                    decoration: BoxDecoration(
                        color: lightMode ? Colors.white : Colors.grey[500]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
