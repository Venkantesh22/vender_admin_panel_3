import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samay_admin_plan/utility/dimenison.dart';

class SalonSocialMediaAdd extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextEditingController controller;

  SalonSocialMediaAdd({
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
        size: Dimensions.dimenisonNo24,
      ),
      title: SizedBox(
        height: Dimensions.dimenisonNo24,
        child: TextFormField(
          cursorHeight: Dimensions.dimenisonNo16,
          style: TextStyle(fontSize: Dimensions.dimenisonNo12),
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $text account link",
            hintStyle: TextStyle(
              fontSize: Dimensions.dimenisonNo12,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
            ),
          ),
        ),
      ),
    );
  }
}
