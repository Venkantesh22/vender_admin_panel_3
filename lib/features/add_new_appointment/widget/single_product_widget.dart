import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/custom_button.dart';

Widget singleProductName(
    {required ProductModel product,
    required BookingProvider bookingProvider,
    required BuildContext context,
    required Function() ontap}) {
  return Container(
    margin: EdgeInsets.only(
      left: Dimensions.dimensionNo16,
      right: Dimensions.dimensionNo16,
      top: Dimensions.dimensionNo10,
    ),
    padding: EdgeInsets.symmetric(
      vertical: Dimensions.dimensionNo8,
      horizontal: Dimensions.dimensionNo10,
    ),
    decoration: BoxDecoration(
      border: Border.all(width: 1.5),
      borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: Dimensions.dimensionNo36,
          width: Dimensions.dimensionNo60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo8),
          ),
          clipBehavior: Clip.antiAlias,
          child: product.imgUrl != null && product.imgUrl.isNotEmpty
              ? Image.network(
                  product.imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: Dimensions.dimensionNo36,
                  ),
                )
              : Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: Dimensions.dimensionNo36,
                ),
        ),
        SizedBox(
          width: Dimensions.dimensionNo10,
        ),
        Expanded(
          child: Text(
            product.name,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: const Color(0xFF0F1416),
              fontSize: Dimensions.dimensionNo14,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
        CustomButton(
          buttonColor: bookingProvider.getSelectBuyProductList.contains(product)
              ? Colors.red
              : AppColor.buttonColor,
          ontap: ontap,
          text: bookingProvider.getSelectBuyProductList.contains(product)
              ? "Remove -"
              : "Add+",
          width: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimensionNo100
              : Dimensions.dimensionNo120,
        ),
      ],
    ),
  );
}
