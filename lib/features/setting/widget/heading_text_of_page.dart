import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

Text headingTextOFPage(BuildContext context, String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.black,
      fontSize: ResponsiveLayout.isMobile(context)
          ? Dimensions.dimensionNo28
          : Dimensions.dimensionNo36,
      fontWeight: FontWeight.w500,
    ),
  );
}
