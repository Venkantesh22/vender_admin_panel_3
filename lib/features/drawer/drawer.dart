import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Direct%20Billing/screen/direct_billing.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/reports_Section/report_dashboard/report_dashboard.dart';
import 'package:samay_admin_plan/features/service_view/screen/super_category.dart';
import 'package:samay_admin_plan/features/setting/setting_page.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class MobileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColor.mainColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    Provider.of<AppProvider>(context, listen: false)
                            .getAdminInformation
                            .image ??
                        'https://via.placeholder.com/150',
                  ),
                  radius: Dimensions.dimensionNo30,
                  onBackgroundImageError: (exception, stackTrace) {
                    debugPrint("Image load error: $exception");
                  },
                ),
                SizedBox(height: Dimensions.dimensionNo10),
                Text(
                  Provider.of<AppProvider>(context, listen: false)
                      .getAdminInformation
                      .name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.dimensionNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Calendar"),
            onTap: () {
              Routes.instance.push(
                widget: HomeScreen(
                  date: Provider.of<CalenderProvider>(context, listen: false)
                      .getSelectDate,
                ),
                context: context,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.design_services),
            title: Text("Services"),
            onTap: () {
              Routes.instance.push(
                widget: SuperCategoryPage(),
                context: context,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text("Reports"),
            onTap: () {
              Routes.instance.push(
                widget: ReportDashboard(),
                context: context,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Routes.instance.push(
                widget: SettingsPage(),
                context: context,
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.fileInvoice),
            title: const Text("Quick Billing"),
            onTap: () {
              Routes.instance.push(
                widget: DirectBillingScreen(
                    salonModel: appProvider.getSalonInformation),
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
