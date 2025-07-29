import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/features/product/widget/filter_bar_widget.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

FractionallySizedBox filterBarBottomSheetMobile(
  BuildContext context,
  ProductProvider productProvider,
) {
  final bool isDefaultState =
      productProvider.getSelectCategoryListFilter.isEmpty &&
          productProvider.getSelectBrandModelList.isEmpty &&
          productProvider.getIsVisibleProduct ==
              true && // assuming default is visible
          (productProvider.getStockStatusFilter == null ||
              productProvider.getStockStatusFilter!.isEmpty);
  return FractionallySizedBox(
    heightFactor: 0.8, // 80% of screen height
    child: Container(
      color: const Color(0xFFE5E5E5),
      child: Column(
        children: [
          // 🔹 Header (Filter & Sort + Close Button)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter & Sort",
                  style: TextStyle(
                    fontSize: Dimensions.dimensionNo18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () {
                    if (isDefaultState) {
                      Navigator.pop(context);
                    } else {
                      showDeleteAlertDialogWithNo(
                          context: context,
                          noText: "Clear all",
                          yesText: "Apply",
                          title: "Want to discard filter changes?",
                          message:
                              'You modified some filter. Would you like to apply the changes or discard them?',
                          ontap: () {
                            productProvider.applyFilterPro();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          ontapForNoBut: () {
                            productProvider.reSetFilterPro();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                      // showDeleteAlertDialog(
                      //   context,
                      //   "Want to discard filter changes?",
                      //   'You modified some filter. Would you like to apply the changes or discard them?',
                      //   () {
                      //     productProvider.applyFilterPro();
                      //     Navigator.pop(context);
                      //   },
                      // );
                    }
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          const Expanded(child: FilterBarWidgetProductScreen()),

          const Divider(
            height: 1,
            color: Colors.black,
            thickness: 1,
          ),

          filterTwoButtonMobile(context, productProvider),
        ],
      ),
    ),
  );
}

Widget filterTwoButtonMobile(
    BuildContext context, ProductProvider productProvider) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.all(
      Dimensions.dimensionNo12,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: filterButtonMobile(
            'Reset Filter',
            () {
              productProvider.reSetFilterPro();
              Navigator.pop(context);
            },
            Colors.white,
            const Color(0xFF1C110C),
            EdgeInsets.all(Dimensions.dimensionNo12),
          ),
        ),
        const SizedBox(width: 12), // ✅ Add spacing between buttons
        Expanded(
          child: filterButtonMobile(
            'Apply',
            () {
              productProvider.applyFilterPro();
              Navigator.pop(context);
            },
            AppColor.buttonColor,
            Colors.white,
            EdgeInsets.symmetric(
                vertical: Dimensions.dimensionNo12,
                horizontal: Dimensions.dimensionNo16),
          ),
        ),
      ],
    ),
  );
}

Widget filterButtonMobile(String name, Function()? onPressed,
    Color backgroundColor, Color textColors, EdgeInsetsGeometry padding) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    child: Container(
      width: double.infinity, // ✅ Force it to fill Expanded width
      alignment: Alignment.center, // ✅ Center text inside
      padding: padding,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
            side: const BorderSide(color: Colors.black, width: 1)),
      ),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColors,
          fontSize: Dimensions.dimensionNo14,
          fontFamily: GoogleFonts.inter().fontFamily,
          fontWeight: FontWeight.w700,
          height: 1.50,
        ),
      ),
    ),
  );
}




   // 🔹 30% (Left side - Categories) + 70% (Right side - Options)
          // Expanded(
          //   child: Row(
          //     children: [
          //       // Left side (30%) - Filter Categories
          //       Container(
          //         width: MediaQuery.of(context).size.width *
          //             0.3, //30%
          //         color: Colors.grey[100],
          //         child: ListView(
          //           children: [
          //             filterCategoryTile("Category"),
          //             filterCategoryTile("Sub-Category"),
          //             filterCategoryTile("Brand"),
          //             filterCategoryTile("Stock"),
          //             filterCategoryTile("Visibility"),
          //             filterCategoryTile("Sort By"),
          //           ],
          //         ),
          //       ),

          //       // Right side (70%) - Selection Options
          //       Expanded(
          //         child: Container(
          //           padding: const EdgeInsets.all(12),
          //           color: Colors.white,
          //           child: ListView(
          //             children: [
          //               // Example options (You should make it dynamic)
          //               CheckboxListTile(
          //                 value: true,
          //                 onChanged: (val) {},
          //                 title: const Text("Option 1"),
          //               ),
          //               CheckboxListTile(
          //                 value: false,
          //                 onChanged: (val) {},
          //                 title: const Text("Option 2"),
          //               ),
          //               CheckboxListTile(
          //                 value: false,
          //                 onChanged: (val) {},
          //                 title: const Text("Option 3"),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),




  // Widget filterCategoryTile(String title) {
  //   return ListTile(
  //     title: Text(
  //       title,
  //       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //     ),
  //     onTap: () {
  //       // Change right-side selection based on selected category
  //     },
  //   );
  // }