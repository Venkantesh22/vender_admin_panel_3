// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/popup/add_new_super_category.dart';
import 'package:samay_admin_plan/features/service_view/widget/super_cate_image.dart';
import 'package:samay_admin_plan/features/services_page/screen/services_page.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/super_cate/super_cate.dart';
import 'package:samay_admin_plan/one_time_run_function/initialize_default_category.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/samay_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/add_button.dart';

class SuperCategoryPage extends StatefulWidget {
  const SuperCategoryPage({super.key});

  @override
  State<SuperCategoryPage> createState() => _SuperCategoryPageState();
}

class _SuperCategoryPageState extends State<SuperCategoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  void getDate() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    SamayProvider samayProvider =
        Provider.of<SamayProvider>(context, listen: false);
    await serviceProvider.callBackFunction(appProvider.getSalonInformation.id);

    if (appProvider.getSalonInformation.isDefaultCategoryCreate == true &&
        samayProvider.getSupetCateImageList.isEmpty) {
      print("get all Image");
      samayProvider.callbackSamayPro();
    }

    setState(() {
      isLoading = false;
    });

    // Select the first category by default after data is loaded
    if (appProvider.getSalonInformation.isDefaultCategoryCreate) {
      if (serviceProvider.getCategoryList.isNotEmpty) {
        serviceProvider.selectCategory(serviceProvider.getCategoryList[0]);
      }
    }
  }

  @override
  void initState() {
    getDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    AppProvider appProvider = Provider.of<AppProvider>(context);
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    SamayProvider samayProvider = Provider.of<SamayProvider>(context);

    return appProvider.getSalonInformation.isDefaultCategoryCreate
        ? isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
                drawer: MobileDrawer(),
                key: _scaffoldKey,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.dimenisonNo8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AddButton(
                              text: "Super Category",
                              onTap: () {
                                // Use showDialog to display the AddNewSuperCategory widget
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const AddNewSuperCategory(),
                                );
                              },
                            )
                          ],
                        ),
                        SizedBox(height: Dimensions.dimenisonNo8),
                        Text(
                          "Super Category",
                          style: TextStyle(
                            fontSize: Dimensions.dimenisonNo20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        // Wrap ListView.builder in a SizedBox with a fixed height
                        SizedBox(
                          height: ResponsiveLayout.isMoAndTab(context)
                              ? MediaQuery.of(context).size.height / 1.3
                              : MediaQuery.of(context).size.height /
                                  1.5, // Adjust the height as needed
                          child: Consumer<ServiceProvider>(
                            builder: (context, serviceProvider, child) {
                              // Define the desired order for the super categories.
                              List<String> desiredOrder = [
                                GlobalVariable.supCatHair,
                                GlobalVariable.supCatSkin,
                                GlobalVariable.supCatManiPedi,
                                GlobalVariable.supCatNail,
                                GlobalVariable.supCatMakeUp,
                                GlobalVariable.supCatMassage,
                                GlobalVariable.supCatOther,
                              ];

                              // Create a sorted copy of the super category list.
                              List<SuperCategoryModel> sortedCategories =
                                  serviceProvider.getSuperCategoryList.toList();
                              sortedCategories.sort((a, b) {
                                int indexA =
                                    desiredOrder.indexOf(a.superCategoryName);
                                int indexB =
                                    desiredOrder.indexOf(b.superCategoryName);
                                if (indexA == -1) {
                                  indexA = desiredOrder.length + 1;
                                }
                                if (indexB == -1) {
                                  indexB = desiredOrder.length + 1;
                                }
                                return indexA.compareTo(indexB);
                              });

                              return ResponsiveLayout.isMoAndTab(context)
                                  ? LayoutBuilder(
                                      builder: (context, constraints) {
                                        // Define the desired item width
                                        const double itemWidth = 200.0;

                                        // Calculate the number of columns based on the available width
                                        int crossAxisCount =
                                            (constraints.maxWidth / itemWidth)
                                                .floor();

                                        // Ensure at least 1 column
                                        crossAxisCount = crossAxisCount > 0
                                            ? crossAxisCount
                                            : 1;

                                        return GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio:
                                                1, // Adjust the aspect ratio as needed
                                          ),
                                          itemCount: sortedCategories.length,
                                          itemBuilder: (context, index) {
                                            SuperCategoryModel cate =
                                                sortedCategories[index];
                                            return CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                serviceProvider
                                                    .selectSuperCatePro(cate);
                                                Routes.instance.push(
                                                  widget: ServicesPages(),
                                                  context: context,
                                                );
                                              },
                                              child: SuperCateImage(
                                                  superCategoryModel: cate),
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: sortedCategories.length,
                                      itemBuilder: (context, index) {
                                        SuperCategoryModel cate =
                                            sortedCategories[index];
                                        return CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            serviceProvider
                                                .selectSuperCatePro(cate);
                                            Routes.instance.push(
                                              widget: ServicesPages(),
                                              context: context,
                                            );
                                          },
                                          child: SuperCateImage(
                                            superCategoryModel: cate,
                                          ),
                                        );
                                      },
                                    );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
        : Container(
            color: const Color.fromARGB(255, 55, 54, 54),
            child: Center(
              child: AddButton(
                text: "Create Service",
                bgColor: Colors.white,
                textColor: Colors.black,
                onTap: () async {
                  try {
                    await samayProvider.getSuperCateImagePro();
                    await samayProvider.setImagePro();
                    showLoaderDialog(context);

                    // Update isDefaultCategoryCreate to true in Firebase
                    SalonModel salonModel =
                        appProvider.getSalonInformation.copyWith(
                      isDefaultCategoryCreate: true,
                    );

                    appProvider.updateSalonInfoFirebase(context, salonModel);
                    InitializeDefaultCategory.instance
                        .createDefaultSuperCategory(
                            context, serviceProvider, appProvider);
                    InitializeDefaultCategory.instance.createDefaultCategory(
                        context, serviceProvider, appProvider);
                    await Future.delayed(const Duration(seconds: 3));
                    Navigator.of(context, rootNavigator: true).pop();

                    showMessage("Default categories are added");
                  } catch (e) {
                    showMessage("Error: Default categories are not created");
                  }
                },
              ),
            ),
          );
  }
}
