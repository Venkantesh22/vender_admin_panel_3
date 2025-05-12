// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/popup/edit_category.dart';
import 'package:samay_admin_plan/features/service_view/screen/add_service_form.dart';
import 'package:samay_admin_plan/features/service_view/screen/single_service_tap.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/add_button.dart';

class ServicesList extends StatefulWidget {
  String? superCategoryName;
  ServicesList({
    super.key,
    this.superCategoryName,
  });

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final selectedCategory = serviceProvider.selectedCategory;

    if (selectedCategory == null) {
      return const Center(child: Text('No category selected'));
    }

    return Scaffold(
      body: appProvider.getSalonInformation.isDefaultCategoryCreate
          ? serviceProvider.getCategoryList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : serviceListWeb(
                  selectedCategory,
                  context,
                  serviceProvider,
                  appProvider,
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Container serviceListWeb(
    CategoryModel selectedCategory,
    BuildContext context,
    ServiceProvider serviceProvider,
    AppProvider appProvider,
  ) {
    void deleteCategory() async {
      showDeleteAlertDialog(context, "Delete Category",
          "Do you want to delete ${selectedCategory.categoryName} category",
          () async {
        try {
          showLoaderDialog(context);
          await serviceProvider.deleteSingleCategoryPro(selectedCategory);
          Navigator.of(context, rootNavigator: true).pop();
          // Update Drawer
          await serviceProvider
              .callBackFunction(appProvider.getSalonInformation.id);

          await serviceProvider.getCategoryListPro(
            appProvider.getSalonInformation.id,
            serviceProvider.getSelectSuperCategoryModel!.superCategoryName,
          );

          // Select the first category by default after data is loaded
          if (serviceProvider.getCategoryList.isNotEmpty) {
            serviceProvider.selectCategory(serviceProvider.getCategoryList[0]);
          }

          Navigator.of(context, rootNavigator: true).pop();
          showMessage("Successfully deleted ${selectedCategory.categoryName}");
        } catch (e) {
          Navigator.of(
            context,
          ).pop();

          showMessage("Error not deleting ${selectedCategory.categoryName}");
        }
      });
    }

    return Container(
      padding: EdgeInsets.all(Dimensions.dimenisonNo10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    selectedCategory.categoryName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimenisonNo30,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                    ),
                  ),
                  const Spacer(),
                  ResponsiveLayout.isMobile(context)
                      ? PopupMenuButton<int>(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.black),
                          onSelected: (value) {
                            if (value == 0) {
                              // Edit Category
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return EditCategoryPopup(
                                    categoryModel: selectedCategory,
                                  );
                                },
                              );
                            } else if (value == 1) {
                              // Delete Category
                              deleteCategory();
                            } else if (value == 2) {
                              // Add Services
                              Routes.instance.push(
                                widget: AddServiceForm(
                                    categoryModel: selectedCategory),
                                context: context,
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(Icons.edit_square, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.add, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text("Add Services"),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return EditCategoryPopup(
                                      categoryModel: selectedCategory,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit_square,
                                color: Colors.black,
                              ),
                            ),

                            // Delete icon for delete category
                            IconButton(
                              onPressed: deleteCategory,
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            AddButton(
                              text: "Add Services",
                              onTap: () {
                                Routes.instance.push(
                                  widget: AddServiceForm(
                                      categoryModel: selectedCategory),
                                  context: context,
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
              Divider()
            ],
          ),

          // Services List
          Expanded(
              child: StreamBuilder<List<ServiceModel>>(
            stream: serviceProvider.getServicesListFirebase(
                appProvider.getSalonInformation.id, selectedCategory.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading Service'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Service found'));
              }

              // Convert serviceCode to int and sort the list
              List<ServiceModel> sortedData = List.from(snapshot.data!);
              sortedData.sort((a, b) {
                int serviceCodeA = int.tryParse(a.serviceCode) ??
                    0; // Default to 0 if parsing fails
                int serviceCodeB = int.tryParse(b.serviceCode) ??
                    0; // Default to 0 if parsing fails
                return serviceCodeA.compareTo(serviceCodeB);
              });

              return ListView.builder(
                itemCount: sortedData.length,
                itemBuilder: (context, index) {
                  ServiceModel serviceModel = sortedData[index];
                  return SingleServiceTap(
                    serviceModel: serviceModel,
                    categoryModel: selectedCategory,
                    index: index,
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
