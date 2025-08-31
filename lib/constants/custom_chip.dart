import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class CustomChip extends StatefulWidget {
  final String text;
  const CustomChip({
    super.key,
    required this.text,
  });

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.dimensionNo40,
      child: Chip(
        labelPadding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo10),
        backgroundColor: const Color.fromARGB(255, 184, 182, 182),
        label: Text(
          widget.text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.dimensionNo12,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
