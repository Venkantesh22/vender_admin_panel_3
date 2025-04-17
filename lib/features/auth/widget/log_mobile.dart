import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/auth/singup.dart';
import 'package:samay_admin_plan/features/home/screen/loading_home_page/loading_home_page.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

Center logMobileWidget(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController) {
  // Determine screen size
  final isTablet = MediaQuery.of(context).size.width > 600;

  return Center(
    child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(Dimensions.dimenisonNo20),
        padding: EdgeInsets.all(Dimensions.dimenisonNo20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Admin Login',
              style: TextStyle(
                color: AppColor.createText,
                fontSize: isTablet ? 28 : Dimensions.dimenisonNo24,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo20),

            // Logo
            Container(
              height: isTablet
                  ? Dimensions.dimenisonNo100
                  : Dimensions.dimenisonNo80,
              width: isTablet
                  ? Dimensions.dimenisonNo100
                  : Dimensions.dimenisonNo80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.dimenisonNo18),
              ),
              child: GlobalVariable.samayLogo.isNotEmpty
                  ? Image.asset(
                      GlobalVariable.samayLogo,
                      height: Dimensions.dimenisonNo40,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        size: Dimensions.dimenisonNo60,
                        color: Colors.grey,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: Dimensions.dimenisonNo20),

            // Email TextField
            CustomTextField(
              controller: emailController,
              obscureForPassword: false,
              keyboardType: TextInputType.emailAddress,
              label: "Email",
            ),
            SizedBox(height: Dimensions.dimenisonNo10),

            // Password TextField
            CustomTextField(
              controller: passwordController,
              obscureForPassword: true,
              keyboardType: TextInputType.name,
              label: "Password",
            ),
            SizedBox(height: Dimensions.dimenisonNo20),

            // Login Button
            CustomAuthButton(
              text: "Login",
              ontap: () async {
                bool isVaildated = loginVaildation(
                    emailController.text, passwordController.text);

                if (isVaildated) {
                  bool isLogined = await FirebaseAuthHelper.instance.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      context);
                  if (isLogined) {
                    Routes.instance.pushAndRemoveUntil(
                        widget: LoadingHomePage(), context: context);
                  }
                }
              },
            ),
            SizedBox(height: Dimensions.dimenisonNo20),

            // Signup Link
            InkWell(
              onTap: () {
                print("Navigating to signup page...");
                Routes.instance
                    .push(widget: const SingupScreen(), context: context);
              },
              child: Text(
                'Not registered yet?',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet
                      ? Dimensions.dimenisonNo18
                      : Dimensions.dimenisonNo16,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  letterSpacing: 0.15,
                ),
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo20),

            // Tagline
            Text(
              'Main hu Samay, mere Sath chalo.!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: isTablet
                    ? Dimensions.dimenisonNo22
                    : Dimensions.dimenisonNo20,
                fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo20),

            // Cartoon Image
            GlobalVariable.samayCartoon.isNotEmpty
                ? Image.asset(
                    GlobalVariable.samayCartoon,
                    height: isTablet
                        ? Dimensions.dimenisonNo250
                        : Dimensions.dimenisonNo200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: Dimensions.dimenisonNo60,
                      color: Colors.grey,
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    ),
  );
}
