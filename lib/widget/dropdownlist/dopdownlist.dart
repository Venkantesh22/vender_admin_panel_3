import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

Padding dropDownList({
  required String heading,
  required String? value,
  required String labelText,
  required List<String> valueList,
  required String? Function(String?)? validator,
  required void Function(dynamic) onChanged, // <-- add this
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: Dimensions.dimensionNo8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
          child: Text(
            heading,
            style: TextStyle(
              color: const Color(0xFF0F1419),
              fontSize: Dimensions.dimensionNo16,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
        SizedBox(
          width: Dimensions.dimensionNo500,
          child: DropdownButtonFormField<String>(
            hint: Text(
              labelText,
              style: TextStyle(
                color: Colors.grey,
                fontSize: Dimensions.dimensionNo12,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.40,
              ),
            ),
            value: value,
            items: valueList.map((String value) {
              return DropdownMenuItem<String>(
                value: value, // <-- assuming value has a 'name' property
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged, // <-- use the callback
            validator: validator,
          ),
        ),
      ],
    ),
  );
}
