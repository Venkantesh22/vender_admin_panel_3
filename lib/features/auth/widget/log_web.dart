import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/auth/singup.dart';
import 'package:samay_admin_plan/features/home/screen/loading_home_page/loading_home_page.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class LogWebWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LogWebWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LogWebWidget> createState() => _LogWebWidgetState();
}

class _LogWebWidgetState extends State<LogWebWidget> {
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(Dimensions.dimensionNo30),
        padding: EdgeInsets.all(Dimensions.dimensionNo20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
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
                  horizontal: Dimensions.dimensionNo20,
                  vertical: Dimensions.dimensionNo10),
              decoration: BoxDecoration(
                color: AppColor.bgForAdminCreateSec,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(Dimensions.dimensionNo20),
              ),
              width: Dimensions.dimensionNo400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Admin Login',
                    style: TextStyle(
                      color: AppColor.createText,
                      fontSize: Dimensions.dimensionNo24,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Dimensions.dimensionNo20),
                  Container(
                    height: Dimensions.dimensionNo80,
                    width: Dimensions.dimensionNo80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.dimensionNo18),
                    ),
                    child: GlobalVariable.samayLogo.isNotEmpty
                        ? Image.asset(
                            GlobalVariable.samayLogo,
                            height: Dimensions.dimensionNo40,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: Dimensions.dimensionNo60,
                              color: Colors.grey,
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(height: Dimensions.dimensionNo20),
                  CustomTextField(
                    controller: widget.emailController,
                    obscureForPassword: false,
                    keyboardType: TextInputType.emailAddress,
                    label: "Email",
                  ),
                  SizedBox(height: Dimensions.dimensionNo10),
                  CustomTextField(
                    controller: widget.passwordController,
                    obscureForPassword: true,
                    keyboardType: TextInputType.text,
                    label: "Password",
                  ),
                  SizedBox(height: Dimensions.dimensionNo20),
                  _isLoading
                      ? const CircularProgressIndicator() // Show loading indicator
                      : CustomAuthButton(
                          text: "Login",
                          ontap: () async {
                            setState(() {
                              _isLoading = true; // Start loading
                            });

                            bool isValidated = loginVaildation(
                                widget.emailController.text,
                                widget.passwordController.text);

                            if (isValidated) {
                              bool isLoggedIn =
                                  await FirebaseAuthHelper.instance.login(
                                widget.emailController.text.trim(),
                                widget.passwordController.text.trim(),
                                context,
                              );
                              if (isLoggedIn) {
                                Routes.instance.pushAndRemoveUntil(
                                  widget: const LoadingHomePage(),
                                  context: context,
                                );
                              }
                            }

                            setState(() {
                              _isLoading = false; // Stop loading
                            });
                          },
                        ),
                  SizedBox(height: Dimensions.dimensionNo20),
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
                        fontSize: Dimensions.dimensionNo16,
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
            SizedBox(width: Dimensions.dimensionNo60),
            // Right Section: Illustration or Branding
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Main hu Samay,',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimensionNo30,
                    fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15,
                  ),
                ),
                Text(
                  'mere Sath chalo.!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimensionNo30,
                    fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15,
                  ),
                ),
                Expanded(
                  child: GlobalVariable.samayCartoon.isNotEmpty
                      ? Image.asset(
                          GlobalVariable.samayCartoon,
                          height: Dimensions.dimensionNo400,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            size: Dimensions.dimensionNo60,
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
}
