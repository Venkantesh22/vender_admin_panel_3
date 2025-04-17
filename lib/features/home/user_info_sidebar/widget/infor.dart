import 'package:flutter/material.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class userInfoColumn extends StatelessWidget {
  final String title;
  final String infoText;

  const userInfoColumn(
      {super.key, required this.title, required this.infoText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              // color: Colors.black.withOpacity(0.699999988079071),
              fontSize: Dimensions.dimenisonNo15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: Dimensions.dimenisonNo5,
                left: Dimensions.dimenisonNo5,
                bottom: Dimensions.dimenisonNo10),
            child: Text(
              infoText,
              style: TextStyle(
                color: Color(0xFF1F1616),
                fontSize: Dimensions.dimenisonNo14,
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
