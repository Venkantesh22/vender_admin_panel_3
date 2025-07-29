import 'package:samay_admin_plan/models/Product/product_branch_model.dart/product_branch_model.dart';
import 'package:samay_admin_plan/models/Product/product_sub_category_model/product_sub_category_model.dart';

class BranchModelFilter {
  final ProductSubCateModel productSubCateModel;
  final List<ProductBranchModel> productBranchModelList;

  BranchModelFilter({
    required this.productSubCateModel,
    required this.productBranchModelList,
  });
}
