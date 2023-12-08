import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverGridDelegateWithCustomCrossAxisCount extends SliverGridDelegate {
  final int crossAxisCount;
  final int specialItemCount; // Number of special containers
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  SliverGridDelegateWithCustomCrossAxisCount({
    required this.crossAxisCount,
    required this.specialItemCount,
    required this.childAspectRatio,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double usableCrossAxisExtent =
        constraints.crossAxisExtent - (crossAxisSpacing * (crossAxisCount - 1));
    final double childWidth =
        (usableCrossAxisExtent - (crossAxisSpacing * specialItemCount)) /
            crossAxisCount;
    final double childHeight = childWidth / childAspectRatio;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childHeight + mainAxisSpacing,
      crossAxisStride: childWidth + crossAxisSpacing,
      childMainAxisExtent: childHeight,
      childCrossAxisExtent: childWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    return false;
  }
}