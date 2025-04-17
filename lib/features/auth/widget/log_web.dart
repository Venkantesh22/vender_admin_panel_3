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

Center logWebWidget(BuildContext context, TextEditingController emailController,
    TextEditingController passwordController) {
  return Center(
    child: Container(
      margin: EdgeInsets.all(Dimensions.dimenisonNo30),
      padding: EdgeInsets.all(Dimensions.dimenisonNo20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left Section: Login Form
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimenisonNo20,
                vertical: Dimensions.dimenisonNo10),
            decoration: BoxDecoration(
              color: AppColor.bgForAdminCreateSec,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(Dimensions.dimenisonNo20),
            ),
            width: Dimensions.dimenisonNo400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Admin Login',
                  style: TextStyle(
                    color: AppColor.createText,
                    fontSize: Dimensions.dimenisonNo24,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: Dimensions.dimenisonNo20),
                Container(
                  height: Dimensions.dimenisonNo80,
                  width: Dimensions.dimenisonNo80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.dimenisonNo18),
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
                CustomTextField(
                  controller: emailController,
                  obscureForPassword: false,
                  keyboardType: TextInputType.emailAddress,
                  label: "Email",
                ),
                SizedBox(height: Dimensions.dimenisonNo10),
                CustomTextField(
                  controller: passwordController,
                  obscureForPassword: true,
                  keyboardType: TextInputType.text,
                  label: "Password",
                ),
                SizedBox(height: Dimensions.dimenisonNo20),
                CustomAuthButton(
                  text: "Login",
                  ontap: () async {
                    bool isValidated = loginVaildation(
                        emailController.text, passwordController.text);

                    if (isValidated) {
                      bool isLoggedIn = await FirebaseAuthHelper.instance.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          context);
                      if (isLoggedIn) {
                        Routes.instance.pushAndRemoveUntil(
                            widget: LoadingHomePage(), context: context);
                      }
                    }
                  },
                ),
                SizedBox(height: Dimensions.dimenisonNo20),
                InkWell(
                  onTap: () {
                    Routes.instance
                        .push(widget: const SingupScreen(), context: context);
                  },
                  child: Text(
                    'Not registered yet?',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimenisonNo16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimensions.dimenisonNo60),
          // Right Section: Illustration or Branding
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Main hu Samay,',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo30,
                  fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
              ),
              Text(
                'mere Sath chalo.!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo30,
                  fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
              ),
              // SizedBox(height: Dimensions.dimenisonNo10),
              Expanded(
                child: GlobalVariable.samayCartoon.isNotEmpty
                    ? Image.asset(
                        GlobalVariable.samayCartoon,
                        height: Dimensions.dimenisonNo400,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: Dimensions.dimenisonNo60,
                          color: Colors.grey,
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
