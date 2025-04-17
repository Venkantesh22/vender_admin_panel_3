import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/popup/add_new_category.dart';
import 'package:samay_admin_plan/features/services_page/widget/category_button.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/add_button.dart';

Drawer cateDrawer(
  double drawerWidth,
  BuildContext context,
  ServiceProvider serviceProvider,
  bool isLoading,
) {
  return Drawer(
    child: Container(
      width: drawerWidth,
      color: const Color.fromARGB(255, 55, 54, 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top header with title and close icon
          SizedBox(
            height: Dimensions.dimenisonNo8,
          ),
          // Add Category Button
          AddButton(
            text: "Add Category",
            bgColor: Colors.white,
            textColor: Colors.black,
            iconColor: Colors.black,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AddNewCategory(),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo5,
              vertical: Dimensions.dimenisonNo10,
            ),
            child: Center(
              child: Text(
                serviceProvider.getSelectSuperCategoryModel!.superCategoryName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.dimenisonNo24,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.dimenisonNo10),
            child: const Divider(color: Colors.white),
          ),
          Expanded(
            child: Consumer<ServiceProvider>(
              builder: (context, serviceProvider, child) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (serviceProvider.getCategoryList.isEmpty) {
                  return const Center(
                      child: Text("No Category",
                          style: TextStyle(color: Colors.white)));
                }
                if (serviceProvider.selectedCategory == null) {
                  serviceProvider
                      .selectCategory(serviceProvider.getCategoryList.first);
                }
                return ListView.builder(
                  itemCount: serviceProvider.getCategoryList.length,
                  itemBuilder: (context, index) {
                    CategoryModel categoryModel =
                        serviceProvider.getCategoryList[index];
                    return CatergryButton(
                      text: categoryModel.categoryName,
                      isSelected: serviceProvider.selectedCategory?.id ==
                          categoryModel.id,
                      onTap: () {
                        serviceProvider.selectCategory(categoryModel);
                        Navigator.of(context).pushNamed(
                          '/services_list',
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
