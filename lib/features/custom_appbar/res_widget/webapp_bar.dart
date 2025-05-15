import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Direct%20Billing/screen/direct_billing.dart';
import 'package:samay_admin_plan/features/custom_appbar/widget/appbar_item.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/reports_Section/report_dashboard/report_dashboard.dart';
import 'package:samay_admin_plan/features/service_view/screen/super_category.dart';
import 'package:samay_admin_plan/features/setting/setting_page.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

AppBar webAppBar(BuildContext context, AppProvider appProvider) {
  return AppBar(
    backgroundColor: AppColor.mainColor,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimenisonNo10,
        vertical: Dimensions.dimenisonNo10,
      ),
      child: Row(
        children: [
          GlobalVariable.samayLogo.isNotEmpty
              ? CupertinoButton(
                  onPressed: () {
                    // scaffoldKey.currentState?.openDrawer();
                  },
                  child: Image.asset(
                    GlobalVariable.samayLogo,
                    height: Dimensions.dimenisonNo40,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image, // User icon in case of error
                      size: Dimensions
                          .dimenisonNo60, // Set the size of the icon (adjust as needed)
                      color: Colors
                          .grey, // Set the color of the icon (adjust as needed)
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          SizedBox(width: Dimensions.dimenisonNo20),
          Container(
            width: 3,
            height: Dimensions.dimenisonNo40,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(width: Dimensions.dimenisonNo20),
          Appbaritem(
            text: "Calendar",
            ontap: () {
              Routes.instance.push(
                  widget: HomeScreen(
                    date: Provider.of<CalenderProvider>(context, listen: false)
                        .getSelectDate,
                  ),
                  context: context);
            },
          ),
          SizedBox(width: Dimensions.dimenisonNo20),
          Appbaritem(
            text: "Services",
            ontap: () {
              Routes.instance
                  .push(widget: SuperCategoryPage(), context: context);
            },
          ),
          SizedBox(width: Dimensions.dimenisonNo20),
          Appbaritem(
            text: "Reports",
            ontap: () {
              Routes.instance.push(widget: ReportDashboard(), context: context);
            },
          ),
          const Spacer(),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon:
                  const Icon(FontAwesomeIcons.fileInvoice, color: Colors.black),
              onPressed: () {
                Routes.instance.push(
                  widget: DirectBillingScreen(
                      salonModel: appProvider.getSalonInformation),
                  context: context,
                );
                // Handle invoice button press
              },
            ),
          ),
          SizedBox(width: Dimensions.dimenisonNo20),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {
                Routes.instance.push(widget: SettingsPage(), context: context);
              },
            ),
          ),
          SizedBox(width: Dimensions.dimenisonNo20),
          Container(
            width: 3,
            height: Dimensions.dimenisonNo40,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.dimenisonNo20),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                appProvider.getAdminInformation.image ??
                    'https://via.placeholder.com/150',
              ),
              radius: Dimensions.dimenisonNo20,
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading error here
                print("Image load error: $exception");
              },
            ),
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appProvider.getAdminInformation.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.dimenisonNo16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.dimenisonNo5,
                  ),
                  Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.dimenisonNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
