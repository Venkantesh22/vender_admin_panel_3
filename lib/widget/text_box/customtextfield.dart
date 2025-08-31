// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';

import 'package:samay_admin_plan/utility/dimension.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  bool obscureForPassword = false;
  final TextInputType? keyboardType;
  int? maxline;

  final String label;
  CustomTextField({
    super.key,
    required this.controller,
    required this.obscureForPassword,
    this.keyboardType,
    this.maxline = 1,
    required this.label,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxline,
      cursorHeight: Dimensions.dimensionNo16,
      obscureText: widget.obscureForPassword,
      style: const TextStyle(fontSize: 12),
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixIcon: widget.label == "Password"
            ? InkWell(
                onTap: () {
                  setState(() {
                    widget.obscureForPassword = !widget.obscureForPassword;
                  });
                },
                child: Icon(widget.obscureForPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
              )
            : null,
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your ${widget.label}';
        }
        return null;
      },
    );
  }
}

// Text field for Profile form
class FormCustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool requiredField;
  final bool readOnly;
  int? maxline;
  final String title;
  final String? hintText;

  FormCustomTextField({
    super.key,
    required this.controller,
    this.requiredField = true,
    this.maxline,
    required this.title,
    this.readOnly = false,
    this.hintText,
  });

  @override
  State<FormCustomTextField> createState() => _FormCustomTextFieldState();
}

class _FormCustomTextFieldState extends State<FormCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo14
                      : Dimensions.dimensionNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  // letterSpacing: 0.90,
                ),
              ),
              if (widget.requiredField)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: const Color(0xFFFC0000),
                    fontSize: Dimensions.dimensionNo18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    // letterSpacing: 0.90,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: Dimensions.dimensionNo5,
        ),
        SizedBox(
          //salon description textbox has. max line.

          height: widget.maxline == null
              ? ResponsiveLayout.isDesktop(context)
                  ? Dimensions.dimensionNo30
                  : Dimensions.dimensionNo40
              : null,
          child: TextFormField(
            readOnly: widget.readOnly,
            maxLines: widget.maxline ?? 1,
            cursorHeight: Dimensions.dimensionNo16,
            style: TextStyle(
                fontSize: Dimensions.dimensionNo12,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
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
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Enter your ${widget.title}';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
