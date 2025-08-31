import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samay_admin_plan/utility/dimension.dart';

class SalonSocialMediaAdd extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextEditingController controller;

  const SalonSocialMediaAdd({
    super.key,
    required this.text,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(
        icon,
        color: Colors.black,
        size: Dimensions.dimensionNo24,
      ),
      title: SizedBox(
        height: Dimensions.dimensionNo24,
        child: TextFormField(
          cursorHeight: Dimensions.dimensionNo16,
          style: TextStyle(fontSize: Dimensions.dimensionNo12),
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $text account link",
            hintStyle: TextStyle(
              fontSize: Dimensions.dimensionNo12,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimensionNo10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
            ),
          ),
        ),
      ),
    );
  }
}
