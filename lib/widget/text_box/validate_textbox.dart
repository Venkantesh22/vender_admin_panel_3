import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

TextFormField validateTextBox({
  int? maxLin = 1,
  required String? hintText,
  required TextEditingController controller,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
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
    ),
    validator: validator,
  );
}
