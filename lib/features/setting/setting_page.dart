// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/screen/form_weektime_screen.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/setting/ForgetPassword/forget_password_page.dart';
import 'package:samay_admin_plan/features/setting/about/about_us_page.dart';
import 'package:samay_admin_plan/features/setting/admin/admin_screen.dart';
import 'package:samay_admin_plan/features/setting/logout/logout.dart';
import 'package:samay_admin_plan/features/setting/message/message._setting.dart';
import 'package:samay_admin_plan/features/setting/setting_payment_page/setting_payment.dart';
import 'package:samay_admin_plan/features/setting/setting/verder_setting.dart';
import 'package:samay_admin_plan/features/setting/social_media/social_media.dart';
import 'package:samay_admin_plan/features/setting/support/support_page.dart';
import 'package:samay_admin_plan/features/setting/vender_profile/screen/vender_page.dart';
import 'package:samay_admin_plan/features/setting/week_time_edit/week_time_edit.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/features/drawer/setting_drawer.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  bool _isLoading = false;

  final List<String> _menuTitles = [
    'Salon Profile',
    'Admin Profile',
    'Week Time Schedule',
    'Social Media',
    'Setting',
    'Payment Details',
    'Messages',
    'About Us',
    'Contact Us',
    'Forget Password',
    'Logout',
  ];

  final List<IconData> _menuIcons = [
    Icons.person,
    Icons.admin_panel_settings,
    Icons.schedule,
    Icons.share,
    Icons.settings,
    Icons.payment,
    Icons.message,
    Icons.info,
    Icons.support_agent,
    Icons.lock_reset,
    Icons.logout,
  ];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final List<Widget> _pages = [
      const SalonProfilePage(),
      const AdminPage(),
      appProvider.getSalonInformation.monday!.isEmpty
          ? const FormTimeSection()
          : const WeekTimeEdit(),
      const SocialMediaPage(),
      const VerderSetting(),
      const PaymentSettingPage(),
      const SettingMessagePage(),
      const AboutUsPage(),
      const SupportPage(),
      const ForgetPassword(),
      const LogoutPage(),
    ];

    return Scaffold(
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      key: _scaffoldKey,
      drawer: ResponsiveLayout.isMoAndTab(context)
          ? SettingDrawer(
              menuTitles: _menuTitles,
              menuIcons: _menuIcons,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                ResponsiveLayout.isDesktop(context)
                    ? SettingDrawer(
                        menuTitles: _menuTitles,
                        menuIcons: _menuIcons,
                        selectedIndex: _selectedIndex,
                        onItemSelected: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      )
                    : SizedBox(),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
    );
  }
}
