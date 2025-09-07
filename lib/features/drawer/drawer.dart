import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/add_new_appointment/screen/add_new_appointment.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/product/screen/product_screen.dart';
import 'package:samay_admin_plan/features/reports_Section/report_dashboard/report_dashboard.dart';
import 'package:samay_admin_plan/features/service_view/screen/super_category.dart';
import 'package:samay_admin_plan/features/setting/setting_page.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

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
            leading: const Icon(Icons.calendar_today),
            title: const Text("Calendar"),
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
            leading: const Icon(Icons.design_services),
            title: const Text("Services"),
            onTap: () {
              Routes.instance.push(
                widget: const SuperCategoryPage(),
                context: context,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Reports"),
            onTap: () {
              Routes.instance.push(
                widget: const ReportDashboard(),
                context: context,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits_rounded),
            title: const Text("Product"),
            onTap: () {
              Routes.instance.push(
                widget: const ProductScreen(),
                context: context,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Routes.instance.push(
                widget: const SettingsPage(),
                context: context,
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.fileInvoice),
            title: const Text("Quick Billing"),
            onTap: () {
              // Routes.instance.push(
              //   widget: DirectBillingScreen(
              //       salonModel: appProvider.getSalonInformation),
              //   context: context,
              // );
              Routes.instance.push(
                  widget: AddNewAppointment(
                      isDirectBilling: true,
                      salonModel: appProvider.getSalonInformation),
                  context: context);
            },
          ),
        ],
      ),
    );
  }
}
