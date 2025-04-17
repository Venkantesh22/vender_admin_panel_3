// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';

import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class CustomAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  Color? bgColor;
  double? buttonWidth;
  CustomAuthButton({
    super.key,
    required this.text,
    required this.ontap,
    this.bgColor = AppColor.bgForAuth,
    this.buttonWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: ResponsiveLayout.isMoAndTab(context)
                ? Dimensions.dimenisonNo12
                : Dimensions.dimenisonNo20),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo30)),
        height: Dimensions.dimenisonNo40,
        width: buttonWidth,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveLayout.isMoAndTab(context)
                  ? Dimensions.dimenisonNo12
                  : Dimensions.dimenisonNo16,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.25,
            ),
          ),
        ),
      ),
    );
  }
}
