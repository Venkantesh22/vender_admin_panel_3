// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomIconButton extends StatelessWidget {
  IconData? icon;
  VoidCallback? ontap;
  final double iconSize;

  CustomIconButton({
    super.key,
    this.icon,
    this.ontap,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(
        icon,
        size: iconSize,
        color: Colors.black,
      ), // Replace with Instagram icon
      onPressed: ontap,
    );
  }
}
