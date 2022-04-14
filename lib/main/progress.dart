import 'package:flutter/material.dart';

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
        appBar: AppBar( //TODO Generalize app bar
          centerTitle: true,
          backgroundColor: CustomColors.currentColor,
          title: const Text('Progress'),
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Align(child: Text("Progress")));
  }
}
