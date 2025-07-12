// Placeholder for the "Support" page
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/setting/widget/heading_text_of_page.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.bgForAdminCreateSec,
        child: Center(
          child: Container(
            margin: ResponsiveLayout.isMobile(context)
                ? EdgeInsets.symmetric(
                    horizontal: Dimensions.dimensionNo12,
                  )
                : ResponsiveLayout.isTablet(context)
                    ? EdgeInsets.symmetric(
                        horizontal: Dimensions.dimensionNo60,
                      )
                    : null,
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimensionNo10
                    : Dimensions.dimensionNo30,
                vertical: Dimensions.dimensionNo20),
            // color: Colors.green,
            color: Colors.white,
            width: ResponsiveLayout.isDesktop(context)
                ? Dimensions.screenWidth / 1.5
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: headingTextOFPage(
                    context,
                    'Contact Us',
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: Dimensions.dimensionNo10),
                  child: const Divider(),
                ),
                Text(
                  'Contact Us : ${GlobalVariable.customerNo}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo14
                        : Dimensions.dimensionNo18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(
                  height: Dimensions.dimensionNo12,
                ),
                Text(
                  'Email ID :  ${GlobalVariable.customerGmail}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo14
                        : Dimensions.dimensionNo18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.15,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
