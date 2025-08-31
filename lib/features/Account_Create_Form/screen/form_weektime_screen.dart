import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/widget/week_row.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';

class FormTimeSection extends StatefulWidget {
  const FormTimeSection({
    super.key,
  });

  @override
  State<FormTimeSection> createState() => _FormTimeSectionState();
}

class _FormTimeSectionState extends State<FormTimeSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController mondayController = TextEditingController();
  final TextEditingController tuesdayController = TextEditingController();
  final TextEditingController wednesdayController = TextEditingController();
  final TextEditingController thursdayController = TextEditingController();
  final TextEditingController fridayController = TextEditingController();
  final TextEditingController saturdayController = TextEditingController();
  final TextEditingController sundayController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers
    mondayController.dispose();
    tuesdayController.dispose();
    wednesdayController.dispose();
    thursdayController.dispose();
    fridayController.dispose();
    saturdayController.dispose();
    sundayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppColor.bgForAdminCreateSec,
          child: Center(
            child: Container(
              color: Colors.white,
              width: Dimensions.screenWidth / 2,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.dimensionNo20,
                    ),
                    Text(
                      'Weekly Schedule',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo30,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      height: Dimensions.dimensionNo10,
                    ),
                    WeekRow(dayOfWeek: "Monday", time: mondayController),
                    WeekRow(dayOfWeek: "Tuesday", time: tuesdayController),
                    WeekRow(dayOfWeek: "Wednesday", time: wednesdayController),
                    WeekRow(dayOfWeek: "Thursday", time: thursdayController),
                    WeekRow(dayOfWeek: "Friday", time: fridayController),
                    WeekRow(dayOfWeek: "Saturday", time: saturdayController),
                    WeekRow(dayOfWeek: "Sunday", time: sundayController),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimensionNo10,
                          vertical: Dimensions.dimensionNo20),
                      child: CustomAuthButton(
                        text: "Save",
                        ontap: () async {
                          try {
                            bool isVaildated = formWeekdayVaildation(
                                mondayController.text,
                                tuesdayController.text,
                                wednesdayController.text,
                                thursdayController.text,
                                fridayController.text,
                                saturdayController.text,
                                sundayController.text);

                            if (isVaildated) {
                              SalonModel salonModel =
                                  appProvider.getSalonInformation.copyWith(
                                monday: mondayController.text.trim(),
                                tuesday: tuesdayController.text.trim(),
                                wednesday: wednesdayController.text.trim(),
                                thursday: thursdayController.text.trim(),
                                friday: fridayController.text.trim(),
                                saturday: saturdayController.text.trim(),
                                sunday: sundayController.text.trim(),
                              );

                              appProvider.updateSalonInfoFirebase(
                                context,
                                salonModel,
                              );

                              Routes.instance.pushAndRemoveUntil(
                                  widget: HomeScreen(
                                    date: Provider.of<CalenderProvider>(context,
                                            listen: false)
                                        .getSelectDate,
                                  ),
                                  context: context);
                              showMessage('Week Timing is added Successfully');
                            }
                          } catch (e) {
                            showMessage(
                                'Week Timing is not added or an error occurred');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
