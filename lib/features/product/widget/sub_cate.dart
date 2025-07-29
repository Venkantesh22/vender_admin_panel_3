import 'package:samay_admin_plan/models/Product/product%20category%20model/product_category_model.dart';
import 'package:samay_admin_plan/models/Product/product_sub_category_model/product_sub_category_model.dart';

class SubCateFilter {
  final BrandCategoryModel brandCategoryModel;
  final List<ProductSubCateModel> subCateList;

  SubCateFilter({
    required this.brandCategoryModel,
    required this.subCateList,
  });
}
