import 'package:flutter/material.dart';

//The custom square button from the menu
class CustomMenuButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  const CustomMenuButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(
            widget.icon,
            color: Colors.white,
            size: 40,
          ),
          label: Text(" " + widget.label, style: const TextStyle(fontSize: 25), textAlign: TextAlign.center),
          style: ElevatedButton.styleFrom(
            primary: widget.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            fixedSize: const Size(300, 120),
          )
    );
  }
}
