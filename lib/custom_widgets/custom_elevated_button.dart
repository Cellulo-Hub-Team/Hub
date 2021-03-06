import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomElevatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  const CustomElevatedButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: Text(widget.label),
      style: ElevatedButton.styleFrom(
        primary: CustomColors.currentColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
