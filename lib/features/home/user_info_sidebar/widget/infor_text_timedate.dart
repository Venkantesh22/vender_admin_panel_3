import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class UserInfoDateTimeColumn extends StatelessWidget {
  final String title;
  final DateTime time;
  final bool isTime;
  final DateTime? serviceStartTime;
  final DateTime? serviceEndTime;

  UserInfoDateTimeColumn({
    super.key,
    required this.title,
    required this.time,
    required this.isTime,
    this.serviceStartTime,
    this.serviceEndTime,
  });

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
              child: isTime
                  ? Text(
                      "${DateFormat('hh:mm a').format(serviceStartTime!)} To ${DateFormat('hh:mm a').format(serviceEndTime!)}",
                      style: TextStyle(
                        color: Color(0xFF1F1616),
                        fontSize: Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.90,
                      ),
                    )
                  : Text(
                      DateFormat('dd MMM yyyy').format(time),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                      ),
                    )),
        ],
      ),
    );
  }
}
