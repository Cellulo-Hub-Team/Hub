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
      leading: Row(children: [
        IconButton(
          icon: Icon(widget.leadingIcon),
          onPressed: () => Common.goToTarget(context, widget.leadingTarget, false, widget.leadingScreen),
        ),
        SizedBox(width: 15),
        Text(widget.leadingName, style: TextStyle(color: Colors.white, fontSize: 20))
      ]),
      leadingWidth: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: widget.hasFloating
          ? CustomIconButton(
          label: widget.floatingLabel ?? "Close",
          icon: widget.floatingIcon ?? Icons.close,
          color: Colors.white,
          onPressed: widget.onPressedFloating)
       : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: widget.body,
    );
  }
}
