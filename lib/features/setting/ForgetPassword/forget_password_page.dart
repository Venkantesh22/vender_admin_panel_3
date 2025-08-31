import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/setting/widget/heading_text_of_page.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

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
                    'Forget Password',
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: Dimensions.dimensionNo10),
                  child: const Divider(),
                ),
                Text(
                  'Enter your registered email address',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo14
                        : Dimensions.dimensionNo18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(height: Dimensions.dimensionNo10),
                FormCustomTextField(
                  controller: _emailController,
                  title: "Email",
                ),
                SizedBox(height: Dimensions.dimensionNo10),
                CustomAuthButton(
                  text: "Send Email",
                  ontap: () async {
                    String userEmail = appProvider.getAdminInformation.email;
                    bool isVaildated = emailVaildation(
                      _emailController.text,
                    );

                    if (isVaildated) {
                      if (userEmail == _emailController.text.trim()) {
                        FirebaseAuthHelper.instance
                            .resetPassword(_emailController.text.trim());
                      } else {
                        showMessage(" Invalid email.");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
