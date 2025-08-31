import 'package:flutter/material.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class userInfoColumn extends StatelessWidget {
  final String title;
  final String infoText;

  const userInfoColumn(
      {super.key, required this.title, required this.infoText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              // color: Colors.black.withOpacity(0.699999988079071),
              fontSize: Dimensions.dimensionNo15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: Dimensions.dimensionNo5,
                left: Dimensions.dimensionNo5,
                bottom: Dimensions.dimensionNo10),
            child: Text(
              infoText,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: const Color(0xFF1F1616),
                fontSize: Dimensions.dimensionNo14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.90,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
