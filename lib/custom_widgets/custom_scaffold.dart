import 'package:flutter/material.dart';

import 'custom_colors.dart';


//The base scaffold for each screen with custom app bar and floating app bar button
class CustomScaffold extends StatefulWidget {
  final String name;
  final Widget body;
  final IconData leading;
  final bool hasFloating;
  final IconData? floating;
  final VoidCallback? onPressedFloating;
  const CustomScaffold(
      {Key? key,
      required this.name,
      required this.leading,
      required this.hasFloating,
      this.floating,
      this.onPressedFloating,
      required this.body})
      : super(key: key);

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  //The app bar with custom leading button and title
  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: CustomColors.currentColor,
      title: Text(widget.name),
      leading: IconButton(
        icon: Icon(widget.leading),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: widget.hasFloating ? FloatingActionButton(
        onPressed: widget.onPressedFloating,
        child: Icon(widget.floating),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: widget.body,
    );
  }
}
