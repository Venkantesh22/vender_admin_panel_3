import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/home/widget/state_text.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class RowOfStates extends StatelessWidget {
  final int index;
  final AppointModel appointModel;
  final SalonModel salonModel;
  final UserModel userModel;
  const RowOfStates({
    super.key,
    required this.index,
    required this.appointModel,
    required this.salonModel,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    CalenderProvider calenderProvider = Provider.of<CalenderProvider>(context);
    List<TimeStampModel> timeStampList = [];
    timeStampList.clear();
    timeStampList.addAll(appointModel.timeStampList);
    bool update = false;

    TimeStampModel timeStampModelFunction(String updateBy) {
      TimeStampModel _timeStampModel = TimeStampModel(
          id: appointModel.orderId,
          dateAndTime: GlobalVariable.today,
          updateBy: "${salonModel.name} $updateBy");
      return _timeStampModel;
    }

//!update to Pending to Confirmed
    return appointModel.status == "Pending"
        ? Padding(
            padding: EdgeInsets.only(
              top: Dimensions.dimenisonNo16,
              left: Dimensions.dimenisonNo16,
              right: Dimensions.dimenisonNo16,
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Current State",
                      style: TextStyle(fontSize: Dimensions.dimenisonNo14),
                    ),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: StateText(status: appointModel.status)),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "Update State",
                      style: TextStyle(fontSize: Dimensions.dimenisonNo14),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        TimeStampModel _timeStampModel =
                            timeStampModelFunction("(Confirmed)");

                        timeStampList.add(_timeStampModel);
                        if (appointModel.status == "Pending") {
                          AppointModel orderUpdate = appointModel.copyWith(
                            status: "Confirmed",
                            timeStampList: timeStampList,
                          );
                          bookingProvider.updateAppointment(
                            userModel.id,
                            appointModel.orderId,
                            orderUpdate,
                          );
                          update = true;

                          if (update) {
                            Routes.instance.push(
                                widget: HomeScreen(
                                  date: calenderProvider.getSelectDate,
                                ),
                                context: context);
                            showMessage(
                                "Booking of ${userModel.name} update to Check-In");
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.checkmark_alt_circle,
                            size: Dimensions.dimenisonNo18,
                            color: AppColor.buttonColor,
                          ),
                          SizedBox(width: Dimensions.dimenisonNo5),
                          Text(
                            "Confirmed",
                            style: GoogleFonts.roboto(
                              fontSize: Dimensions.dimenisonNo16,
                              color: AppColor.buttonColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider()
              ],
            ),
          )

        //!update to  Confirmed to Check-in

        : appointModel.status == "Confirmed"
            ? Padding(
                padding: EdgeInsets.only(
                  top: Dimensions.dimenisonNo16,
                  left: Dimensions.dimenisonNo16,
                  right: Dimensions.dimenisonNo16,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Current State",
                          style: TextStyle(fontSize: Dimensions.dimenisonNo14),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt_circle,
                                size: Dimensions.dimenisonNo18,
                                color: AppColor.buttonColor,
                              ),
                              SizedBox(width: Dimensions.dimenisonNo5),
                              Text(
                                appointModel.status,
                                style: GoogleFonts.roboto(
                                  fontSize: Dimensions.dimenisonNo16,
                                  color: AppColor.buttonColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "Update State",
                          style: TextStyle(fontSize: Dimensions.dimenisonNo14),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            TimeStampModel _timeStampModel =
                                timeStampModelFunction("(Check-In)");

                            timeStampList.add(_timeStampModel);
                            AppointModel orderUpdate = appointModel.copyWith(
                                status: "Check-In",
                                timeStampList: timeStampList);
                            bookingProvider.updateAppointment(
                              userModel.id,
                              appointModel.orderId,
                              orderUpdate,
                            );
                            Routes.instance.push(
                                widget: HomeScreen(
                                  date: calenderProvider.getSelectDate,
                                ),
                                context: context);
                            showMessage(
                                "Booking of ${userModel.name} update to InProcess");
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt_circle,
                                size: Dimensions.dimenisonNo14,
                                color: Colors.orange,
                              ),
                              SizedBox(width: Dimensions.dimenisonNo10),
                              Text(
                                "Check-In",
                                style: GoogleFonts.roboto(
                                  fontSize: Dimensions.dimenisonNo16,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider()
                  ],
                ),
              )

//!update to Check-in to InServices
            : appointModel.status == "Check-In"
                ? Padding(
                    padding: EdgeInsets.only(
                      top: Dimensions.dimenisonNo16,
                      left: Dimensions.dimenisonNo16,
                      right: Dimensions.dimenisonNo16,
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Current State",
                              style:
                                  TextStyle(fontSize: Dimensions.dimenisonNo14),
                            ),
                            CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                child: StateText(status: appointModel.status)),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              "Update State",
                              style:
                                  TextStyle(fontSize: Dimensions.dimenisonNo14),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                TimeStampModel _timeStampModel =
                                    timeStampModelFunction("(InServices)");

                                timeStampList.add(_timeStampModel);
                                if (appointModel.status == "Check-In") {
                                  AppointModel orderUpdate =
                                      appointModel.copyWith(
                                    status: "InServices",
                                    // status: "Confirmed",
                                    timeStampList: timeStampList,
                                  );
                                  bookingProvider.updateAppointment(
                                    userModel.id,
                                    appointModel.orderId,
                                    orderUpdate,
                                  );
                                  update = true;

                                  if (update) {
                                    Routes.instance.push(
                                        widget: HomeScreen(
                                          date: calenderProvider.getSelectDate,
                                        ),
                                        context: context);
                                    showMessage(
                                        "Booking of ${userModel.name} update to Confirmed");
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.scissors,
                                    size: Dimensions.dimenisonNo14,
                                  ),
                                  SizedBox(width: Dimensions.dimenisonNo10),
                                  Text(
                                    "InServices",
                                    style: GoogleFonts.roboto(
                                      fontSize: Dimensions.dimenisonNo16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  )

                //!update  InServices to Completed

                : appointModel.status == "InServices"
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: Dimensions.dimenisonNo16,
                          left: Dimensions.dimenisonNo16,
                          right: Dimensions.dimenisonNo16,
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Current State",
                                  style: TextStyle(
                                      fontSize: Dimensions.dimenisonNo14),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.scissors,
                                        size: Dimensions.dimenisonNo14,
                                      ),
                                      SizedBox(width: Dimensions.dimenisonNo10),
                                      Text(
                                        appointModel.status,
                                        style: GoogleFonts.roboto(
                                          fontSize: Dimensions.dimenisonNo16,
                                          color: AppColor.buttonColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Text(
                                  "Update State",
                                  style: TextStyle(
                                      fontSize: Dimensions.dimenisonNo14),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    TimeStampModel _timeStampModel =
                                        timeStampModelFunction("(Completed)");

                                    timeStampList.add(_timeStampModel);
                                    AppointModel orderUpdate =
                                        appointModel.copyWith(
                                            status: "Completed",
                                            timeStampList: timeStampList);
                                    bookingProvider.updateAppointment(
                                      userModel.id,
                                      appointModel.orderId,
                                      orderUpdate,
                                    );
                                    Routes.instance.push(
                                        widget: HomeScreen(
                                          date: calenderProvider.getSelectDate,
                                        ),
                                        context: context);
                                    showMessage(
                                        "Booking of ${userModel.name} update to InProcess");
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.checkmark_alt_circle,
                                        size: Dimensions.dimenisonNo18,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: Dimensions.dimenisonNo5),
                                      Text(
                                        "Completed",
                                        style: GoogleFonts.roboto(
                                          fontSize: Dimensions.dimenisonNo16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider()
                          ],
                        ),
                      )

//!  Complete Appointment

                    : appointModel.status == "Completed"
                        ? Container(
                            height: Dimensions.dimenisonNo60,
                            padding: EdgeInsets.only(
                              left: Dimensions.dimenisonNo16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current State",
                                  style: TextStyle(
                                      fontSize: Dimensions.dimenisonNo14),
                                ),
                                SizedBox(
                                  height: Dimensions.dimenisonNo10,
                                ),
                                StateText(status: appointModel.status),
                              ],
                            ),
                          )
                        : appointModel.status == "(Cancel)"
                            ? Container(
                                height: Dimensions.dimenisonNo60,
                                padding: EdgeInsets.only(
                                  left: Dimensions.dimenisonNo16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Current State",
                                      style: TextStyle(
                                          fontSize: Dimensions.dimenisonNo14),
                                    ),
                                    SizedBox(
                                      height: Dimensions.dimenisonNo10,
                                    ),
                                    StateText(status: appointModel.status),
                                  ],
                                ),
                              )
                            : appointModel.status == "Bill Generate"
                                ? Container(
                                    height: Dimensions.dimenisonNo60,
                                    padding: EdgeInsets.only(
                                      left: Dimensions.dimenisonNo16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Current State",
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.dimenisonNo14),
                                        ),
                                        SizedBox(
                                          height: Dimensions.dimenisonNo10,
                                        ),
                                        StateText(status: appointModel.status),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: Dimensions.dimenisonNo60,
                                    padding: EdgeInsets.only(
                                      left: Dimensions.dimenisonNo16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Current State",
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.dimenisonNo14),
                                        ),
                                        SizedBox(
                                          height: Dimensions.dimenisonNo10,
                                        ),
                                        StateText(status: appointModel.status),
                                      ],
                                    ),
                                  );
  }
}
