import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/reports_Section/appointment_reports/screen/appointment_reports.dart';
import 'package:samay_admin_plan/features/reports_Section/cancel_reports/screen/cancel_reports.dart';
import 'package:samay_admin_plan/features/reports_Section/sales_reports/screen/sales_reports_screen.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/features/drawer/report_drawer.dart';

class ReportDashboard extends StatefulWidget {
  const ReportDashboard({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ReportDashboardState createState() => _ReportDashboardState();
}

class _ReportDashboardState extends State<ReportDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  bool _isLoading = false;

  final List<String> _menuTitles = ['Appointment', 'Saler Summery', 'Cancel'];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    await appProvider.getSalonInfoFirebase();

    try {
      ;
    } catch (e) {
      print("Error fetching or updating settings data: $e");
      showMessage("Error fetching settings. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final List<Widget> _pages = [
      const AppointmentReportsScreen(),
      const SalesReportsScreen(),
      const CancelReportsScreen(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(scaffoldKey: _scaffoldKey),
      ),
      drawer: ResponsiveLayout.isMoAndTab(context)
          ? ReportDrawer(
              menuTitles: _menuTitles,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )
          : null,
      key: _scaffoldKey,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                ResponsiveLayout.isDesktop(context)
                    ? ReportDrawer(
                        menuTitles: _menuTitles,
                        selectedIndex: _selectedIndex,
                        onItemSelected: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      )
                    : const SizedBox(),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
    );
  }
}
