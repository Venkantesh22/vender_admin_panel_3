import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

SizedBox selectAppointDateTextBoxWidget({
  required TextEditingController appointmentDateController,
  required bool showCalender,
  required Function()? onTap,
  required BuildContext context,
}) {
  return SizedBox(
    // height: Dimensions.dimensionNo70,
    width:
        ResponsiveLayout.isMobile(context) ? null : Dimensions.dimensionNo250,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Appointment Date",
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimensionNo14
                : Dimensions.dimensionNo18,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.90,
          ),
        ),
        SizedBox(
          height: Dimensions.dimensionNo5,
        ),
        Padding(
          padding:
              EdgeInsetsGeometry.symmetric(vertical: Dimensions.dimensionNo8),
          child: TextFormField(
            onTap: onTap,
            readOnly: true,
            cursorHeight: Dimensions.dimensionNo16,
            style: TextStyle(
                fontSize: Dimensions.dimensionNo12,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            controller: appointmentDateController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Dimensions.dimensionNo10,
                  vertical: Dimensions.dimensionNo10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
