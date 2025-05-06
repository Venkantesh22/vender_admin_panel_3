import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/custom_appbar/res_widget/mobileapp_bar.dart';
import 'package:samay_admin_plan/features/custom_appbar/res_widget/webapp_bar.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    if (appProvider.getAdminInformation == null ||
        appProvider.getSalonInformation == null) {
      return const SizedBox
          .shrink(); // Return empty widget if data is not available
    }

    return ResponsiveLayout(
      mobile: MobileAppBar(
        scaffoldKey: scaffoldKey,
      ),
      desktop: webAppBar(
        context,
        appProvider,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
