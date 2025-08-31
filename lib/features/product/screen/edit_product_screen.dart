// ignore_for_file: unused_field, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/validation.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/Product/brand_model/brand_model.dart';
import 'package:samay_admin_plan/models/Product/product%20category%20model/product_category_model.dart';
import 'package:samay_admin_plan/models/Product/product_branch_model.dart/product_branch_model.dart';
import 'package:samay_admin_plan/models/Product/product_sub_category_model/product_sub_category_model.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/dropdownlist/dopdownlist.dart';
import 'package:samay_admin_plan/widget/text_box/validate_textbox_heading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel productModel;
  const EditProductScreen({super.key, required this.productModel});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _loading = false;

  // controller
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descripController = TextEditingController();
  final TextEditingController _mRPPriceController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _discountPerController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();

  @override
  void dispose() {
    _productNameController.dispose();
    _descripController.dispose();
    _mRPPriceController.dispose();
    _discountPriceController.dispose();
    _discountPerController.dispose();
    _productCodeController.dispose();
    _stockQuantityController.dispose();
    super.dispose();
  }

  String? _category;
  String? _subCategory;
  String? _branch;
  String? _brand;
  String? _productFor = GlobalVariable.forUnisex;

  // Dropdown options for "service for"
  final List<String> _productForList = ["Male", "Female", "Unisex"];
  List<BrandCategoryModel> _categoryList = [];
  List<ProductSubCateModel> _subCategoryList = [];
  List<ProductBranchModel> _branchList = [];
  List<BrandModel> _brandList = [];

  Uint8List? selectedImage;
  chooseImages() async {
    FilePickerResult? chosenImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (chosenImageFile != null) {
      setState(() {
        selectedImage = chosenImageFile.files.single.bytes!;
      });
    }
  }

  // key
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DropzoneViewController? _dropzoneController;

// Fetch Brand
  Future<void> getBrand() async {
    // print("SelectCateId :- $SelectCateId");
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      // await productProvider.getListOfProductSubCategoryPro(SelectCateId);
      await productProvider.getListOfBrandModelPro();
      setState(() {
        _brandList = productProvider.getBrandList;
      });
      print("_brandList :- ${_brandList.length}");
    } catch (e) {
      print("Error fetching subcategories: $e");
    }
  }

// Fetch SubCategory
  Future<void> getSubCategory(String SelectCateId) async {
    print("SelectCateId :- $SelectCateId");
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.getListOfProductSubCategoryPro(SelectCateId);
      setState(() {
        _subCategoryList = productProvider.getProductSubCategoryList;
      });
      print("_subCategoryList :- ${_subCategoryList.length}");
    } catch (e) {
      print("Error fetching subcategories: $e");
    }
  }

  // Fetch Branch

  Future<void> getBranch(String selectCateId, String selectSubCateId) async {
    print("SelectCateId :- $selectCateId , $selectSubCateId");
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.getListOfProductBranchPro(
          selectCateId, selectSubCateId);

      setState(() {
        _branchList = List.from(productProvider.getProductBranchModelList)
          ..sort((a, b) => a.order.compareTo(b.order));
      });
      print("_branchList :- ${_branchList.length}");
    } catch (e) {
      print("Error fetching getBranch: $e");
    }
  }

  Future<void> getData() async {
    try {
      setState(() {
        _loading = true;
      });
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.getListOfProductCategoryListPro();
      await productProvider
          .getListOfProductSubCategoryPro(widget.productModel.cateId);
      await productProvider.getListOfProductBranchPro(
          widget.productModel.cateId, widget.productModel.subCateId);
      await productProvider.getListOfBrandModelPro();

      _category = widget.productModel.cateName;
      _subCategory = widget.productModel.subCateName;
      _branch = widget.productModel.branchName;
      _brand = widget.productModel.brandName;

      // update Category list and update select category
      _categoryList = productProvider.getProductCategoryList;
      final selectedModel = _categoryList.firstWhere(
        (cat) => cat.name == _category,
        orElse: () => _categoryList.first,
      );
      productProvider.updateSelectBrandCateModel(selectedModel);

      // update Sub-Category list and update select Sub-Category

      _subCategoryList = productProvider.getProductSubCategoryList;
      final selectedSubCategoryModel = _subCategoryList.firstWhere(
          (subCate) => subCate.name == _subCategory,
          orElse: () => _subCategoryList.first);
      productProvider.updateSelectSubCategoryPro(selectedSubCategoryModel);

      // update Branch list and update select Branch
      _branchList = productProvider.getProductBranchModelList;
      final selectedBranchModel = _branchList.firstWhere(
        (branch) => branch.name == _branch,
        orElse: () => _branchList.first,
      );
      productProvider.updateSelectBranchPro(selectedBranchModel);

      // update brand list and update select brand
      _brandList = productProvider.getBrandList;
      final selectedBrandModel = _brandList.firstWhere(
        (branch) => branch.name == _brand,
        orElse: () => _brandList.first,
      );
      productProvider.updateSelectBrand(selectedBrandModel);

      _productNameController.text = widget.productModel.name;
      _descripController.text = widget.productModel.description;

      _productFor = widget.productModel.productFor;
      _mRPPriceController.text = widget.productModel.originalPrice.toString();
      _discountPriceController.text =
          widget.productModel.discountPrice.toString();
      _discountPerController.text = widget.productModel.discountPer.toString();

      _productCodeController.text = (widget.productModel.productCode == null ||
              widget.productModel.productCode!.isEmpty)
          ? ""
          : widget.productModel.productCode.toString();

      _stockQuantityController.text =
          widget.productModel.stockQuantity.toString();
      print(
          "_stockQuantityController :- ${widget.productModel.stockQuantity.toString()}");

      _discountPriceController.addListener(_updateDiscPerController);
      _mRPPriceController.addListener(_updateDiscPerController);
      _discountPerController.addListener(_updateDiscPerController);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _updateDiscPerController() {
    double? mrpPrice = double.tryParse(_mRPPriceController.text.trim());
    double? discPrice = double.tryParse(_discountPriceController.text.trim());

    if (mrpPrice != null && discPrice != null && mrpPrice > 0) {
      double discPer = ((mrpPrice - discPrice) / mrpPrice) * 100;
      _discountPerController.text = discPer.toStringAsFixed(2); // e.g., "15.00"
    } else {
      _discountPerController.text = '';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will be called after the first build
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: ResponsiveLayout.isMoAndTab(context)
                    ? EdgeInsets.all(Dimensions.dimensionNo16)
                    : EdgeInsets.symmetric(
                        vertical: Dimensions.dimensionNo20,
                        horizontal: Dimensions.dimensionNo160),
                child: Center(
                  child: Form(
                    key: _formKey,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: ResponsiveLayout.isMoAndTab(context)
                                    ? Dimensions.dimensionNo18
                                    : Dimensions.dimensionNo30,
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.dimensionNo10,
                            ),
                            Text(
                              'Edit Product',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF0F1419),
                                fontSize: ResponsiveLayout.isMoAndTab(context)
                                    ? Dimensions.dimensionNo18
                                    : Dimensions.dimensionNo30,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                        // Textbox for Product Name
                        validateTextBoxWithHeading(
                            hintText: "Product Name",
                            labelText: "Product Name",
                            controller: _productNameController,
                            validator: addProductNameValidator),

                        // Textbox for Product Description

                        validateTextBoxWithHeading(
                            maxLin: 5,
                            hintText: "Description",
                            labelText: "Description",
                            controller: _descripController,
                            validator: addProductdescptValidator),

                        // Dropdown for Product For category
                        dropDownList(
                          heading: "Category",
                          value: _category,
                          labelText: "Select Category",
                          valueList: _categoryList
                              .map((e) => e.name)
                              .toList(), // still pass the list of BrandCategoryModel
                          validator: selectProductCategoryValidator,

                          onChanged: (selectedName) async {
                            final selectedModel = _categoryList.firstWhere(
                              (cat) => cat.name == selectedName,
                              orElse: () => _categoryList.first,
                            );
                            setState(() {
                              _category = selectedName;
                              productProvider
                                  .updateSelectBrandCateModel(selectedModel);
                              _subCategory = null;
                              _branch = null;
                            });
                            await getSubCategory(selectedModel.id);
                          },
                        ),

                        // Dropdown for Product For Subcategory

                        dropDownList(
                          heading: "Subcategory",
                          value: _subCategory,
                          labelText: "Select Subcategory",
                          valueList: _subCategoryList
                              .map((e) => e.name)
                              .toList(), // <-- pass names
                          validator: selectProductSubCategoryValidator,
                          onChanged: (selectedSubCateName) async {
                            final selectedSubCategoryModel =
                                _subCategoryList.firstWhere(
                                    (subCate) =>
                                        subCate.name == selectedSubCateName,
                                    orElse: () => _subCategoryList.first);
                            setState(() {
                              _subCategory = selectedSubCateName;
                              productProvider.updateSelectSubCategoryPro(
                                  selectedSubCategoryModel);
                              _branch = null;
                            });
                            await getBranch(selectedSubCategoryModel.categoryId,
                                selectedSubCategoryModel.id);
                          },
                        ),
                        // Dropdown for Product For Subcategory branch

                        dropDownList(
                          heading: "Branch",
                          value: _branch,
                          labelText: "Select Branch",
                          valueList: _branchList
                              .map((e) => e.name)
                              .toList(), // <-- pass names
                          validator: selectProductBranchValidator,
                          onChanged: (selectedBranchName) async {
                            final selectedBranchModel = _branchList.firstWhere(
                              (branch) => branch.name == selectedBranchName,
                              orElse: () => _branchList.first,
                            );

                            setState(() {
                              _branch = selectedBranchName;
                            });
                            productProvider
                                .updateSelectBranchPro(selectedBranchModel);
                            // await getBrand();
                          },
                        ),

                        // Dropdown for Product For
                        selectProductFor(),

                        // Dropdown for Product For  brand
                        dropDownList(
                          heading: "Brand",
                          value: _brand,
                          labelText: "Select Brand",
                          valueList: _brandList
                              .map((e) => e.name)
                              .toList(), // <-- pass names
                          validator: selectProductBrandValidator,
                          onChanged: (selectedBrandName) {
                            final selectedBrandModel = _brandList.firstWhere(
                              (branch) => branch.name == selectedBrandName,
                              orElse: () => _brandList.first,
                            );

                            setState(() {
                              _brand = selectedBrandName;
                            });
                            productProvider
                                .updateSelectBrand(selectedBrandModel);
                          },
                        ),

                        validateTextBoxWithHeading(
                            hintText: "0.00",
                            labelText: "MRP Price",
                            controller: _mRPPriceController,
                            validator: addProductPriceValidator,
                            suffixWidget: const Icon(
                              Icons.currency_rupee,
                              color: Colors.black,
                            )),
                        validateTextBoxWithHeading(
                            hintText: "0.00",
                            labelText: "Discount Price",
                            controller: _discountPriceController,
                            validator: addProductPriceValidator,
                            suffixWidget: const Icon(
                              Icons.currency_rupee,
                              color: Colors.black,
                            )),
                        validateTextBoxWithHeading(
                            hintText: "0%",
                            labelText: "Discount Percentage",
                            controller: _discountPerController,
                            validator: noValidator,
                            suffixWidget: const Icon(
                              Icons.percent,
                              color: Colors.black,
                            )),
                        validateTextBoxWithHeading(
                            hintText: "Product Code",
                            labelText: "Product Code",
                            controller: _productCodeController,
                            validator: noValidator),

                        imageContainer(),

                        validateTextBoxWithHeading(
                            hintText: "Stock Quantity",
                            labelText: "Stock Quantity",
                            controller: _stockQuantityController,
                            validator: addProductStockValidator),
                        SizedBox(
                          height: Dimensions.dimensionNo10,
                        ),
                        CustomAuthButton(
                            text: "Update Product",
                            ontap: () async {
                              try {
                                ProductProvider productProvider =
                                    Provider.of<ProductProvider>(context,
                                        listen: false);
                                if (selectedImage == null &&
                                    widget.productModel.imgUrl == null) {
                                  showBottomMessageError(
                                      'Please select an image for the Product.',
                                      context);

                                  return;
                                }

                                if (_formKey.currentState!.validate()) {
                                  showLoaderDialog(context);
                                  // TimeStampModel timeStampModel =
                                  //     TimeStampModel(
                                  //         id: "",
                                  //         dateAndTime: GlobalVariable.today,
                                  //         updateBy: "Vender");

                                  ProductModel updateProduct =
                                      widget.productModel.copyWith(
                                    name: _productNameController.text.trim(),
                                    description: _descripController.text.trim(),
                                    productFor: _productFor!,
                                    brandName: productProvider
                                        .getSelectBrandModel!.name,
                                    brandID:
                                        productProvider.getSelectBrandModel!.id,
                                    cateName: productProvider
                                        .getSelectBrandCategoryModel!.name,
                                    cateId: productProvider
                                        .getSelectBrandCategoryModel!.id,
                                    subCateName: productProvider
                                        .getSelectSubCategory!.name,
                                    subCateId: productProvider
                                        .getSelectSubCategory!.id,
                                    branchName: productProvider
                                        .getSelectProductBranchModel!.name,
                                    branchId: productProvider
                                        .getSelectProductBranchModel!.id,
                                    stockQuantity: int.tryParse(
                                        _stockQuantityController.text.trim())!,
                                    originalPrice: double.tryParse(
                                        _mRPPriceController.text.trim())!,
                                    discountPer: double.tryParse(
                                        _discountPerController.text.trim())!,
                                    discountPrice: double.tryParse(
                                        _discountPriceController.text.trim())!,
                                    productCode:
                                        _productCodeController.text.trim(),
                                    // timeStampModel: timeStampModel,
                                  );

                                  await productProvider.updateProductPro(
                                      updateProduct, selectedImage);

                                  showBottomMessage(
                                      "Product  ${_productNameController.text.trim()} updated! Successful",
                                      context);

                                  Navigator.pop(context); // Close the dialog,
                                  Navigator.pop(context); // Go back,
                                }
                              } catch (e) {
                                print("Error in Update Product $e");

                                showBottomMessageError(
                                    "Something want wrong try after some time",
                                    context);
                                Navigator.pop(context); // Close the dialog,
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Padding imageContainer() {
    return Padding(
      padding: EdgeInsets.all(Dimensions.dimensionNo16),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 5],
          strokeWidth: 2,
          radius: Radius.circular(Dimensions.dimensionNo16),
          color: const Color(0xFFD3DBE2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS))
              SizedBox(
                width: double.infinity,
                height: Dimensions.dimensionNo250,
                child: DropzoneView(
                  onCreated: (controller) => _dropzoneController = controller,
                  onDropFile: (ev) async {
                    final bytes = await _dropzoneController!.getFileData(ev);
                    setState(() {
                      selectedImage = bytes;
                    });
                  },
                  operation: DragOperation.copy,
                ),
              ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: Dimensions.dimensionNo250,
                maxHeight: Dimensions.dimensionNo250,
              ),
              margin: EdgeInsets.all(Dimensions.dimensionNo16),
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimensionNo24,
                vertical: Dimensions.dimensionNo24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (selectedImage != null)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        chooseImages();
                      },
                      child: Image.memory(
                        selectedImage!,
                        height: Dimensions.dimensionNo180,
                        width: Dimensions.dimensionNo200,
                        fit: BoxFit.fill,
                      ),
                    )
                  else if (widget.productModel.imgUrl.isNotEmpty)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        chooseImages();
                      },
                      child: Image.network(
                        widget.productModel.imgUrl,
                        height: Dimensions.dimensionNo180,
                        width: Dimensions.dimensionNo200,
                        fit: BoxFit.fill,
                      ),
                    )
                  else ...[
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: Dimensions.dimensionNo480),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Upload Images',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF0F1416),
                              fontSize: Dimensions.dimensionNo18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.28,
                            ),
                          ),
                          Text(
                            'Drag and drop 1 images here, or browse',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF0F1416),
                              fontSize: Dimensions.dimensionNo14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Dimensions.dimensionNo100,
                      alignment: Alignment.center,
                      height: Dimensions.dimensionNo40,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimensionNo16),
                      margin: EdgeInsets.only(top: Dimensions.dimensionNo12),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFEAEDF2),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimensionNo20),
                        ),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          chooseImages();
                        },
                        child: Text(
                          'Browse',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF0F1416),
                            fontSize: Dimensions.dimensionNo14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//! For Select a Gender of product
  Column selectProductFor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: Dimensions.dimensionNo8,
          ),
          child: Text(
            "Product For",
            style: TextStyle(
              color: const Color(0xFF0F1419),
              fontSize: Dimensions.dimensionNo16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widgetProductSelectFor(
                textProductFor: GlobalVariable.forMale,
                onPressed: () {
                  setState(() {
                    _productFor = GlobalVariable.forMale;
                  });
                }),
            widgetProductSelectFor(
                textProductFor: GlobalVariable.forFemale,
                onPressed: () {
                  setState(() {
                    _productFor = GlobalVariable.forFemale;
                  });
                }),
            widgetProductSelectFor(
                textProductFor: GlobalVariable.forUnisex,
                onPressed: () {
                  setState(() {
                    _productFor = GlobalVariable.forUnisex;
                  });
                }),
          ],
        )
      ],
    );
  }

  CupertinoButton widgetProductSelectFor({
    required String textProductFor,
    required Function()? onPressed,
  }) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.dimensionNo8,
            horizontal: Dimensions.dimensionNo16),
        decoration: textProductFor == _productFor
            ? BoxDecoration(
                color: AppColor.buttonColor,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              )
            : BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
        child: Text(
          textProductFor,
          style: TextStyle(
            color: textProductFor == _productFor
                ? Colors.white
                : const Color(0xFF0F1419),
            fontSize: Dimensions.dimensionNo14,
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
      ),
    );
  }
}
