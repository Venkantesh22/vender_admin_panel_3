// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Calender/screen/calender.dart';
import 'package:samay_admin_plan/features/add_new_appointment/screen/add_new_appointment.dart';
import 'package:samay_admin_plan/features/home/user_list/widget/user_booking.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/add_button.dart';

class UserList extends StatefulWidget {
  final SalonModel salonModel;

  DateTime date;
  final Function(AppointModel, UserModel userModel, int index)
      onBookingSelected;

  UserList({
    super.key,
    required this.salonModel,
    required this.onBookingSelected,
    required this.date,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  // DateTime _currentDate = DateTime.now(); // Track the currently selected date
  final TextEditingController _dateController =
      TextEditingController(); // Controller for date input field
  bool _showCalendar = false; // Toggle to show/hide calendar
  bool _isLoading = false;

  UserModel? user;
  @override
  void initState() {
    super.initState();
    // Initialize the date controller with the current date
    _dateController.text = DateFormat('dd MMMM').format(widget.date);
    _fetchBookings(); // Fetch initial bookings on load
  }

  // Function to format the date for display
  String _formatDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return "Today";
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return ResponsiveLayout.isMobile(context) ? 'Tmr' : "Tomorrow";
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return ResponsiveLayout.isMobile(context) ? " Yday" : 'Yesterday';
    } else {
      return DateFormat('d MMMM').format(date);
    }
  }

  Future<void> _fetchBookings() async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    await Provider.of<BookingProvider>(context, listen: false)
        .getBookingListPro(widget.date, appProvider.getSalonInformation.id);
    setState(() {
      _isLoading = false;
    });
  }

  // Function to decrease the date by one day
  void _decrementDate() {
    setState(() {
      widget.date = widget.date.subtract(const Duration(days: 1));
      _updateDateController();
      _fetchBookings(); // Fetch bookings after date change
    });
  }

  // Function to increase the date by one day
  void _incrementDate() {
    setState(() {
      widget.date = widget.date.add(const Duration(days: 1));
      _updateDateController();
      _fetchBookings(); // Fetch bookings after date change
    });
  }

  // Function to update the date controller text field
  void _updateDateController() {
    _dateController.text = DateFormat('dd MMMM').format(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    return userListWebWidget(context);
  }

  Stack userListMobileWidget(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showCalendar = false;
            });
          },
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: Dimensions.dimenisonNo16,
                  right: Dimensions.dimenisonNo16,
                  top: Dimensions.dimenisonNo10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: Dimensions.dimenisonNo10),

                    // Decrease date button
                    GestureDetector(
                      onTap: _decrementDate,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B4B4B),
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimenisonNo5),
                        ),
                        child: const Icon(
                          Icons.arrow_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo10),
                      child: Center(
                        child: Text(
                          _formatDate(widget.date),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    // Increase date button
                    GestureDetector(
                      onTap: _incrementDate,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B4B4B),
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimenisonNo5),
                        ),
                        child: const Icon(
                          Icons.arrow_right_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.dimenisonNo12),

                    // Toggle calendar visibility
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showCalendar = !_showCalendar;
                        });
                      },
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
                    Text(
                      widget.salonModel.name ?? 'Salon Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.dimenisonNo16),
                    ),
                    const Spacer(),
                    AddButton(
                      text: "Add Appointment",
                      onTap: () {
                        Routes.instance.push(
                          widget:
                              //  AccountCreateForm(),
                              // SuperCategoryPage(),
                              AddNewAppointment(salonModel: widget.salonModel),
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 5),
              SizedBox(
                height: Dimensions.dimenisonNo16,
              ),
              // Show booking list for the selected date
              _isLoading
                  ? Padding(
                      padding: EdgeInsets.only(top: Dimensions.dimenisonNo200),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: Consumer<BookingProvider>(
                        builder: (context, bookingProvider, child) {
                          if (bookingProvider.getBookingList.isEmpty) {
                            return const Center(
                              child:
                                  Text('No bookings available for this date.'),
                            );
                          }
                          return ListView.builder(
                            itemCount: bookingProvider.getBookingList.length,
                            itemBuilder: (context, _index) {
                              AppointModel order =
                                  bookingProvider.getBookingList[_index];

                              return FutureBuilder<UserModel>(
                                future: setUser(order),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  UserModel user = snapshot.data!;
                                  int _no = _index + 1;

                                  return GestureDetector(
                                    onTap: () {
                                      widget.onBookingSelected(
                                          order, user, _index);
                                      print("User: ${user.name}");
                                      // bookingProvider
                                      //     .selectAppointUserPro(user);
                                    },
                                    child: UserBookingTap(
                                      appointModel: order,
                                      userModel: user,
                                      index: _no,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
        if (_showCalendar)
          Positioned(
            left: Dimensions.dimenisonNo50,
            top: Dimensions.dimenisonNo50,
            child: SizedBox(
              height: Dimensions.dimenisonNo450,
              width: Dimensions.dimenisonNo360,
              child: CustomCalendar(
                salonModel: widget.salonModel,
                controller: _dateController,
                initialDate: widget.date,
                onDateChanged: (selectedDate) {
                  setState(() {
                    widget.date = selectedDate;
                    _updateDateController();
                    _fetchBookings();
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  Stack userListWebWidget(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showCalendar = false;
            });
          },
          child: Column(
            children: [
              Container(
                padding: ResponsiveLayout.isMobile(context)
                    ? EdgeInsets.only(
                        left: Dimensions.dimenisonNo8,
                        right: Dimensions.dimenisonNo8,
                        top: Dimensions.dimenisonNo8,
                      )
                    : EdgeInsets.only(
                        left: Dimensions.dimenisonNo16,
                        right: Dimensions.dimenisonNo16,
                        top: Dimensions.dimenisonNo10,
                      ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: Dimensions.dimenisonNo10),

                    // Decrease date button
                    GestureDetector(
                      onTap: _decrementDate,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B4B4B),
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimenisonNo5),
                        ),
                        child: const Icon(
                          Icons.arrow_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo10),
                      child: Center(
                        child: Text(
                          _formatDate(widget.date),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveLayout.isDesktop(context)
                                ? Dimensions.dimenisonNo16
                                : Dimensions.dimenisonNo14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    // Increase date button
                    GestureDetector(
                      onTap: _incrementDate,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B4B4B),
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimenisonNo5),
                        ),
                        child: const Icon(
                          Icons.arrow_right_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.dimenisonNo12),

                    // Toggle calendar visibility
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showCalendar = !_showCalendar;
                        });
                      },
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
                    ResponsiveLayout.isMobile(context)
                        ? SizedBox()
                        : Text(
                            widget.salonModel.name ?? 'Salon Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.dimenisonNo16),
                          ),

                    const Spacer(),
                    AddButton(
                      text: ResponsiveLayout.isMobile(context)
                          ? "Appointment"
                          : "Add Appointment",
                      onTap: () {
                        Routes.instance.push(
                          widget:
                              AddNewAppointment(salonModel: widget.salonModel),
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 5),
              SizedBox(
                height: Dimensions.dimenisonNo16,
              ),
              // Show booking list for the selected date
              _isLoading
                  ? Padding(
                      padding: EdgeInsets.only(top: Dimensions.dimenisonNo200),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: Consumer<BookingProvider>(
                        builder: (context, bookingProvider, child) {
                          if (bookingProvider.getBookingList.isEmpty) {
                            return const Center(
                              child:
                                  Text('No bookings available for this date.'),
                            );
                          }
                          return ListView.builder(
                            itemCount: bookingProvider.getBookingList.length,
                            itemBuilder: (context, _index) {
                              AppointModel order =
                                  bookingProvider.getBookingList[_index];

                              return FutureBuilder<UserModel>(
                                future: setUser(order),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  UserModel user = snapshot.data!;
                                  int _no = _index + 1;

                                  return GestureDetector(
                                    onTap: () {
                                      widget.onBookingSelected(
                                          order, user, _index);
                                    },
                                    child: UserBookingTap(
                                      appointModel: order,
                                      userModel: user,
                                      index: _no,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
        if (_showCalendar)
          ResponsiveLayout.isMobile(context)
              ? Positioned(
                  left: Dimensions.dimenisonNo20,
                  top: Dimensions.dimenisonNo50,
                  right: Dimensions.dimenisonNo20,
                  child: SizedBox(
                    height: Dimensions.dimenisonNo400,
                    child: CustomCalendar(
                      salonModel: widget.salonModel,
                      controller: _dateController,
                      initialDate: widget.date,
                      onDateChanged: (selectedDate) {
                        setState(() {
                          widget.date = selectedDate;
                          _updateDateController();
                          _fetchBookings();
                        });
                      },
                    ),
                  ),
                )
              : ResponsiveLayout.isTablet(context)
                  ? Positioned(
                      left: Dimensions.dimenisonNo30,
                      top: Dimensions.dimenisonNo60,
                      right: Dimensions.dimenisonNo30,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight:
                              Dimensions.dimenisonNo300, // Minimum height
                          maxHeight:
                              Dimensions.dimenisonNo600, // Maximum height
                        ),
                        child: CustomCalendar(
                          salonModel: widget.salonModel,
                          controller: _dateController,
                          initialDate: widget.date,
                          onDateChanged: (selectedDate) {
                            setState(() {
                              widget.date = selectedDate;
                              _updateDateController();
                              _fetchBookings();
                            });
                          },
                        ),
                      ),
                    )
                  : Positioned(
                      left: Dimensions.dimenisonNo50,
                      top: Dimensions.dimenisonNo50,
                      child: SizedBox(
                        height: Dimensions.dimenisonNo450,
                        width: Dimensions.dimenisonNo360,
                        child: CustomCalendar(
                          salonModel: widget.salonModel,
                          controller: _dateController,
                          initialDate: widget.date,
                          onDateChanged: (selectedDate) {
                            setState(() {
                              widget.date = selectedDate;
                              _updateDateController();
                              _fetchBookings();
                            });
                          },
                        ),
                      ),
                    ),
      ],
    );
  }

// Update `setUser` function to return Future<UserModel>
  Future<UserModel> setUser(AppointModel order) async {
    return order.isMadual
        ? order.userModel
        : await UserBookingFB.instance.getUserInforOrderFB(order.userId);
  }
}
