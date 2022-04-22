import 'package:flutter/material.dart';

import 'common.dart';
import 'custom_colors.dart';

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.redColor.shade900;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
