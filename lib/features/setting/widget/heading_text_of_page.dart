import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

Text headingTextOFPage(BuildContext context, String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.black,
      fontSize: ResponsiveLayout.isMobile(context)
          ? Dimensions.dimenisonNo28
          : Dimensions.dimenisonNo36,
      fontWeight: FontWeight.w500,
    ),
  );
}
