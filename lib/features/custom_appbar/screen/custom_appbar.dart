import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/custom_appbar/res_widget/mobileapp_bar.dart';
import 'package:samay_admin_plan/features/custom_appbar/res_widget/webapp_bar.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

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
