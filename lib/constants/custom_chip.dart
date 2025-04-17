import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class CustomChip extends StatefulWidget {
  final String text;
  const CustomChip({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.dimenisonNo40,
      child: Chip(
        labelPadding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo10),
        backgroundColor: const Color.fromARGB(255, 184, 182, 182),
        label: Text(
          widget.text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.dimenisonNo12,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
