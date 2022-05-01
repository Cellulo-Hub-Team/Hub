import 'package:cellulo_hub/custom_widgets/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomDelegate extends SliverPersistentHeaderDelegate{
  CustomDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: CustomColors.inversedDarkThemeColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}