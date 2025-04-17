import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/services_page/screen/category_drawer.dart';
import 'package:samay_admin_plan/features/services_page/screen/services_list.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';

class ServicesPages extends StatefulWidget {
  const ServicesPages({
    Key? key,
  }) : super(key: key);

  @override
  State<ServicesPages> createState() => _ServicesPagesState();
}

class _ServicesPagesState extends State<ServicesPages> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpened = false; // To ensure the drawer opens only once

  void openDrawer() {
    if (ResponsiveLayout.isMoAndTab(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState?.openDrawer();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Open the drawer only once when the widget is first built
    if (!_isDrawerOpened) {
      openDrawer();
      _isDrawerOpened = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    // Calculate responsive drawer width.
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth =
        screenWidth < 600 ? screenWidth * 0.9 : 250.0; // Adjust as needed

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CatergoryDrawer(
        superCategoryName:
            serviceProvider.getSelectSuperCategoryModel!.superCategoryName,
        //serviceProvider.getSelectSuperCategoryModel!.superCategoryName,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(scaffoldKey: _scaffoldKey),
      ),
      body: ResponsiveLayout(
        mobile: servicePageMobTab(drawerWidth, serviceProvider),
        desktop: servicePageWeb(drawerWidth, serviceProvider),
      ),
    );
  }

  Widget servicePageWeb(double drawerWidth, ServiceProvider serviceProvider) {
    return Row(
      children: [
        // Persistent side panel for categories.
        SizedBox(
          width: drawerWidth,
          child: CatergoryDrawer(
            superCategoryName:
                serviceProvider.getSelectSuperCategoryModel!.superCategoryName,
          ),
        ),
        // Expanded space for the services list.
        Expanded(
          child: serviceProvider.getCategoryList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : Navigator(
                  onGenerateRoute: (settings) {
                    if (settings.name == '/services_list') {
                      return MaterialPageRoute(
                        builder: (context) => ServicesList(
                          superCategoryName: serviceProvider
                              .getSelectSuperCategoryModel!.superCategoryName,
                        ),
                      );
                    }
                    return null;
                  },
                  initialRoute: '/services_list',
                  onUnknownRoute: (settings) => MaterialPageRoute(
                    builder: (context) => ServicesList(
                      superCategoryName: serviceProvider
                          .getSelectSuperCategoryModel!.superCategoryName,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget servicePageMobTab(
      double drawerWidth, ServiceProvider serviceProvider) {
    return serviceProvider.getCategoryList.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        : Navigator(
            onGenerateRoute: (settings) {
              if (settings.name == '/services_list') {
                return MaterialPageRoute(
                  builder: (context) => ServicesList(
                    superCategoryName: serviceProvider
                        .getSelectSuperCategoryModel!.superCategoryName,
                  ),
                );
              }
              return null;
            },
            initialRoute: '/services_list',
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => ServicesList(
                superCategoryName: serviceProvider
                    .getSelectSuperCategoryModel!.superCategoryName,
              ),
            ),
          );
  }
}
