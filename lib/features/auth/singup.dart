// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/auth/widget/signup_mobile.dart';
import 'package:samay_admin_plan/features/auth/widget/signup_web.dart';
import 'package:samay_admin_plan/utility/color.dart';

class SingupScreen extends StatefulWidget {
  const SingupScreen({super.key});

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Uint8List? selectedImage;

  chooseImages() async {
    FilePickerResult? chosenImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      selectedImage = chosenImageFile!.files.single.bytes;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bgForAuth,
        body: ResponsiveLayout(
          mobile: signUpMobileWidget(
              context,
              _nameController,
              _emailController,
              _mobileController,
              _passwordController,
              selectedImage,
              chooseImages),
          desktop: signUpWebWidget(
              context,
              _nameController,
              _emailController,
              _mobileController,
              _passwordController,
              selectedImage,
              chooseImages),
        ));
  }
}
