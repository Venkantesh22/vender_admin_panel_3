import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class CustomText extends StatelessWidget {
  final String firstText;
  final String lastText;
  final bool showicon;
  IconData? icon;

  CustomText({
    Key? key,
    required this.firstText,
    required this.lastText,
    this.showicon = false,
    this.icon = Icons.currency_rupee_rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.only(
              left: Dimensions.dimensionNo10,
              right: Dimensions.dimensionNo10,
              top: Dimensions.dimensionNo5)
          : EdgeInsets.only(
              left: Dimensions.dimensionNo20,
              right: Dimensions.dimensionNo20,
              top: Dimensions.dimensionNo5),
      child: Row(
        children: [
          Text(
            firstText,
            style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo12
                  : Dimensions.dimensionNo15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.80,
            ),
          ),
          Spacer(),
          if (showicon)
            Icon(icon, size: Dimensions.dimensionNo18, color: Colors.black),
          Text(
            lastText,
            style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo12
                  : Dimensions.dimensionNo15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.80,
            ),
          ),
        ],
      ),
    );
  }
}
