import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

Widget validateTextBoxWithHeading(
    {int? maxLin = 1,
    required String? hintText,
    required String labelText,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    Widget? suffixWidget}) {
  return Padding(
    padding: EdgeInsets.only(bottom: Dimensions.dimensionNo8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsetsGeometry.symmetric(vertical: Dimensions.dimensionNo8),
          child: Text(
            labelText,
            style: TextStyle(
              color: const Color(0xFF0F1419),
              fontSize: Dimensions.dimensionNo16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
        TextFormField(
          maxLines: maxLin,
          controller: controller,
          style: TextStyle(
              fontSize: Dimensions.dimensionNo12,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          cursorHeight: Dimensions.dimensionNo16,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: Dimensions.dimensionNo12,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w200,
                color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimensionNo10,
                vertical: Dimensions.dimensionNo10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
            ),
            suffixIcon: suffixWidget != null ? suffixWidget : null,
          ),
          validator: validator,
        ),
      ],
    ),
  );
}
