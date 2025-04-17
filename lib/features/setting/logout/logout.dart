import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/auth/login.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/custom_icon_text_button.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLogout = false;

    return Scaffold(
      body: Container(
        margin: ResponsiveLayout.isMobile(context)
            ? EdgeInsets.symmetric(
                horizontal: Dimensions.dimenisonNo12,
              )
            : ResponsiveLayout.isTablet(context)
                ? EdgeInsets.symmetric(
                    horizontal: Dimensions.dimenisonNo60,
                  )
                : null,
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimenisonNo10
                : Dimensions.dimenisonNo30,
            vertical: Dimensions.dimenisonNo20),
        // color: Colors.green,
        color: Colors.white,
        width: ResponsiveLayout.isDesktop(context)
            ? Dimensions.screenWidth / 1.5
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Do you want to log out of your account?",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimenisonNo14
                    : Dimensions.dimenisonNo18,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            SizedBox(height: Dimensions.dimenisonNo10),
            CustomIconTextButton(
                text: "Logout",
                onTap: () async {
                  isLogout = await FirebaseAuthHelper.instance.signOut();
                  if (isLogout) {
                    Routes.instance.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        widget: const LoginScreen(),
                        // ignore: use_build_context_synchronously
                        context: context);
                  }
                },
                buttonColor: AppColor.buttonColor,
                iconData: Icons.logout)
          ],
        ),
      ),
    );
  }
}
