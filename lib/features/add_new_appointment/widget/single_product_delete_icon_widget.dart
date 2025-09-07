import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

//? Select Product List
Widget selectProductLists(BuildContext context) {
  return Consumer<BookingProvider>(
    builder: (context, bookingProvider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Products List",
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo14
                  : Dimensions.dimensionNo18,
              fontWeight: ResponsiveLayout.isMobile(context)
                  ? FontWeight.bold
                  : FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.dimensionNo8),
          Padding(
            padding: ResponsiveLayout.isMobile(context)
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo12),
            child: Wrap(
              spacing: Dimensions.dimensionNo12,
              runSpacing: Dimensions.dimensionNo12,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.start,
              children: List.generate(
                bookingProvider.budgetProductQuantityMap.length,
                (index) {
                  final entry = bookingProvider.budgetProductQuantityMap.entries
                      .elementAt(index);
                  final product = entry.key;

                  return SizedBox(
                    width: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo300
                        : Dimensions.dimensionNo400,
                    child: singleProductNameDeleteIcon(
                      product: product,
                      context: context,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      );
    },
  );
}

Widget singleProductNameDeleteIcon({
  required ProductModel product,
  required BuildContext context,
}) {
  // Determine if the screen is mobile
  bool isMobile = MediaQuery.of(context).size.width < 600;

  return Consumer<BookingProvider>(builder: (context, bookingProvider, child) {
    int quantity = bookingProvider.budgetProductQuantityMap[product] ?? 0;
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.dimensionNo12),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.dimensionNo5,
        horizontal: Dimensions.dimensionNo12,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.dimensionNo12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '▪️ ${product.name}',
                        style: TextStyle(
                          overflow: TextOverflow.clip,
                          color: Colors.black,
                          fontSize: isMobile
                              ? Dimensions.dimensionNo12
                              : Dimensions.dimensionNo14,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      rowPricesProduct(context: context, productModel: product),
                    ],
                  ),
                ),
                Container(
                  width: Dimensions.dimensionNo60,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.dimensionNo8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: product.imgUrl.isNotEmpty
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
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
                  child: Text(
                    product.brandName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimensionNo12
                          : Dimensions.dimensionNo18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              quantAddRemoveWidget(quantity, bookingProvider, product, context),
              IconButton(
                onPressed: () {
                  bookingProvider.removeProductToListPro(product,
                      isRemoveAll: true);
                },
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo8),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: isMobile
                      ? Dimensions.dimensionNo24
                      : Dimensions.dimensionNo30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });
}

Widget singleProductNameWithIncrOrDecrIcon({
  required ProductModel product,
  required BuildContext context,
  bool showProductWithQty = false,
  int productQty = 0,
}) {
  // Determine if the screen is mobile
  bool isMobile = MediaQuery.of(context).size.width < 600;

  return Consumer<BookingProvider>(builder: (context, bookingProvider, child) {
    int quantity = bookingProvider.budgetProductQuantityMap.entries
        .firstWhere(
          (entry) => entry.key.id == product.id,
          orElse: () => MapEntry(product, 0),
        )
        .value;
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.dimensionNo12),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.dimensionNo5,
        horizontal: Dimensions.dimensionNo12,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.dimensionNo12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '▪️ ${product.name}',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isMobile
                              ? Dimensions.dimensionNo12
                              : Dimensions.dimensionNo14,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.dimensionNo8),
                        child: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.indianRupeeSign,
                                size: Dimensions.dimensionNo14),
                            Text(
                              " ${product.originalPrice.toString()}",
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: const Color(0xFF0F1416),
                                fontSize: Dimensions.dimensionNo14,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Dimensions.dimensionNo60,
                  padding: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.dimensionNo8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: product.imgUrl.isNotEmpty
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
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
                  child: Text(
                    product.brandName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimensionNo10
                          : Dimensions.dimensionNo14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              showProductWithQty
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimensionNo12,
                          vertical: Dimensions.dimensionNo8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Qty : ${productQty.toString()}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  : quantAddRemoveWidget(
                      quantity, bookingProvider, product, context)
            ],
          ),
        ],
      ),
    );
  });
}

Container quantAddRemoveWidget(
  int quantity,
  BookingProvider bookingProvider,
  ProductModel product,
  BuildContext context,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    padding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimensionNo12,
        vertical: Dimensions.dimensionNo8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Quantity Controls
        Row(
          children: [
            // Minus button
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
              ),
              onPressed: () {
                if (quantity > 0) {
                  bookingProvider.removeProductToListPro(product);
                }
              },
            ),

            // Quantity number
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                quantity.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // Plus button
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                if (quantity < product.stockQuantity) {
                  bookingProvider.addProductToListPro(product);
                } else {
                  showBottomMessageError(
                      "${product.name} is Out of Stock!", context);
                }
              },
            ),
          ],
        ),
      ],
    ),
  );
}

Row rowPricesProduct({
  required BuildContext context,
  required ProductModel productModel,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic, // ✅ REQUIRED when using baseline

    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(
          left: Dimensions.dimensionNo8,
        ),
        child: Text(
          "Rs. ${productModel.originalPrice.toString()}",
          style: productModel.discountPrice != null ||
                  productModel.discountPrice != 0
              ? TextStyle(
                  color: const Color(0xFF525252),
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo10
                      : Dimensions.dimensionNo12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration
                      .lineThrough, // ✅ Cross line (strikethrough)
                  decorationColor:
                      const Color(0xFF525252), // Optional: same color as text
                  decorationThickness:
                      1.5, // Optional: thickness of the cross line
                )
              : TextStyle(
                  color: const Color(0xFF343434),
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
        ),
      ),
      productModel.discountPrice != null || productModel.discountPrice != 0
          ? Padding(
              padding: EdgeInsets.only(
                left: Dimensions.dimensionNo8,
              ),
              child: Text(
                "Rs. ${productModel.discountPrice.toString()}",
                style: TextStyle(
                  color: const Color(0xFF343434),
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : const SizedBox(),
      productModel.discountPer != null || productModel.discountPer != 0
          ? Padding(
              padding: EdgeInsets.only(
                left: Dimensions.dimensionNo8,
              ),
              child: Text(
                "${productModel.discountPer.toString()}% OFF",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : const SizedBox()
    ],
  );
}
