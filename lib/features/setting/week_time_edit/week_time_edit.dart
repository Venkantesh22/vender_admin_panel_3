import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/widget/week_row.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';

class WeekTimeEdit extends StatefulWidget {
  const WeekTimeEdit({super.key});

  @override
  State<WeekTimeEdit> createState() => _WeekTimeEditState();
}

class _WeekTimeEditState extends State<WeekTimeEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController mondayController;
  late TextEditingController tuesdayController;
  late TextEditingController wednesdayController;
  late TextEditingController thursdayController;
  late TextEditingController fridayController;
  late TextEditingController saturdayController;
  late TextEditingController sundayController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _fetchWeekData();
  }

  void _initControllers() {
    // Initialize with empty, will set values after fetching
    mondayController = TextEditingController();
    tuesdayController = TextEditingController();
    wednesdayController = TextEditingController();
    thursdayController = TextEditingController();
    fridayController = TextEditingController();
    saturdayController = TextEditingController();
    sundayController = TextEditingController();
  }

  Future<void> _fetchWeekData() async {
    setState(() => _isLoading = true);
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final info = appProvider.getSalonInformation;

      mondayController.text = info.monday ?? '';
      tuesdayController.text = info.tuesday ?? '';
      wednesdayController.text = info.wednesday ?? '';
      thursdayController.text = info.thursday ?? '';
      fridayController.text = info.friday ?? '';
      saturdayController.text = info.saturday ?? '';
      sundayController.text = info.sunday ?? '';
    } catch (e) {
      showMessage("Error fetching week data: $e");
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    mondayController.dispose();
    tuesdayController.dispose();
    wednesdayController.dispose();
    thursdayController.dispose();
    fridayController.dispose();
    saturdayController.dispose();
    sundayController.dispose();
    super.dispose();
  }

  Future<void> _saveWeekTimes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final oldInfo = appProvider.getSalonInformation;

      final updatedModel = oldInfo.copyWith(
        monday: mondayController.text.trim().isEmpty
            ? oldInfo.monday
            : mondayController.text.trim(),
        tuesday: tuesdayController.text.trim().isEmpty
            ? oldInfo.tuesday
            : tuesdayController.text.trim(),
        wednesday: wednesdayController.text.trim().isEmpty
            ? oldInfo.wednesday
            : wednesdayController.text.trim(),
        thursday: thursdayController.text.trim().isEmpty
            ? oldInfo.thursday
            : thursdayController.text.trim(),
        friday: fridayController.text.trim().isEmpty
            ? oldInfo.friday
            : fridayController.text.trim(),
        saturday: saturdayController.text.trim().isEmpty
            ? oldInfo.saturday
            : saturdayController.text.trim(),
        sunday: sundayController.text.trim().isEmpty
            ? oldInfo.sunday
            : sundayController.text.trim(),
      );

      await appProvider.updateSalonInfoFirebase(context, updatedModel);

      showMessage('Week Timing updated successfully');
      if (mounted) {
        Routes.instance.pushAndRemoveUntil(
          widget: HomeScreen(
            date: Provider.of<CalenderProvider>(context, listen: false)
                .getSelectDate,
          ),
          context: context,
        );
      }
    } catch (e) {
      showMessage('Failed to update week timing: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: AppColor.bgForAdminCreateSec,
              child: Center(
                child: Container(
                  margin: ResponsiveLayout.isMobile(context)
                      ? EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo12)
                      : ResponsiveLayout.isTablet(context)
                          ? EdgeInsets.symmetric(
                              horizontal: Dimensions.dimenisonNo60)
                          : null,
                  color: Colors.white,
                  width: ResponsiveLayout.isDesktop(context)
                      ? Dimensions.screenWidth / 1.5
                      : null,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: Dimensions.dimenisonNo20),
                        Text(
                          'Weekly Schedule',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo30,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                          ),
                        ),
                        const Divider(),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        WeekRow(dayOfWeek: "Monday", time: mondayController),
                        WeekRow(dayOfWeek: "Tuesday", time: tuesdayController),
                        WeekRow(
                            dayOfWeek: "Wednesday", time: wednesdayController),
                        WeekRow(
                            dayOfWeek: "Thursday", time: thursdayController),
                        WeekRow(dayOfWeek: "Friday", time: fridayController),
                        WeekRow(
                            dayOfWeek: "Saturday", time: saturdayController),
                        WeekRow(dayOfWeek: "Sunday", time: sundayController),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.dimenisonNo10,
                              vertical: Dimensions.dimenisonNo20),
                          child: CustomAuthButton(
                            text: "Save",
                            ontap: _saveWeekTimes,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
