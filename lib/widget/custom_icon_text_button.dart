import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class CustomIconTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final IconData iconData; // Make the icon a required parameter

  const CustomIconTextButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.buttonColor,
    this.textColor = Colors.white,
    required this.iconData, // Make the icon required
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.dimensionNo36,
      width: Dimensions.dimensionNo200,
      child: ElevatedButton(
        onPressed: onTap,
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
        child: Row(
          // Wrap the Text and Icon with a Row
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: Dimensions.dimensionNo16,
              color: const Color(0xFF08BA85),
            ), // Display the icon
            SizedBox(
              width: Dimensions.dimensionNo5,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                // color: Colors.black,
                fontSize: Dimensions.dimensionNo16,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
