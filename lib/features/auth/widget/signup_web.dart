// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/screen/account_create_form.dart';
import 'package:samay_admin_plan/features/auth/login.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

Center signUpWebWidget(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController mobileController,
    TextEditingController passwordController,
    Uint8List? selectedImage,
    VoidCallback chooseImages) {
  return Center(
    child: Container(
      margin: EdgeInsets.all(Dimensions.dimensionNo30),
      padding: EdgeInsets.all(Dimensions.dimensionNo20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimensionNo20,
                vertical: Dimensions.dimensionNo10),
            decoration: BoxDecoration(
                color: AppColor.bgForAdminCreateSec,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(Dimensions.dimensionNo20)),
            width: Dimensions.dimensionNo400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create an Admin Login',
                  style: TextStyle(
                    color: AppColor.createText,
                    fontSize: Dimensions.dimensionNo24,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: Dimensions.dimensionNo5),
                selectedImage == null
                    ? InkWell(
                        onTap: () {
                          chooseImages();
                          // print("icon $selectedImage");
                        },
                        child: Container(
                          width: Dimensions.dimensionNo70,
                          height: Dimensions.dimensionNo70,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: CircleAvatar(
                              radius: Dimensions.dimensionNo36,
                              child: const Icon(Icons.camera_alt)),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          chooseImages();
                          print("image $selectedImage");
                        },
                        child: Container(
                          width: Dimensions.dimensionNo70,
                          height: Dimensions.dimensionNo70,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Image.memory(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )),
                SizedBox(height: Dimensions.dimensionNo10),
                CustomTextField(
                    controller: nameController,
                    obscureForPassword: false,
                    keyboardType: TextInputType.name,
                    label: "Name"),
                SizedBox(height: Dimensions.dimensionNo10),
                CustomTextField(
                    controller: emailController,
                    obscureForPassword: false,
                    keyboardType: TextInputType.emailAddress,
                    label: "Email"),
                SizedBox(height: Dimensions.dimensionNo10),
                CustomTextField(
                    controller: mobileController,
                    obscureForPassword: false,
                    keyboardType: TextInputType.number,
                    label: "Mobile Number"),
                SizedBox(height: Dimensions.dimensionNo10),
                CustomTextField(
                    controller: passwordController,
                    obscureForPassword: true,
                    keyboardType: TextInputType.name,
                    label: "Password"),
                SizedBox(height: Dimensions.dimensionNo10),

                CustomAuthButton(
                  text: "Sign Up",
                  ontap: () async {
                    // 1️⃣ Check image first
                    if (selectedImage == null || selectedImage.isEmpty) {
                      showBottomMessageError(
                          "Please select a profile image", context);
                      return;
                    }

                    // 2️⃣ Now validate inputs (passing non-null image)
                    bool isValidated = signUpVaildation(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      nameController.text.trim(),
                      mobileController.text.trim(),
                      selectedImage,
                    );
                    if (!isValidated) {
                      // assume signUpValidation shows its own errors
                      return;
                    }

                    // 3️⃣ Attempt signup
                    bool isSignedUp = await FirebaseAuthHelper.instance.signUp(
                      nameController.text.trim(),
                      mobileController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      selectedImage,
                      context,
                    );
                    if (isSignedUp) {
                      Routes.instance.pushAndRemoveUntil(
                        widget: const AccountCreateForm(),
                        context: context,
                      );
                    }
                  },
                ),
                // SizedBox(height: Dimensions.dimensionNo10),
                InkWell(
                  onTap: () {
                    Routes.instance
                        .push(widget: const LoginScreen(), context: context);
                  },
                  child: Text(
                    'Alread have an account? Login',
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
                )
              ],
            ),
          ),
          SizedBox(
            width: Dimensions.dimensionNo60,
          ),
          Column(
            children: [
              Text(
                'Main hu Samay,                     ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimensionNo30,
                  fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
              ),
              Text(
                '      mere Sath chalo.!',
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
                      : const Center(child: CircularProgressIndicator())),
            ],
          )
        ],
      ),
    ),
  );
}
