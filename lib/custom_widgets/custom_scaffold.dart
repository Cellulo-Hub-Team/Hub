import 'package:cellulo_hub/custom_widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

import '../main/common.dart';
import 'custom_colors.dart';

//The base scaffold for each screen with custom app bar and floating app bar button
class CustomScaffold extends StatefulWidget {
  final String name;
  final Widget body;
  final IconData leadingIcon;
  final String leadingName;
  final Activity leadingScreen;
  final Widget leadingTarget;
  final bool hasFloating;
  final IconData? floatingIcon;
  final String? floatingLabel;
  final VoidCallback? onPressedFloating;
  final Widget? drawer;
  const CustomScaffold(
      {Key? key,
      required this.name,
      required this.leadingIcon,
      required this.leadingName,
      required this.leadingScreen,
      required this.leadingTarget,
      required this.hasFloating,
      this.floatingIcon,
      this.floatingLabel,
      this.onPressedFloating,
      this.drawer,
      required this.body})
      : super(key: key);

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  //The app bar with custom leading button and title
  AppBar _appBar() {
    return AppBar(
      /*actions: [
        Builder(
          builder: (context) => Container(),
        ),
      ],*/
      centerTitle: true,
      backgroundColor: CustomColors.currentColor,
      title: Text(widget.name),
      leading: Row(children: [
        TextButton.icon(
            onPressed: () => Common.goToTarget(
                context, widget.leadingTarget, false, widget.leadingScreen),
            icon: Icon(widget.leadingIcon, color: Colors.white),
            label: Text(
              widget.leadingName,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ))
      ]),
      leadingWidth: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: widget.hasFloating
          ? Builder(
      builder: (context) => CustomIconButton(
              label: widget.floatingLabel ?? "Close",
              icon: widget.floatingIcon ?? Icons.close,
              color: Colors.white,
              onPressed: () {
                widget.onPressedFloating!();
                if (widget.drawer != null){
                  Scaffold.of(context).openEndDrawer();
                }
              }
              //onPressed: widget.onPressedFloating
          ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      endDrawer: widget.drawer,
      body: widget.body,
    );
  }
}
