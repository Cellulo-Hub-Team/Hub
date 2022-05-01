import 'package:flutter/material.dart';

//The custom rounded icon button
class CustomIconButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  const CustomIconButton({Key? key, required this.label, required this.icon, required this.color, required this.onPressed}) : super(key: key);

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      icon: Icon(
        widget.icon,
        color: widget.color == Colors.white ? Colors.grey.shade900 : Colors.white,
      ),
      label: Text(widget.label, style: TextStyle(fontSize: 15, color: widget.color == Colors.white ? Colors.grey.shade900 : Colors.white)),
      style: ElevatedButton.styleFrom(
          primary: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          fixedSize: const Size(140, 40)),
    );
  }
}
