// ignore_for_file: unused_field, override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/home/user_list/widget/user_booking.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/report_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/custom_button.dart';

class AppointmentReportsScreen extends StatefulWidget {
  const AppointmentReportsScreen({super.key});

  @override
  State<AppointmentReportsScreen> createState() =>
      _AppointmentReportsScreenState();
}

class _AppointmentReportsScreenState extends State<AppointmentReportsScreen> {
  String? _selectedOption;
  String? _selectedStatus;

  DateTime today = DateTime.now();

  DateTime? _todayDate = DateTime.now();
  DateTime? _yesterdayDate = DateTime.now();
  DateTime _startOfWeek = DateTime.now();
  DateTime _endOfWeek = DateTime.now();
  DateTime _startOfLastWeek = DateTime.now();
  DateTime _endOfLastWeek = DateTime.now();
  DateTime _startOfLastTwoWeeks = DateTime.now();
  DateTime _endOfLastTwoWeek = DateTime.now();
  DateTime _firstDayLastMonth = DateTime.now();
  DateTime _lastDayLastMonth = DateTime.now();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();

  bool _isloading = false;

  late SalonModel _salonModel;
  List<AppointModel> _appointemtnList = [];

  @override
  final List<String> _dropdownOptions = [
    "Today",
    "Yesterday",
    "This Week",
    "Last Week",
    "Last Two Weeks",
    "Last Month",
    "Custom Time Period",
  ];
  final List<String> _dropdownOptionsForAppointStates = [
    "Pending",
    "Confirmed",
    "Check-In",
    "InServices",
    "Completed",
    "Bill Generate",
    "(Update)",
    "All",
  ];

  String formatDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  String formatDateForTextbox(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String getDropdownLabel(String option) {
    switch (option) {
      case "Today":
        setState(() {
          _todayDate = today;
        });
        return "Today (${formatDate(today)})";

      case "Yesterday":
        setState(() {
          _yesterdayDate = today.subtract(const Duration(days: 1));
        });
        DateTime yesterday = today.subtract(const Duration(days: 1));
        return "Yesterday (${formatDate(yesterday)})";

      case "This Week":
        // Sunday as first day of week
        _startOfWeek = today.subtract(Duration(days: today.weekday % 7));
        _endOfWeek = _startOfWeek.add(const Duration(days: 6));
        return "This Week (${formatDate(_startOfWeek)} - ${formatDate(_endOfWeek)})";

      case "Last Week":
        // Previous week (Sunday to Saturday)
        final startOfThisWeek =
            today.subtract(Duration(days: today.weekday % 7));
        _startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
        _endOfLastWeek = _startOfLastWeek.add(const Duration(days: 6));
        return "Last Week (${formatDate(_startOfLastWeek)} - ${formatDate(_endOfLastWeek)})";

      case "Last Two Weeks":
        // Two complete weeks before current week
        final startOfThisWeek =
            today.subtract(Duration(days: today.weekday % 7));
        _startOfLastTwoWeeks =
            startOfThisWeek.subtract(const Duration(days: 14));
        _endOfLastTwoWeek = startOfThisWeek.subtract(const Duration(days: 1));
        return "Last Two Weeks (${formatDate(_startOfLastTwoWeeks)} - ${formatDate(_endOfLastTwoWeek)})";

      case "Last Month":
        _firstDayLastMonth = DateTime(today.year, today.month - 1, 1);
        _lastDayLastMonth = DateTime(today.year, today.month, 0);
        return "Last Month (${formatDate(_firstDayLastMonth)} - ${formatDate(_lastDayLastMonth)})";

      case "Custom Time Period":
        return "Custom Time Period";

      default:
        return option;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = today;
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ReportProvider reportProvider = Provider.of<ReportProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      body: _isloading
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveLayout(
              mobile:
                  AppointListMobileWidget(reportProvider, appProvider, context),
              tablet:
                  AppointListWebWidget(reportProvider, appProvider, context),
              desktop:
                  AppointListWebWidget(reportProvider, appProvider, context)),
      // AppointListWebWidget(reportProvider, appProvider, context),
    );
  }

  SingleChildScrollView AppointListWebWidget(ReportProvider reportProvider,
      AppProvider appProvider, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.dimenisonNo16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Appointment List',
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.dimenisonNo16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Show Appointment List information for sales',
              style: TextStyle(
                color: Color(0xFF595959),
                fontSize: Dimensions.dimenisonNo12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: dateDropDownWidget(),
                ),
                SizedBox(
                  width: Dimensions.dimenisonNo16,
                ),
                Expanded(
                  child: appointStateDropDownWidget(),
                ),
                SizedBox(
                  width: Dimensions.dimenisonNo16,
                ),
                GeneratButtonWIdget(reportProvider, appProvider)
              ],
            ),
            if (_selectedOption == "Custom Time Period") ...[
              SizedBox(height: Dimensions.dimenisonNo16),
              textboxForDate(context),
            ],
            Padding(
              padding: EdgeInsets.only(
                  bottom: Dimensions.dimenisonNo20,
                  top: Dimensions.dimenisonNo12),
              child: Text(
                "Data List",
                style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(color: AppColor.whileColor),
              child: _isloading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align content to the top
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align content to the left
                      children: [
                        headerOfAppointWebWidget(),
                        ListOfAppoint(),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView AppointListMobileWidget(ReportProvider reportProvider,
      AppProvider appProvider, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.dimenisonNo12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Appointment List',
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.dimenisonNo16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Show Appointment List information for sales',
              style: TextStyle(
                color: Color(0xFF595959),
                fontSize: Dimensions.dimenisonNo12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo12),
            Wrap(
              spacing: Dimensions.dimenisonNo12,
              runSpacing: Dimensions.dimenisonNo12,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                dateDropDownWidget(),
                ResponsiveLayout.isMobile(context)
                    ? _selectedOption == "Custom Time Period"
                        ? textboxForDate(context)
                        : const SizedBox()
                    : const SizedBox(),
                appointStateDropDownWidget(),
                GeneratButtonWIdget(reportProvider, appProvider)
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: Dimensions.dimenisonNo20,
                  top: Dimensions.dimenisonNo12),
              child: Text(
                "Data List",
                style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.zero,
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(color: AppColor.whileColor),
              child: _isloading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align content to the top
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align content to the left
                      children: [
                        headerOfAppointWebWidget(),
                        ListOfAppoint(),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  Consumer<ReportProvider> ListOfAppoint() {
    return Consumer<ReportProvider>(
      builder: (context, reportProvider, child) {
        if (_appointemtnList.isEmpty) {
          return const Center(
            child: Text('No appointments available for this date.'),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap:
              true, // Ensure the ListView only takes up the space it needs
          itemCount: _appointemtnList.length,
          itemBuilder: (context, _index) {
            AppointModel order = _appointemtnList[_index];

            // Use data directly from the `AppointModel` or preload user data into the `ReportProvider`
            UserModel user =
                order.userModel; // Assuming user data is part of the order
            int _no = _index + 1;
            return UserBookingTap(
              appointModel: order,
              userModel: user,
              index: _no,
              isUseForReportSce: true,
              applyMarginMobile: false,
            );
          },
        );
      },
    );
  }

  Container headerOfAppointWebWidget() {
    return ResponsiveLayout.isMobile(context)
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo5),
            alignment: Alignment.topCenter,
            height: Dimensions.dimenisonNo34,
            decoration: BoxDecoration(
                color: const Color.fromARGB(153, 215, 166, 166),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(Dimensions.dimenisonNo5)),
            child: Center(
                child: Row(
              children: [
                Center(
                  child: Text(
                    "No",
                    style: heardTextStyle(),
                  ),
                ),
                SizedBox(
                  width: Dimensions.dimenisonNo50,
                  child: Center(
                    child: Text(
                      "Image",
                      style: heardTextStyle(),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.dimenisonNo10),
                SizedBox(
                  width: Dimensions.dimenisonNo40,
                  child: Text(
                    "Name",
                    textAlign: TextAlign.start,
                    style: heardTextStyle(),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: Dimensions.dimenisonNo40,
                  child: Center(
                    child: Text(
                      "Status",
                      style: heardTextStyle(),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.dimenisonNo20),
              ],
            )),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo20),
            alignment: Alignment.topCenter,
            height: Dimensions.dimenisonNo34,
            decoration: BoxDecoration(
                color: const Color.fromARGB(153, 215, 166, 166),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(Dimensions.dimenisonNo5)),
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: Dimensions.dimenisonNo30,
                    child: Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: Dimensions.dimenisonNo14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.dimenisonNo50,
                    child: Center(
                      child: Text(
                        "Image",
                        style: TextStyle(
                          fontSize: Dimensions.dimenisonNo14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.dimenisonNo10),
                  SizedBox(
                    width: Dimensions.dimenisonNo200,
                    child: Text(
                      "Name",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    child: Text(
                      "Date and Time",
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: Dimensions.dimenisonNo80,
                    child: Center(
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontSize: Dimensions.dimenisonNo14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.dimenisonNo30),
                ],
              ),
            ),
          );
  }

  TextStyle heardTextStyle() {
    return TextStyle(
      fontSize: Dimensions.dimenisonNo12,
      fontWeight: FontWeight.w400,
    );
  }

  CustomButtom GeneratButtonWIdget(
      ReportProvider reportProvider, AppProvider appProvider) {
    return CustomButtom(
      text: "Generate",
      ontap: () async {
        setState(() {
          _isloading = true;
        });
        _appointemtnList.clear();

        if (_selectedOption == "Today") {
          await reportProvider.getAppointSingleDateListPro(
            _todayDate!,
            appProvider.getSalonInformation.id,
          );
          setState(() {
            setState(() {
              addProListToAppoint(reportProvider);
            });
          });
          print("Appointment List Length: ${_appointemtnList.length}");
        } else if (_selectedOption == "Yesterday") {
          await reportProvider.getAppointSingleDateListPro(
            _yesterdayDate!,
            appProvider.getSalonInformation.id,
          );
          setState(() {
            setState(() {
              addProListToAppoint(reportProvider);
            });
          });
        } else if (_selectedOption == "This Week") {
          await reportProvider.getAppointListRangeDateAndStatusPro(
            _startOfWeek,
            _endOfWeek,
            appProvider.getSalonInformation.id,
          );
          setState(() {
            addProListToAppoint(reportProvider);
          });
        } else if (_selectedOption == "Last Week") {
          await reportProvider.getAppointListRangeDateAndStatusPro(
            _startOfLastWeek,
            _endOfLastWeek,
            appProvider.getSalonInformation.id,
          );
          setState(() {
            addProListToAppoint(reportProvider);
          });
        } else if (_selectedOption == "Last Two Weeks") {
          await reportProvider.getAppointListRangeDateAndStatusPro(
            _startOfLastTwoWeeks,
            _endOfLastTwoWeek,
            appProvider.getSalonInformation.id,
          );
          setState(() {
            addProListToAppoint(reportProvider);
          });
        } else if (_selectedOption == "Last Month") {
          await reportProvider.getAppointListRangeDateAndStatusPro(
            _firstDayLastMonth,
            _lastDayLastMonth,
            appProvider.getSalonInformation.id,
          );
          print("Selected Option: start ${_firstDayLastMonth}");
          print("Selected Option: end ${_lastDayLastMonth}");

          setState(() {
            addProListToAppoint(reportProvider);
          });
        } else if (_selectedOption == "Custom Time Period") {
          await reportProvider.getAppointListRangeDateAndStatusPro(
            _startDate!,
            _endDate!,
            appProvider.getSalonInformation.id,
          );
          setState(() {
            addProListToAppoint(reportProvider);
          });
        }

        setState(() {
          _isloading = false;
        });
      },
      buttonColor: AppColor.buttonColor,
    );
  }

  Column appointStateDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Appointment Status",
          style: TextStyle(
              fontSize: Dimensions.dimenisonNo14, fontWeight: FontWeight.w600),
        ),
        DropdownButton<String>(
          hint: Text(
            "Select Status",
            style: TextStyle(
              fontSize: Dimensions.dimenisonNo12,
              fontWeight: FontWeight.w600,
            ),
          ),
          isExpanded: true,
          value: _selectedStatus,
          items: _dropdownOptionsForAppointStates.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                getDropdownLabel(option),
                style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
          },
        ),
      ],
    );
  }

  Column dateDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Date",
          style: TextStyle(
              fontSize: Dimensions.dimenisonNo14, fontWeight: FontWeight.w600),
        ),
        DropdownButton<String>(
          hint: Text(
            "Select Date",
            style: TextStyle(
              fontSize: Dimensions.dimenisonNo12,
              fontWeight: FontWeight.w600,
            ),
          ),
          isExpanded: true,
          value: _selectedOption,
          items: _dropdownOptions.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                getDropdownLabel(option),
                style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
          },
        ),
      ],
    );
  }

  void addProListToAppoint(ReportProvider reportProvider) {
    _appointemtnList = _selectedStatus != null && _selectedStatus != "All"
        ? _selectedStatus == "(Update)"
            ? reportProvider.getAppointmentList.where((order) {
                return order.isUpdate == true;
              }).toList()
            : reportProvider.getAppointmentList.where((order) {
                return order.status == _selectedStatus!;
              }).toList()
        : reportProvider.getAppointmentList;

    print("Filtered Appointments Count: ${_appointemtnList.length}");
  }

  Row textboxForDate(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Starting Date",
                  style: TextStyle(fontSize: Dimensions.dimenisonNo14),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: Container(
                  width: Dimensions.dimenisonNo200,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.dimenisonNo12,
                      vertical: Dimensions.dimenisonNo8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(Dimensions.dimenisonNo5),
                  ),
                  child: Text(
                    _startDate != null
                        ? formatDateForTextbox(_startDate!)
                        : "Select Start Date",
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: Dimensions.dimenisonNo16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ending Date",
                  style: TextStyle(fontSize: Dimensions.dimenisonNo16),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: Container(
                  width: Dimensions.dimenisonNo200,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.dimenisonNo12,
                      vertical: Dimensions.dimenisonNo8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(Dimensions.dimenisonNo5),
                  ),
                  child: Text(
                    _endDate != null
                        ? formatDateForTextbox(_endDate!)
                        : "Select End Date",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
