import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samay_admin_plan/utility/dimension.dart';

class Appbaritem extends StatelessWidget {
  final String text;

  final VoidCallback ontap;

  const Appbaritem({
    Key? key,
    required this.text,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.dimensionNo16,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
