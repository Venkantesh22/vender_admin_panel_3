// ignore_for_file: prefer_final_fields, curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final SalonModel salonModel;
  final TextEditingController controller;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const CustomCalendar({
    super.key,
    required this.salonModel,
    required this.controller,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _selectedDate = DateTime.now(); // Track selected date

  List<String> _closedDays = []; // List of closed days
  List<DateTime> _appointmentDates =
      []; // List of appointment dates as DateTime

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _findClosedDays();
    getAppointmentList();
  }

  // Find the salon's closed days based on the model
  void _findClosedDays() {
    _closedDays.clear();
    if (widget.salonModel.monday?.toLowerCase() == 'close')
      _closedDays.add('Monday');
    if (widget.salonModel.tuesday?.toLowerCase() == 'close')
      _closedDays.add('Tuesday');
    if (widget.salonModel.wednesday?.toLowerCase() == 'close')
      _closedDays.add('Wednesday');
    if (widget.salonModel.thursday?.toLowerCase() == 'close')
      _closedDays.add('Thursday');
    if (widget.salonModel.friday?.toLowerCase() == 'close')
      _closedDays.add('Friday');
    if (widget.salonModel.saturday?.toLowerCase() == 'close')
      _closedDays.add('Saturday');
    if (widget.salonModel.sunday?.toLowerCase() == 'close')
      _closedDays.add('Sunday');
  }

  // Check if the salon is closed on a given date
  bool _isSalonClosed(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return widget.salonModel.monday?.toLowerCase() == 'close';
      case DateTime.tuesday:
        return widget.salonModel.tuesday?.toLowerCase() == 'close';
      case DateTime.wednesday:
        return widget.salonModel.wednesday?.toLowerCase() == 'close';
      case DateTime.thursday:
        return widget.salonModel.thursday?.toLowerCase() == 'close';
      case DateTime.friday:
        return widget.salonModel.friday?.toLowerCase() == 'close';
      case DateTime.saturday:
        return widget.salonModel.saturday?.toLowerCase() == 'close';
      case DateTime.sunday:
        return widget.salonModel.sunday?.toLowerCase() == 'close';
      default:
        return false;
    }
  }

  // Fetch appointments and parse dates into _appointmentDates
  Future<void> getAppointmentList() async {
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    await serviceProvider.fetchAppointmentDatePro(
        widget.salonModel.adminId, widget.salonModel.id);

    // Convert appointment dates from string to DateTime
    setState(() {
      _appointmentDates = serviceProvider.appointDate.map((saveDate) {
        return saveDate.date;
      }).toList();
    });
  }

  // Check if a given date is an appointment date
  bool _isAppointmentDate(DateTime date) {
    return _appointmentDates
        .any((appointmentDate) => isSameDay(date, appointmentDate));
  }

  @override
  Widget build(BuildContext context) {
    CalenderProvider calenderProvider = Provider.of<CalenderProvider>(context);
    return Container(
      padding: EdgeInsets.all(Dimensions.dimenisonNo5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            255, 179, 250, 182), // Background color for the calendar
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo20),
      ),
      child: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime(2023),
            lastDay: DateTime(2030),
            holidayPredicate: _isSalonClosed,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (_isSalonClosed(selectedDay)) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Weekday Holiday'),
                    content: Text('The salon is closed on the selected date.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() {
                  _selectedDate = selectedDay;

                  widget.controller.text =
                      DateFormat('dd MMM yyyy').format(_selectedDate);
                  widget.onDateChanged(_selectedDate);
                  calenderProvider.setSelectDate(selectedDay);
                });
                // Update provider state
                Provider.of<BookingProvider>(context, listen: false)
                    .updateSelectedDate(selectedDay);
              }
            },
            calendarBuilders: CalendarBuilders(
              holidayBuilder: (context, date, _) => Center(
                child: Container(
                  margin: EdgeInsets.all(Dimensions.dimenisonNo5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red, // Color for holidays
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              selectedBuilder: (context, date, events) => Center(
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.buttonColor, // Color for selected day
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              defaultBuilder: (context, date, _) {
                if (_isAppointmentDate(date)) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(Dimensions.dimenisonNo5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange, // Color for appointment dates
                      ),
                      child: Center(
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: Dimensions.dimenisonNo10,
          ),
          Row(
            children: [
              SizedBox(
                width: Dimensions.dimenisonNo5,
              ),
              colorName(Colors.red, "Holiday"),
              SizedBox(
                width: Dimensions.dimenisonNo10,
              ),
              colorName(Colors.orange, "Appointment"),
            ],
          ),
        ],
      ),
    );
  }

  Row colorName(Color color, String name) {
    return Row(
      children: [
        CircleAvatar(
          radius: Dimensions.dimenisonNo10,
          backgroundColor: color,
        ),
        SizedBox(
          width: Dimensions.dimenisonNo5,
        ),
        Text(
          name,
          style: TextStyle(
              color: color,
              fontSize: Dimensions.dimenisonNo12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
