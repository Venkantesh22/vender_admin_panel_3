// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/product/widget/branch_filter.dart';
import 'package:samay_admin_plan/features/product/widget/sub_cate.dart';
import 'package:samay_admin_plan/models/Product/brand_model/brand_model.dart';
import 'package:samay_admin_plan/models/Product/product%20category%20model/product_category_model.dart';
import 'package:samay_admin_plan/models/Product/product_branch_model.dart/product_branch_model.dart';
import 'package:samay_admin_plan/models/Product/product_sub_category_model/product_sub_category_model.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class FilterBarWidgetProductScreen extends StatefulWidget {
  final Function()? onTapCloseIcon;
  const FilterBarWidgetProductScreen({super.key, this.onTapCloseIcon});

  @override
  State<FilterBarWidgetProductScreen> createState() =>
      _FilterBarWidgetProductScreenState();
}

class _FilterBarWidgetProductScreenState
    extends State<FilterBarWidgetProductScreen> {
  bool isCategoryOpen = false;
  bool isSubCategoryOpen = false;
  bool isBranchOpen = false;
  bool isBrandOpen = false;
  // bool isVisibleOpen = true;
  bool isStockOpen = false;
  bool _isLoading = false;

  String? _visibilityFilter =
      GlobalVariable.productVisible; // null = no filter, "visible" or "hidden"
  String? _stockStatus;

  List<BrandCategoryModel> _productCategoryList = [];
  List<SubCateFilter> _subCateModelListFilter = [];
  List<BranchModelFilter> _branchModelListFilter = [];
  List<BrandModel> _brandListFilter = [];
  void getData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      if (productProvider.getProductCategoryList.isEmpty) {
        await productProvider.getListOfProductCategoryListPro();
      }
      _productCategoryList = productProvider.getProductCategoryList;

      if (productProvider.getBrandList.isEmpty) {
        await productProvider.getListOfBrandModelPro();
      }
      _brandListFilter = productProvider.getBrandList;
      print("objects: ${_productCategoryList.length}");
    } catch (e) {
      print("Error: in filter_bar_widget_product_screen: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        width: ResponsiveLayout.isMobile(context)
            ? double.infinity
            : Dimensions.screenWidth / 4.5,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6, top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !ResponsiveLayout.isMobile(context)
                            ? Text(
                                'Filters',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimensionNo22,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeight.w700,
                                  height: 1.27,
                                ),
                              )
                            : const SizedBox(),
                        ResponsiveLayout.isTablet(context)
                            ? IconButton(
                                onPressed: widget.onTapCloseIcon,
                                icon: Icon(
                                  Icons.close,
                                  size: Dimensions.dimensionNo20,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.dimensionNo12,
                  ),
                  categoryOptions(),
                  subCategoryOptions(productProvider),
                  branchOptions(productProvider),
                  brandOptions(productProvider),
                  visibleOptions(productProvider),
                  stockOptions(productProvider),
                  !ResponsiveLayout.isMobile(context)
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Divider(
                            thickness: 1,
                          ),
                        )
                      : const SizedBox(),
                  !ResponsiveLayout.isMobile(context)
                      ? filterTwoButton(productProvider)
                      : const SizedBox(),
                  SizedBox(
                    height: Dimensions.dimensionNo10,
                  )
                ],
              ),
      ),
    );
  }

  Padding filterTwoButton(ProductProvider productProvider) {
    return Padding(
      padding: EdgeInsets.all(
        Dimensions.dimensionNo12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: filterButton('Reset Filter', () {
              productProvider.reSetFilterPro();
              setState(() {
                // isVisibleProduct = true;
                _stockStatus = null;
                _visibilityFilter = null;
                _stockStatus = null;
                // isVisibleOpen = false;
                isCategoryOpen = false;
                isSubCategoryOpen = false;
                isBranchOpen = false;
                isBrandOpen = false;
                isStockOpen = false;
              });
            }, Colors.white, const Color(0xFF1C110C),
                EdgeInsets.all(Dimensions.dimensionNo12)),
          ),
          const SizedBox(width: 12), // ✅ Add spacing between buttons
          Expanded(
            child: filterButton(
              'Apply',
              () {
                productProvider.applyFilterPro();
                setState(() {});
              },
              // const Color(0xFFE86030),
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

  Widget filterButton(String name, Function()? onPressed, Color backgroundColor,
      Color textColors, EdgeInsetsGeometry padding) {
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
              borderRadius: BorderRadius.circular(Dimensions.dimensionNo12)),
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

// Category filter options widget
// Category filter options widget
  Padding categoryOptions() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.dimensionNo12,
        right: Dimensions.dimensionNo12,
        bottom: Dimensions.dimensionNo8,
      ),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          final isOpen = isCategoryOpen;
          final selected = productProvider.getSelectCategoryListFilter;
          return GestureDetector(
            onTap: () => setState(() => isCategoryOpen = !isCategoryOpen),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimensionNo15,
                vertical: Dimensions.dimensionNo8,
              ),
              decoration: ShapeDecoration(
                color: selected.isNotEmpty
                    ? Colors.green[100]
                    : const Color(0xFFF7FCF9),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFCEE8E2),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  // Header row with title + count + expand icon
                  categoryBar(
                    'Category',
                    selected.length,
                    isOpen,
                  ),
                  // Expanded list of checkboxes
                  if (isOpen)
                    ListView.builder(
                      itemCount: _productCategoryList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final category = _productCategoryList[index];
                        final isChecked = selected.contains(category);
                        return checkAndNameCateWidget(
                          productProvider,
                          category.name,
                          (checked) async {
                            if (checked == true) {
                              productProvider
                                  .addSelectCategoryListFilterPro(category);
                              await productProvider
                                  .fetchSubCateListFilterPro(category);
                            } else {
                              productProvider
                                  .removeSelectCategoryListFilterPro(category);
                              productProvider
                                  .removeAllSubCateForList(category.id);
                            }
                          },
                          isChecked,
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

// Sub-Category filter widget
  Padding subCategoryOptions(ProductProvider productProvider) {
    _subCateModelListFilter = productProvider.getSubCateModelListFilter;
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.dimensionNo12,
        right: Dimensions.dimensionNo12,
        bottom: Dimensions.dimensionNo8,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSubCategoryOpen = !isSubCategoryOpen;
          });
          print("isSubCategoryOpen :- $isSubCategoryOpen");
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimensionNo15,
              vertical: Dimensions.dimensionNo8),
          decoration: ShapeDecoration(
            color: productProvider.getSelectSubCategoryListFilter.isNotEmpty
                ? Colors.green[100]
                : const Color(0xFFF7FCF9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFCEE8E2),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              categoryBar(
                  'Sub-Category',
                  productProvider.getSelectSubCategoryListFilter.length,
                  isSubCategoryOpen),
              isSubCategoryOpen
                  ? productProvider.getIsSubCategoryLoadingFilter
                      ? const Center(child: CircularProgressIndicator())
                      : _subCateModelListFilter.isEmpty
                          ? const Center(child: Text('No sub category found'))
                          : Column(
                              children: [
                                ListView.builder(
                                  itemCount: _subCateModelListFilter.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    SubCateFilter subCategory =
                                        _subCateModelListFilter[index];
                                    return checkAndNameSubCateWidget(
                                      productProvider,
                                      subCategory,
                                    );
                                  },
                                ),
                              ],
                            )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

// Branch filter widget
  Padding branchOptions(ProductProvider productProvider) {
    _branchModelListFilter = productProvider.getBranchModelFilterList;
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.dimensionNo12,
        right: Dimensions.dimensionNo12,
        bottom: Dimensions.dimensionNo8,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isBranchOpen = !isBranchOpen;
          });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimensionNo15,
              vertical: Dimensions.dimensionNo8),
          decoration: ShapeDecoration(
            color: productProvider.getSelectBranchListFilter.isNotEmpty
                ? Colors.green[100]
                : const Color(0xFFF7FCF9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFCEE8E2),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              categoryBar(
                  'Branch',
                  productProvider.getSelectBranchListFilter.length,
                  isBranchOpen),
              isBranchOpen
                  ? productProvider.getIsBranchLoadingFilter
                      ? const Center(child: CircularProgressIndicator())
                      : _branchModelListFilter.isEmpty
                          ? const Center(child: Text('No branch found'))
                          : Column(
                              children: [
                                ListView.builder(
                                  itemCount: _branchModelListFilter.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    BranchModelFilter branchModel =
                                        _branchModelListFilter[index];
                                    return checkAndNameBranchWidget(
                                      productProvider,
                                      branchModel,
                                    );
                                  },
                                ),
                              ],
                            )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Brand filter options widget
  Padding brandOptions(ProductProvider productProvider) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.dimensionNo12,
        right: Dimensions.dimensionNo12,
        bottom: Dimensions.dimensionNo8,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isBrandOpen = !isBrandOpen;
          });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimensionNo15,
              vertical: Dimensions.dimensionNo8),
          decoration: ShapeDecoration(
            color: productProvider.getSelectBrandModelList.isNotEmpty
                ? Colors.green[100]
                : const Color(0xFFF7FCF9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFCEE8E2),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              categoryBar(
                'Brand',
                productProvider.getSelectBrandModelList.length,
                isBrandOpen,
              ),
              isBrandOpen
                  ? Column(
                      children: [
                        ListView.builder(
                            itemCount: _brandListFilter.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              BrandModel brandModel = _brandListFilter[index];

                              return checkAndNameCateWidget(
                                  productProvider, brandModel.name,
                                  (checked) async {
                                if (checked == true) {
                                  productProvider
                                      .addSelectBrandListFilterPro(brandModel);
                                } else {
                                  productProvider
                                      .removeSelectBrandFilterListPro(
                                          brandModel);
                                }
                                setState(() {});
                              },
                                  productProvider.getSelectBrandModelList
                                      .contains(brandModel));
                            })
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Visible filter options widget
  Padding visibleOptions(ProductProvider productProvider) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.dimensionNo12,
        right: Dimensions.dimensionNo12,
        bottom: Dimensions.dimensionNo8,
      ),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimensionNo15,
          vertical: Dimensions.dimensionNo8,
        ),
        decoration: ShapeDecoration(
          // highlight if the switch is on (showing hidden products)
          color: (_visibilityFilter == GlobalVariable.productHidden)
              ? Colors.green[100]
              : const Color(0xFFF7FCF9),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFCEE8E2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "Hidden Product",
            style: TextStyle(
              fontSize: Dimensions.dimensionNo15,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.bold,
              height: 1.50,
            ),
          ),
          value: _visibilityFilter == GlobalVariable.productHidden,
          onChanged: (bool value) {
            setState(() {
              _visibilityFilter = value
                  ? GlobalVariable.productHidden
                  : GlobalVariable.productVisible;
            });
            // call provider to update filter
            productProvider.updateVisibleProductFilterPro(!value);
          },
          activeColor: AppColor.buttonColor,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ),
    );
  }

//   // Visible filter options widget
//   Padding visibleOptions(ProductProvider productProvider) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: Dimensions.dimensionNo12,
//         right: Dimensions.dimensionNo12,
//         bottom: Dimensions.dimensionNo8,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             isVisibleOpen = !isVisibleOpen;
//             _visibilityFilter = "";
//           });
//           productProvider.applyFilterPro();
//         },
//         child: Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(
//               horizontal: Dimensions.dimensionNo15,
//               vertical: Dimensions.dimensionNo8),
//           decoration: ShapeDecoration(
//             color: _visibilityFilter != null
//                 ? Colors.green[100]
//                 : const Color(0xFFF7FCF9),
//             shape: RoundedRectangleBorder(
//               side: const BorderSide(
//                 width: 1,
//                 color: Color(0xFFCEE8E2),
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: Column(
//             children: [
//               categoryBar('Visibility', 0, !isVisibleOpen),
//               isVisibleOpen
//                   ? // In your State:

// // In your build() where you want the Visibility section:
//                   Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Radio<String>(
//                               value: GlobalVariable.productVisible,
//                               groupValue: _visibilityFilter,
//                               onChanged: (val) {
//                                 setState(() => _visibilityFilter = val);
//                                 productProvider
//                                     .updateVisibleProductFilterPro(true);
//                                 // call your filter logic with _visibilityFilter
//                               },
//                             ),
//                             Text(
//                               "Visible",
//                               style: TextStyle(
//                                 fontSize: Dimensions.dimensionNo14,
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.50,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Radio<String>(
//                               value: GlobalVariable.productHidden,
//                               groupValue: _visibilityFilter,
//                               onChanged: (val) {
//                                 setState(() => _visibilityFilter = val);
//                                 productProvider
//                                     .updateVisibleProductFilterPro(false);
//                                 // call your filter logic with _visibilityFilter
//                               },
//                             ),
//                             Text(
//                               "Hidden",
//                               style: TextStyle(
//                                 fontSize: Dimensions.dimensionNo14,
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.50,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   : const SizedBox(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

  // StockS Status filter options widget
  Padding stockOptions(ProductProvider productProvider) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.dimensionNo12,
        right: Dimensions.dimensionNo12,
        bottom: Dimensions.dimensionNo8,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isStockOpen = !isStockOpen;
            _stockStatus = null;
          });
          productProvider.applyFilterPro();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimensionNo15,
              vertical: Dimensions.dimensionNo8),
          decoration: ShapeDecoration(
            color: _stockStatus != null
                ? Colors.green[100]
                : const Color(0xFFF7FCF9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFCEE8E2),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              categoryBar('Stock ', 0, isStockOpen),
              isStockOpen
                  ? // In your State:

// In your build() where you want the Visibility section:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: GlobalVariable.lowStock,
                              groupValue: _stockStatus,
                              onChanged: (val) {
                                setState(() => _stockStatus = val);
                                productProvider
                                    .updateStockProductFilterPro(_stockStatus!);
                                // call your filter logic with _visibilityFilter
                              },
                            ),
                            Text(
                              GlobalVariable.lowStock,
                              style: TextStyle(
                                fontSize: Dimensions.dimensionNo14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: GlobalVariable.outOfStock,
                              groupValue: _stockStatus,
                              onChanged: (val) {
                                setState(() => _stockStatus = val);
                                productProvider
                                    .updateStockProductFilterPro(_stockStatus!);
                                // call your filter logic with _visibilityFilter
                              },
                            ),
                            Text(
                              GlobalVariable.outOfStock,
                              style: TextStyle(
                                fontSize: Dimensions.dimensionNo14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

//Sub-category List of check box and name
  Widget checkAndNameSubCateWidget(
      ProductProvider productProvider, SubCateFilter subCateFilter) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              subCateFilter.brandCategoryModel.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.dimensionNo14,
              ),
            ),
          ),
          ListView.builder(
            itemCount: subCateFilter.subCateList.length,
            shrinkWrap: true, // ✅ Allows it to take only required height
            physics:
                const NeverScrollableScrollPhysics(), // ✅ Prevents nested scroll conflicts
            itemBuilder: (context, index) {
              ProductSubCateModel subCate = subCateFilter.subCateList[index];

              // ✅ Corrected selection check
              bool isSelected = productProvider.getSelectSubCategoryListFilter
                  .any((selected) => selected.id == subCate.id);

              return Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (checked) async {
                      if (checked == true) {
                        productProvider
                            .addSelectSubCategoryListFilterPro(subCate);
                        await productProvider.fetchBranchListFilter(
                            subCate.categoryId, subCate);
                      } else {
                        productProvider
                            .removeSelectSubCategoryFilterListPro(subCate);
                        productProvider.removeAllBranchForList(subCate.id);
                      }
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    checkColor: Colors.white, // Check icon color
                    activeColor: Colors.black, // Box fill color
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  Expanded(
                    child: Text(
                      subCate.name,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: Dimensions.dimensionNo14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

//Branch List of check box and name
  Widget checkAndNameBranchWidget(
      ProductProvider productProvider, BranchModelFilter branchFilter) {
    String text =
        "${branchFilter.productSubCateModel.categoryName} / ${branchFilter.productSubCateModel.name}";
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              text,
              overflow: TextOverflow.fade,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.dimensionNo12,
                  textBaseline: TextBaseline.ideographic),
            ),
          ),
          ListView.builder(
            itemCount: branchFilter.productBranchModelList.length,
            shrinkWrap: true, // ✅ Allows it to take only required height
            physics:
                const NeverScrollableScrollPhysics(), // ✅ Prevents nested scroll conflicts
            itemBuilder: (context, index) {
              ProductBranchModel branch =
                  branchFilter.productBranchModelList[index];

              // ✅ Corrected selection check
              bool isSelected = productProvider.getSelectBranchListFilter
                  .any((selected) => selected.id == branch.id);

              return Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (checked) {
                      if (checked == true) {
                        productProvider.addSelectBranchListFilterPro(branch);
                      } else {
                        productProvider.removeSelectBranchFilterListPro(branch);
                      }
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    checkColor: Colors.white, // Check icon color
                    activeColor: Colors.black, // Box fill color
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  Expanded(
                    child: Text(
                      branch.name,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: Dimensions.dimensionNo14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

//category List of check box and name
  Widget checkAndNameCateWidget(ProductProvider productProviderNotUser,
      String name, Function(bool?)? onChanged, bool checked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: checked,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onChanged: onChanged,
          checkColor: Colors.white, // Check icon color
          activeColor: Colors.black, // Box fill color
          side: const BorderSide(
            color: Colors.grey, // Do not change border color
            width: 2,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: Dimensions.dimensionNo14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ],
    );
  }

  Widget categoryBar(String name, int? selectCount, bool click) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: Dimensions.dimensionNo15,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.bold,
              height: 1.50,
            ),
            children: [
              TextSpan(
                text: name,
                // style: TextStyle(color: Colors.red),
              ),
              selectCount != 0
                  ? TextSpan(
                      text: ' (${selectCount.toString()})',
                    )
                  : const TextSpan(),
            ],
          ),
        ),
        const Spacer(),
        FaIcon(
          click ? FontAwesomeIcons.minus : FontAwesomeIcons.plus,
          size: Dimensions.dimensionNo16,
        ),
      ],
    );
  }
}
