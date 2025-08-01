import 'package:flutter/material.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:badges/badges.dart' as badges;
import 'package:samay_admin_plan/utility/dimension.dart';

Widget badgeFloatingActionButton(BookingProvider bookingProvider) {
  if (bookingProvider.budgetProductList.isEmpty) return const SizedBox();

  return badges.Badge(
    badgeContent: Text(
      bookingProvider.budgetProductList.length.toString(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    badgeStyle: const badges.BadgeStyle(
      badgeColor: AppColor.buttonColor,
      elevation: 10,
    ),
    child: GestureDetector(
      onTap: () {},
      child: Icon(Icons.shopping_cart, size: Dimensions.dimensionNo22),
    ),
  );
}
