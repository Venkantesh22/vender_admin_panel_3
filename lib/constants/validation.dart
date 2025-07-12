//! no Validates
String? nodValidator(value) {
  return null;
}

//! Validates the name of a Brand Name
String? addNewBrandValidator(value) {
  if (value == null || value.trim().isEmpty) {
    return 'Brand name is required';
  }
  if (value.trim().length < 2) {
    return 'Brand name must be at least 2 characters';
  }
  return null;
}

//! Validates the name of a Brand product category name
String? addNewProductCateValidator(value) {
  if (value == null || value.trim().isEmpty) {
    return 'category name is required';
  }
  if (value.trim().length < 2) {
    return 'category name must be at least 2 characters';
  }
  return null;
}

//! Validates the Order of a Brand product category name
String? addOrderNumberValidator(value) {
  if (value == null || value.toString().trim().isEmpty) {
    return 'Order number is required';
  }
  final intValue = int.tryParse(value.toString().trim());
  if (intValue == null) {
    return 'Order number must be an number';
  }
  return null;
}

//!----------add product Validates the name of a Brand Name
// product name
String? addProductNameValidator(value) {
  if (value == null || value.trim().isEmpty) {
    return 'Product name is required';
  }
  if (value.trim().length < 2) {
    return 'Product name must be at least 2 characters';
  }
  return null;
}

// product description
String? addProductdescptValidator(value) {
  if (value == null || value.trim().isEmpty) {
    return 'Product description is required';
  }
  if (value.trim().length < 2) {
    return 'Product description must be at least 2 characters';
  }
  return null;
}

// product price
String? addProductPriceValidator(value) {
  if (value == null || value.toString().trim().isEmpty) {
    return 'price is required';
  }
  final intValue = int.tryParse(value.toString().trim());
  if (intValue == null) {
    return 'price must be a number';
  }
  return null;
}

// product category
String? selectProductCategoryValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please select a category';
  }
  return null;
}

// product select  category
String? selectProductSubCategoryValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please select a sub-category';
  }
  return null;
}

// product select  brand
String? selectProductBrandValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please select a brand';
  }
  return null;
}

// product select branch
String? selectProductBranchValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please select a branch';
  }
  return null;
}

// product price
String? addProductStockValidator(value) {
  if (value == null || value.toString().trim().isEmpty) {
    return 'Stock is required';
  }
  final intValue = int.tryParse(value.toString().trim());
  if (intValue == null) {
    return 'Stock must be a number';
  }
  return null;
}
