import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

///
class SliverGridShimmer extends StatefulWidget {
  ///
  const SliverGridShimmer({
    Key? key,
    required this.size,
  }) : super(key: key);

  ///
  final ResponsiveLayoutSize size;

  @override
  State<SliverGridShimmer> createState() => _MasonryPageState();
}

class _MasonryPageState extends State<SliverGridShimmer> {
  final rnd = Random();
  late List<int> extents;

  @override
  void initState() {
    super.initState();
    extents = List<int>.generate(100, (int index) => rnd.nextInt(5) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: widget.size.gridCrossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childCount: extents.length,
        itemBuilder: (context, index) {
          final height = extents[index] * 70.0;
          return SizedBox(
            width: 100,
            height: height,
            child: const GifShimmer(),
          );
        },
      ),
    );
  }
}
