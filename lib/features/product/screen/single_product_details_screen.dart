// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class SingleProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;
  const SingleProductDetailsScreen({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: const MobileDrawer(),
      key: _scaffoldKey,
      body: ResponsiveLayout(
          mobile: mobileWidget(context),
          tablet: desktopWidget(context),
          desktop: desktopWidget(context)),
    );
  }

  Widget mobileWidget(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.dimensionNo12),
          child: Column(
            children: [
              imagePart(context),
              inforOfProductWidget(context),
            ],
          ),
        ),
      );

  SingleChildScrollView desktopWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dimensions.dimensionNo12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimensions.screenHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                imagePart(context),
                SizedBox(
                  width: Dimensions.dimensionNo16,
                ),
                inforOfProductWidget(context)
              ],
            ),
          ),
          SizedBox(
            height: Dimensions.dimensionNo12,
          ),
          Container(
            child: Column(
              children: [
                Text(
                  'Ratings & Comments',
                  style: TextStyle(
                    color: const Color(0xFF0F1616),
                    fontSize: Dimensions.dimensionNo18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.28,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget inforOfProductWidget(BuildContext context) {
    // Mobile Infor of Product
    return ResponsiveLayout.isMobile(context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rowOFCates(context),
              Text(
                productModel.name,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: const Color(0xFF0F1616),
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo22
                      : Dimensions.dimensionNo30,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.27,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
                child: Text(
                  productModel.brandName,
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
              rowPrices(context),
              descripWidget(context),
            ],
          )
        // Desktop and Table Infor of Product
        : Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveLayout.isMobile(context)
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      top: Dimensions.dimensionNo10,
                      left: Dimensions.dimensionNo12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowOFCates(context),
                  Text(
                    productModel.name,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: const Color(0xFF0F1616),
                      fontSize: Dimensions.dimensionNo30,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.27,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
                    child: Text(
                      productModel.brandName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: Dimensions.dimensionNo18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  rowPrices(context),
                  descripWidget(context),
                ],
              ),
            ),
          );
  }

  Padding descripWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.dimensionNo12,
        bottom: Dimensions.dimensionNo12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              color: const Color(0xFF0F1616),
              fontSize: Dimensions.dimensionNo18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.28,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.dimensionNo12),
            child: Text(
              productModel.description,
              textAlign: TextAlign.start, // ensures left alignment
              overflow: TextOverflow.fade, // or TextOverflow.ellipsis if needed
              style: TextStyle(
                color: const Color(0xFF0F1616),
                fontSize: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimensionNo14
                    : Dimensions.dimensionNo16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          )
        ],
      ),
    );
  }

  Row rowPrices(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic, // ✅ REQUIRED when using baseline

      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Dimensions.dimensionNo12,
          ),
          child: Text(
            "Rs. ${productModel.originalPrice.toString()}",
            style: productModel.discountPrice != null ||
                    productModel.discountPrice != 0
                ? TextStyle(
                    color: const Color(0xFF525252),
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo12
                        : Dimensions.dimensionNo16,
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
                        ? Dimensions.dimensionNo18
                        : Dimensions.dimensionNo22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
          ),
        ),
        productModel.discountPrice != null || productModel.discountPrice != 0
            ? Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.dimensionNo18,
                ),
                child: Text(
                  "Rs. ${productModel.discountPrice.toString()}",
                  style: TextStyle(
                    color: const Color(0xFF343434),
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo18
                        : Dimensions.dimensionNo22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : const SizedBox(),
        productModel.discountPer != null || productModel.discountPer != 0
            ? Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.dimensionNo18,
                ),
                child: Text(
                  "${productModel.discountPer.toString()}% OFF",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo12
                        : Dimensions.dimensionNo16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Padding rowOFCates(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.dimensionNo12),
      child: ResponsiveLayout.isMoAndTab(context)
          ? Wrap(
              children: [
                Text(
                  '${productModel.cateName} > ',
                  style: cateRowTextStyle(context),
                ),
                productModel.subCateName != null ||
                        productModel.subCateName.isNotEmpty
                    ? Text(
                        '${productModel.subCateName} > ',
                        style: cateRowTextStyle(context),
                      )
                    : const SizedBox(),
                productModel.branchName != null ||
                        productModel.branchName.isNotEmpty
                    ? Text(
                        productModel.branchName,
                        style: cateRowTextStyle(context),
                      )
                    : const SizedBox(),
              ],
            )
          : Row(
              children: [
                Text(
                  '${productModel.cateName} > ',
                  style: cateRowTextStyle(context),
                ),
                productModel.subCateName != null ||
                        productModel.subCateName.isNotEmpty
                    ? Text(
                        '${productModel.subCateName} > ',
                        style: cateRowTextStyle(context),
                      )
                    : const SizedBox(),
                productModel.branchName != null ||
                        productModel.branchName.isNotEmpty
                    ? Text(
                        productModel.branchName,
                        style: cateRowTextStyle(context),
                      )
                    : const SizedBox(),
              ],
            ),
    );
  }

  TextStyle cateRowTextStyle(BuildContext context) {
    return TextStyle(
      color: const Color(0xFF747474),
      fontSize: ResponsiveLayout.isMoAndTab(context)
          ? Dimensions.dimensionNo10
          : Dimensions.dimensionNo14,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
    );
  }

  Widget imagePart(BuildContext context) {
    return Container(
      alignment: ResponsiveLayout.isMobile(context) ? Alignment.center : null,
      width: ResponsiveLayout.isMobile(context)
          ? double.infinity
          : Dimensions.screenWidth / 2.5,
      // height:
      //     ResponsiveLayout.isMobile(context) ? Dimensions.dimensionNo500 : null,
      padding: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.symmetric(vertical: Dimensions.dimensionNo10)
          : EdgeInsets.only(
              top: Dimensions.dimensionNo10,
              left: Dimensions.dimensionNo12,
              bottom: Dimensions.dimensionNo12),
      child: Image.network(
        productModel.imgUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
