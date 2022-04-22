import 'package:flutter/material.dart';

import '../custom.dart';

class CustomElevatedButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String label;
  final void Function()? onPressed;
  const CustomElevatedButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(
            widget.icon,
            color: Colors.white,
            size: 30,
          ),
          label: Text(" " + widget.label, style: const TextStyle(fontSize: 25)),
          style: ElevatedButton.styleFrom(
            primary: widget.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            fixedSize: const Size(300, 120),
          )
    );
  }
}
