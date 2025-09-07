// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/product/screen/edit_product_screen.dart';
import 'package:samay_admin_plan/features/product/screen/product_add_screen.dart';
import 'package:samay_admin_plan/features/product/screen/single_product_details_screen.dart';
import 'package:samay_admin_plan/features/product/widget/filter_bar_widget.dart';
import 'package:samay_admin_plan/features/product/widget/mobile_botton_filter_bar.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/add_button.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isSortAsc = true;
  bool _showFilterBar = false;

  List<ProductModel> _productList = [];

  void getData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      if (productProvider.getProductList.isEmpty) {
        await productProvider.getListProductPro(appProvider.getSalonInformation.id);      }
      productProvider.applySearch('');
      // _productList = productProvider.getProductList;
      print("Length of Product List: ${_productList.length}");
    } catch (e) {
      print("Error fetching data: $e");
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
    return Scaffold(
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: const MobileDrawer(),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveLayout.isMobile(context)
              ? EdgeInsets.all(Dimensions.dimensionNo12)
              : EdgeInsets.symmetric(
                  vertical: Dimensions.dimensionNo16,
                  horizontal: Dimensions.dimensionNo16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveLayout.isDesktop(context) ||
                          _showFilterBar ||
                          !ResponsiveLayout.isMobile(context)
                      ? FilterBarWidgetProductScreen(onTapCloseIcon: () {
                          setState(() {
                            _showFilterBar = false;
                          });
                        })
                      : const SizedBox(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingAndButton(context, productProvider),
                        searchBar(productProvider),
                        ResponsiveLayout.isMobile(context)
                            ? rowFilterBarMobile(context, productProvider)
                            : const SizedBox(),
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : tableOfProductList(productProvider),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget rowFilterBarMobile(
      BuildContext context, ProductProvider productProvider) {
    final bool isDefaultState =
        productProvider.getSelectCategoryListFilter.isEmpty &&
            productProvider.getSelectBrandModelList.isEmpty &&
            productProvider.getIsVisibleProduct ==
                true && // assuming default is visible
            (productProvider.getStockStatusFilter == null ||
                productProvider.getStockStatusFilter!.isEmpty);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: Dimensions.dimensionNo12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                isDismissible: false,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return filterBarBottomSheetMobile(context, productProvider);
                },
              );
            },
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.sliders,
                    size: Dimensions.dimensionNo18),
                const SizedBox(width: 4),
                Text(
                  "Filter",
                  style: TextStyle(
                    color: const Color(0xFF0F1416),
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo16
                        : ResponsiveLayout.isTablet(context)
                            ? Dimensions.dimensionNo24
                            : Dimensions.dimensionNo30,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                SizedBox(width: Dimensions.dimensionNo8),
              ],
            ),
          ),
          Consumer<ProductProvider>(builder: (context, productProvider, child) {
            return Row(
              children: [
                filterChipMobile(
                  'Category',
                  productProvider.getSelectCategoryListFilter.length,
                ),
                filterChipMobile(
                  'Sub-Category',
                  productProvider.getSelectSubCategoryListFilter.length,
                ),
                filterChipMobile(
                  'Branch',
                  productProvider.getSelectBranchListFilter.length,
                ),
                filterChipMobile(
                  'Brand',
                  productProvider.getSelectBrandModelList.length,
                ),
                filterChipMobile(
                  'Visibility',
                  0,
                ),
                filterChipMobile(
                  'Stock ',
                  0,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget filterChipMobile(String name, int selectCount) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.dimensionNo8),
      child: Chip(
        label: RichText(
          text: TextSpan(
            style: TextStyle(
              color: const Color(0xFF0C1911),
              fontSize: Dimensions.dimensionNo14,
              fontFamily: 'Spline Sans',
              fontWeight: FontWeight.w500,
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
        backgroundColor:
            selectCount != 0 ? Colors.green[100] : const Color(0xFFF7FCF9),
      ),
    );
  }

  Padding headingAndButton(
      BuildContext context, ProductProvider productProvider) {
    return Padding(
      padding: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.zero
          : EdgeInsets.only(
              bottom: Dimensions.dimensionNo16,
              left: Dimensions.dimensionNo16,
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (ResponsiveLayout.isTablet(context))
                !_showFilterBar
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            _showFilterBar = true;
                          });
                        },
                        icon: Icon(
                          Icons.menu_rounded,
                          size: Dimensions.dimensionNo24,
                        ),
                      )
                    : const SizedBox(),
              Text(
                'My Products',
                style: TextStyle(
                  color: const Color(0xFF0F1416),
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo18
                      : ResponsiveLayout.isTablet(context)
                          ? Dimensions.dimensionNo24
                          : Dimensions.dimensionNo30,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ],
          ),
          AddButton(
            text: ResponsiveLayout.isMobile(context)
                ? "Product"
                : "Add New Product",
            onTap: () {
              Routes.instance
                  .push(widget: const ProductAddScreen(), context: context);
            },
          )
        ],
      ),
    );
  }

//! Search Bar for product
  Widget searchBar(ProductProvider productProvider) {
    return Padding(
      padding: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.symmetric(
              vertical: Dimensions.dimensionNo12,
            )
          : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo16),
      child: Container(
        height: Dimensions.dimensionNo40,
        width: ResponsiveLayout.isMobile(context)
            ? double.infinity
            : Dimensions.screenWidth / 2,
        decoration: BoxDecoration(
          color: const Color(0xFFEAEDF2),
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          controller: searchController,
          onChanged: (val) {
            productProvider.applySearch(val);
          },
          style: TextStyle(
            fontSize: Dimensions.dimensionNo14,
            fontFamily: GoogleFonts.inter().fontFamily,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF0F1416),
            height: 1.25,
          ),
          decoration: InputDecoration(
            isDense: true, // Add this line to make the input field more compact
            contentPadding:
                EdgeInsets.symmetric(vertical: Dimensions.dimensionNo12),
            hintText: 'Search Product',
            hintStyle: TextStyle(
              color: const Color(0xFF707070),
              fontSize: Dimensions.dimensionNo14,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF707070),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget tableOfProductList(ProductProvider productProvider) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            _productList =
                productProvider.getProductFilterSearchList; // use filtered list

            if (_productList.isEmpty) {
              return const Center(child: Text("No products found"));
            }
            if (productProvider.getFilterApplyLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // constraints.maxWidth is the available width
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                // Make its child at least as wide as the viewport
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Padding(
                  padding: ResponsiveLayout.isMobile(context)
                      ? EdgeInsets.only(
                          right: Dimensions.dimensionNo8,
                          // top: Dimensions.dimensionNo12,
                        )
                      : EdgeInsets.only(
                          top: Dimensions.dimensionNo16,
                          bottom: Dimensions.dimensionNo16,
                          left: Dimensions.dimensionNo16,
                        ),
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(const Color(0xFFEAEDF2)),
                    dataRowColor: WidgetStateProperty.all(Colors.white),
                    border: TableBorder.all(
                      color: Colors.black,
                      width: 1,
                      borderRadius:
                          BorderRadius.circular(Dimensions.dimensionNo12),
                    ),
                    columns: tableOfProductListColumns(),
                    rows: tableOfProductListCells(productProvider),
                    headingTextStyle: TextStyle(
                      color: const Color(0xFF0F1416),
                      fontSize: Dimensions.dimensionNo14,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                    dataTextStyle: TextStyle(
                      color: const Color(0xFF0F1416),
                      fontSize: Dimensions.dimensionNo14,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    columnSpacing: 24,
                    horizontalMargin: 12,
                    dividerThickness: 0.5,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<DataColumn> tableOfProductListColumns() {
    return [
      DataColumn(
          label: productListHeadingText("No."),
        
          // numeric: true,
          ),
      DataColumn(
          label: productListHeadingText('Product'),
          onSort: (columnIndex, _) {
            setState(() {
              if (_isSortAsc) {
                _productList.sort((a, b) => a.name.compareTo(b.name));
              } else {
                _productList.sort((a, b) => b.name.compareTo(a.name));
              }

              _isSortAsc = !_isSortAsc;
            });
          }),
      DataColumn(
          label: productListHeadingText('Price'),
          onSort: (columnIndex, _) {
            setState(() {
              if (_isSortAsc) {
                _productList
                    .sort((a, b) => a.discountPrice.compareTo(b.discountPrice));
              } else {
                _productList
                    .sort((a, b) => b.discountPrice.compareTo(a.discountPrice));
              }

              _isSortAsc = !_isSortAsc;
            });
          }
          // numeric: true,
          ),
      DataColumn(
          label: productListHeadingText('Stock'),
          onSort: (columnIndex, _) {
            setState(() {
              if (_isSortAsc) {
                _productList
                    .sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));
              } else {
                _productList
                    .sort((a, b) => b.stockQuantity.compareTo(a.stockQuantity));
              }

              _isSortAsc = !_isSortAsc;
            });
          }
          // numeric: true,
          ),
      DataColumn(
          label: productListHeadingText('Visibility'),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, _) {
            setState(() {
              if (_isSortAsc) {
                _productList.sort((a, b) =>
                    (a.visibility ? 1 : 0).compareTo(b.visibility ? 1 : 0));
              } else {
                _productList.sort((a, b) =>
                    (b.visibility ? 1 : 0).compareTo(a.visibility ? 1 : 0));
              }

              _isSortAsc = !_isSortAsc;
            });
          }),
      DataColumn(
        label: productListHeadingText('Actions'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> tableOfProductListCells(ProductProvider productProvider) {
    return _productList.asMap().entries.map((entry) {
      int index = entry.key;
      ProductModel product = entry.value;
      bool isVisibility = product.visibility;
      return DataRow(
        cells: [
          //1. Sr.no Cell Row
          DataCell(
            placeholder: true,
            Text(
              "${index + 1}",
              style: TextStyle(
                color: const Color(0xFF0F1416),
                fontSize: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimensionNo12
                    : Dimensions.dimensionNo14,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          ),
          //2. Name and Image Product  Cell Row

          DataCell(
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Routes.instance.push(
                    widget: SingleProductDetailsScreen(productModel: product),
                    context: context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: Dimensions.dimensionNo36,
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
                ],
              ),
            ),
          ),

          //3. Price of Product  Cell Row

          DataCell(
            Text(
              "₹ ${product.discountPrice.toString()}",
              style: TextStyle(
                color: const Color(0xFF5B7289),
                fontSize: Dimensions.dimensionNo14,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),

          //4. Stock of Product  Cell Row

          DataCell(
            Text(
              product.stockQuantity.toString(),
              style: TextStyle(
                color: const Color(0xFF0F1416),
                fontSize: Dimensions.dimensionNo14,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          ),

          //5. Visibility of Product  Cell Row
          DataCell(
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                try {
                  showLoaderDialog(context);
                  Uint8List? updateImage;
                  ProductModel updateProduct =
                      product.copyWith(visibility: !product.visibility);
                  await productProvider.updateProductPro(
                      updateProduct, updateImage);
                  Navigator.pop(context);
                  updateProduct.visibility
                      ? showBottomMessage(
                          "Product ${updateProduct.name} visible  successfully",
                          context)
                      : showBottomMessage(
                          "Product ${updateProduct.name} hidden  successfully",
                          context);
                } catch (e) {
                  print("Error: In Product screen on Visibility Button: $e ");
                  showBottomMessageError(
                      "Something went wrong please try again", context);
                  Navigator.pop(context);
                }
              },
              child: Container(
                // margin: EdgeInsets.all(6),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEDF2),
                  borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
                  border: Border.all(
                    color: isVisibility
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                        isVisibility
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                        color: isVisibility
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF44336)),
                    SizedBox(
                      width: Dimensions.dimensionNo10,
                    ),
                    Text(
                      isVisibility ? "Visible" : "Hidden",
                      style: TextStyle(
                        color: isVisibility
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF44336),
                        fontSize: Dimensions.dimensionNo12,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                        height: 1.50,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //6. Actions Cell Row
          DataCell(
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Routes.instance.push(
                          widget: EditProductScreen(productModel: product),
                          context: context);
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: const Color(0xFF96604F),
                        fontSize: Dimensions.dimensionNo14,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDeleteAlertDialog(context, "Delete Product!",
                          "Do you want to delete this ${product.name} product?",
                          () async {
                        try {
                          showLoaderDialog(context);

                          await productProvider.deleteProductByIdPro(product);
                          Navigator.pop(context);
                          Navigator.pop(context);

                          showBottomMessage(
                              "Product ${product.name} visible  successfully",
                              context);
                        } catch (e) {
                          print(
                              "Error: In Product screen on Delete Button: $e ");
                          showBottomMessageError(
                              "Something went wrong please try again", context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: Dimensions.dimensionNo20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget productListHeadingText(
    String name,
  ) {
    return Text(
      name,
      style: TextStyle(
        color: Colors.black,
        fontSize: Dimensions.dimensionNo14,
        fontFamily: GoogleFonts.inter().fontFamily,
        fontWeight: FontWeight.w600,
        height: 1.50,
      ),
    );
  }
}


//  color: const Color(0xFFEAEDF2),