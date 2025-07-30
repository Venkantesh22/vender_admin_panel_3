import 'package:flutter/material.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:badges/badges.dart' as badges;
import 'package:samay_admin_plan/utility/dimension.dart';

Widget? _buildFloatingActionButton(BookingProvider bookingProvider) {
  if (bookingProvider.getWatchList.isEmpty) return null;

  return badges.Badge(
    badgeContent: Text(
      bookingProvider.getWatchList.length.toString(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    badgeStyle: const badges.BadgeStyle(
      badgeColor: AppColor.buttonColor,
      elevation: 10,
    ),
    child: GestureDetector(
      onTap: () {},
      child: Icon(Icons.watch_later_rounded, size: Dimensions.dimensionNo40),
    ),
  );
}
