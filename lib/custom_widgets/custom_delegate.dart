import 'package:cellulo_hub/custom_widgets/custom_colors.dart';
import 'package:flutter/material.dart';

import '../main/common.dart';

class CustomDelegate extends SliverPersistentHeaderDelegate{
  CustomDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Common.darkTheme ? CustomColors.blackColor.shade900 : Colors.white,
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