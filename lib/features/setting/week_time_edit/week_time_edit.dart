import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/widget/week_row.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';

class WeekTimeEdit extends StatefulWidget {
  const WeekTimeEdit({
    super.key,
  });

  @override
  State<WeekTimeEdit> createState() => _WeekTimeEditState();
}

class _WeekTimeEditState extends State<WeekTimeEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController mondayController = TextEditingController();
  final TextEditingController tuesdayController = TextEditingController();
  final TextEditingController wednesdayController = TextEditingController();
  final TextEditingController thursdayController = TextEditingController();
  final TextEditingController fridayController = TextEditingController();
  final TextEditingController saturdayController = TextEditingController();
  final TextEditingController sundayController = TextEditingController();

  String _monday = "";
  String _tuesday = "";
  String _wednesday = "";
  String _thursday = "";
  String _friday = "";
  String _saturday = "";
  String _sunday = "";

  bool _isLoading = false;
  bool _isupdate = false;
  SalonModel? _salonModel;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    _salonModel = appProvider.getSalonInformation;
    try {
      _monday = appProvider.getSalonInformation.monday!;
      _tuesday = appProvider.getSalonInformation.tuesday!;
      _wednesday = appProvider.getSalonInformation.wednesday!;
      _thursday = appProvider.getSalonInformation.thursday!;
      _friday = appProvider.getSalonInformation.friday!;
      _saturday = appProvider.getSalonInformation.saturday!;
      _sunday = appProvider.getSalonInformation.sunday!;
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

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
    return _isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                color: AppColor.bgForAdminCreateSec,
                child: Center(
                  child: Container(
                    margin: ResponsiveLayout.isMobile(context)
                        ? EdgeInsets.symmetric(
                            horizontal: Dimensions.dimenisonNo12,
                          )
                        : ResponsiveLayout.isTablet(context)
                            ? EdgeInsets.symmetric(
                                horizontal: Dimensions.dimenisonNo60,
                              )
                            : null,
                    color: Colors.white,
                    width: ResponsiveLayout.isDesktop(context)
                        ? Dimensions.screenWidth / 1.5
                        : null,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dimensions.dimenisonNo20,
                          ),
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
                          SizedBox(
                            height: Dimensions.dimenisonNo10,
                          ),
                          WeekRow(
                            dayOfWeek: "Monday",
                            time: mondayController,
                            value: _monday,
                          ),
                          WeekRow(
                            dayOfWeek: "Tuesday",
                            time: tuesdayController,
                            value: _tuesday,
                          ),
                          WeekRow(
                            dayOfWeek: "Wednesday",
                            time: wednesdayController,
                            value: _wednesday,
                          ),
                          WeekRow(
                            dayOfWeek: "Thursday",
                            time: thursdayController,
                            value: _thursday,
                          ),
                          WeekRow(
                            dayOfWeek: "Friday",
                            time: fridayController,
                            value: _friday,
                          ),
                          WeekRow(
                            dayOfWeek: "Saturday",
                            time: saturdayController,
                            value: _saturday,
                          ),
                          WeekRow(
                            dayOfWeek: "Sunday",
                            time: sundayController,
                            value: _sunday,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.dimenisonNo10,
                                vertical: Dimensions.dimenisonNo20),
                            child: CustomAuthButton(
                              text: "Save",
                              ontap: () async {
                                try {
                                  SalonModel _salonModel =
                                      appProvider.getSalonInformation;

                                  SalonModel salonModel =
                                      appProvider.getSalonInformation.copyWith(
                                    monday: mondayController.text.isEmpty
                                        ? _salonModel.monday
                                        : mondayController.text.trim(),
                                    tuesday: tuesdayController.text.isEmpty
                                        ? _salonModel.tuesday
                                        : tuesdayController.text.trim(),
                                    wednesday: wednesdayController.text.isEmpty
                                        ? _salonModel.wednesday
                                        : wednesdayController.text.trim(),
                                    thursday: thursdayController.text.isEmpty
                                        ? _salonModel.thursday
                                        : thursdayController.text.trim(),
                                    friday: fridayController.text.isEmpty
                                        ? _salonModel.friday
                                        : fridayController.text.trim(),
                                    saturday: saturdayController.text.isEmpty
                                        ? _salonModel.saturday
                                        : saturdayController.text.trim(),
                                    sunday: sundayController.text.isEmpty
                                        ? _salonModel.sunday
                                        : sundayController.text.trim(),
                                  );

                                  appProvider.updateSalonInfoFirebase(
                                    context,
                                    salonModel,
                                  );

                                  Routes.instance.pushAndRemoveUntil(
                                      widget: HomeScreen(
                                        date: Provider.of<CalenderProvider>(
                                                context,
                                                listen: false)
                                            .getSelectDate,
                                      ),
                                      context: context);
                                  showMessage(
                                      'Week Timing is added Successfully');
                                  // }
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
