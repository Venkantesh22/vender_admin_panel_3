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
import 'package:samay_admin_plan/constants/validation.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/Product/brand_model/brand_model.dart';
import 'package:samay_admin_plan/models/Product/product%20category%20model/product_category_model.dart';
import 'package:samay_admin_plan/models/Product/product_branch_model.dart/product_branch_model.dart';
import 'package:samay_admin_plan/models/Product/product_sub_category_model/product_sub_category_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/dropdownlist/dopdownlist.dart';
import 'package:samay_admin_plan/widget/text_box/validate_textbox_heading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
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
        _brandList = List.from(productProvider.getBrandList)
          ..sort((a, b) => a.order.compareTo(b.order));
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
        _subCategoryList = List.from(productProvider.getProductSubCategoryList)
          ..sort((a, b) => a.order.compareTo(b.order));
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
      _categoryList = List.from(productProvider.getProductCategoryList)
        ..sort((a, b) => a.order.compareTo(b.order));

      _discountPriceController.addListener(_updateDiscPerController);
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
      // drawer: MobileDrawer(),
      key: _scaffoldKey,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.dimensionNo20,
                  horizontal: Dimensions.dimensionNo160),
              child: Center(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // onChanged: () {
                  //   setState(() {});
                  // },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimensionNo8),
                        child: Row(
                          children: [
                            Text(
                              'Add New Product',
                              style: TextStyle(
                                color: const Color(0xFF0F1419),
                                fontSize: Dimensions.dimensionNo30,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
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
                      dropDownlist(
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
                          });
                          await getSubCategory(selectedModel.id);
                        },
                      ),

                      // Dropdown for Product For Subcategory

                      dropDownlist(
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
                          });
                          await getBranch(selectedSubCategoryModel.categoryId,
                              selectedSubCategoryModel.id);
                        },
                      ),
                      // Dropdown for Product For Subcategory branch

                      dropDownlist(
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
                          await getBrand();
                        },
                      ),

                      // Dropdown for Product For
                      selectProductFor(),

                      // Dropdown for Product For  brand
                      dropDownlist(
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
                          productProvider.updateSelectBrand(selectedBrandModel);
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
                          validator: nodValidator,
                          suffixWidget: const Icon(
                            Icons.percent,
                            color: Colors.black,
                          )),
                      validateTextBoxWithHeading(
                          hintText: "Product Code",
                          labelText: "Product Code",
                          controller: _productCodeController,
                          validator: nodValidator),

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
                          text: "Save",
                          ontap: () async {
                            try {
                              AppProvider appProvider =
                                  Provider.of<AppProvider>(context,
                                      listen: false);
                              ProductProvider productProvider =
                                  Provider.of<ProductProvider>(context,
                                      listen: false);
                              if (selectedImage == null) {
                                showBottomMessageError(
                                    'Please select an image for the Product.',
                                    context);

                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                showLoaderDialog(context);
                                TimeStampModel timeStampModel = TimeStampModel(
                                    id: "",
                                    dateAndTime: GlobalVariable.today,
                                    updateBy: "Vender");

                                ProductModel newProduct = ProductModel(
                                  id: "",
                                  name: _productNameController.text.trim(),
                                  description: _descripController.text.trim(),
                                  imgUrl: "",
                                  productFor: _productFor!,
                                  salonId: appProvider.getSalonInformation.id,
                                  adminId:
                                      appProvider.getSalonInformation.adminId,
                                  brandName:
                                      productProvider.getSelectBrandModel!.name,
                                  brandID:
                                      productProvider.getSelectBrandModel!.id,
                                  cateName: productProvider
                                      .getSelectBrandCategoryModel!.name,
                                  cateId: productProvider
                                      .getSelectBrandCategoryModel!.id,
                                  subCateName: productProvider
                                      .getSelectSubCategory!.name,
                                  subCateId:
                                      productProvider.getSelectSubCategory!.id,
                                  branchName: productProvider
                                      .getSelectProductBranchModel!.name,
                                  branchId: productProvider
                                      .getSelectProductBranchModel!.id,
                                  stockQuantity: int.tryParse(
                                      _stockQuantityController.text.trim())!,
                                  visibility: true,
                                  originalPrice: double.tryParse(
                                      _mRPPriceController.text.trim())!,
                                  discountPer: double.tryParse(
                                      _discountPerController.text.trim())!,
                                  discountPrice: double.tryParse(
                                      _discountPriceController.text.trim())!,
                                  timeStampModel: timeStampModel,
                                );

                                await productProvider.addNewProductPro(
                                    newProduct, selectedImage!);
                                showBottomMessage(
                                    "New Product  ${_productNameController.text.trim()} added! Successful",
                                    context);
                                Navigator.pop(context); // Close the dialog,
                              }
                            } catch (e) {
                              print("Error in save new Product $e");

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
            )),
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
                height:
                    Dimensions.dimensionNo250, // or any fixed height you want
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
                minHeight: Dimensions.dimensionNo250, // Fixed height
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
                children: selectedImage != null
                    ? [
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
                        ),
                      ]
                    : [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: Dimensions.dimensionNo480),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                'Upload Images',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0F1416),
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
                          margin:
                              EdgeInsets.only(top: Dimensions.dimensionNo12),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEAEDF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.dimensionNo20),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

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
