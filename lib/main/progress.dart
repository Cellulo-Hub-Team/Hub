import 'package:flutter/material.dart';

import 'custom.dart';
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
    return Scaffold(
        appBar: Custom.appBar(context, "Progress", Icon(Icons.home)),
        body: const Align(child: Text("Progress")));
  }
}
