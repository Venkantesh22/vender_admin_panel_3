// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/auth/widget/log_web.dart';
import 'package:samay_admin_plan/features/auth/widget/log_mobile.dart';
import 'package:samay_admin_plan/utility/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _isLoading ? AppColor.whileColor : AppColor.bgForAuth,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ResponsiveLayout(
                mobile: logMobileWidget(
                    context, _emailController, _passwordController),
                desktop: logWebWidget(
                    context, _emailController, _passwordController),
              ));
  }
}
