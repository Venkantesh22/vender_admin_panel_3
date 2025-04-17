import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/drawer/cate_drawer.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class CatergoryDrawer extends StatefulWidget {
  final String superCategoryName;
  const CatergoryDrawer({
    super.key,
    required this.superCategoryName,
  });

  @override
  State<CatergoryDrawer> createState() => _CatergoryDrawerState();
}

class _CatergoryDrawerState extends State<CatergoryDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  void getDate() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    await serviceProvider.callBackFunction(appProvider.getSalonInformation.id);
    await serviceProvider.getCategoryListPro(
        appProvider.getSalonInformation.id, widget.superCategoryName);
    setState(() {
      isLoading = false;
    });

    // Select the first category by default after data is loaded
    if (appProvider.getSalonInformation.isDefaultCategoryCreate &&
        serviceProvider.getCategoryList.isNotEmpty) {
      serviceProvider.selectCategory(serviceProvider.getCategoryList[0]);
    }
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive width:
    final screenWidth = MediaQuery.of(context).size.width;
    // For mobile use 90% of the width; for larger screens, use a fixed width
    final drawerWidth =
        screenWidth < 600 ? screenWidth * 0.9 : Dimensions.dimenisonNo250;

    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : cateDrawer(drawerWidth, context, serviceProvider, isLoading);
  }
}
