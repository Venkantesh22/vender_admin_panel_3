import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class CustomButtom extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final Color buttonColor;
  final Color textColor;
  double? width;

  CustomButtom({
    Key? key,
    required this.text,
    required this.ontap,
    required this.buttonColor,
    this.textColor = Colors.white,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.dimensionNo36,
      width: width ?? Dimensions.dimensionNo200,
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsetsDirectional.symmetric(
              horizontal: Dimensions.dimensionNo10),
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          // Text color
          side: const BorderSide(
            width: 1.5,
            // color: Colors.black,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            // color: Colors.black,
            fontSize: ResponsiveLayout.isMoAndTab(context)
                ? Dimensions.dimensionNo12
                : Dimensions.dimensionNo16,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
        ),
      ),
    );
  }
}
