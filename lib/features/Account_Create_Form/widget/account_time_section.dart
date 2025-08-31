// ignore_for_file: must_be_immutable, annotate_overrides, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class PickTimeSection extends StatefulWidget {
  TextEditingController openController;
  TextEditingController closeController;
  DateTime? openTime;
  DateTime? closeTime;
  String heading;

  final Function(DateTime)? onOpenTimeSelected;
  final Function(DateTime)? onCloseTimeSelected;

  PickTimeSection({
    super.key,
    required this.openController,
    required this.closeController,
    this.openTime,
    this.closeTime,
    this.heading = "Select the timing of ${GlobalVariable.salon}",
    this.onOpenTimeSelected, // ✅ Callback for open time
    this.onCloseTimeSelected, // ✅ Callback for close time
  });

  @override
  State<PickTimeSection> createState() => _PickTimeSectionState();
}

class _PickTimeSectionState extends State<PickTimeSection> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.openController.text.isEmpty) {
      widget.openController.text = GlobalVariable.OpenTime != null
          ? _formatTimeOfDay(GlobalVariable.OpenTime)
          : _formatTimeOfDay(TimeOfDay.now());
    }
    if (widget.closeController.text.isEmpty) {
      widget.closeController.text = GlobalVariable.CloseTime != null
          ? _formatTimeOfDay(GlobalVariable.CloseTime)
          : _formatTimeOfDay(TimeOfDay.now());
    }
  }

  DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hours.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')} $period';
  }

  TimeOfDay _selectedTimeOpen = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _selectedTimeClose = TimeOfDay(hour: 0, minute: 0);

  Future<void> _selectTimesOpen(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTimeOpen);
    if (picked != null) {
      setState(() {
        _selectedTimeOpen = picked;
        widget.openTime = timeOfDayToDateTime(picked);
        GlobalVariable.OpenTime = picked;
        GlobalVariable.openTimeGlo = picked;
        widget.openController.text = _formatTimeOfDay(picked);

        if (widget.onOpenTimeSelected != null) {
          widget.onOpenTimeSelected!(
              timeOfDayToDateTime(picked)); // ✅ Trigger callback
        }
      });
    }
  }

  Future<void> _selectTimesClose(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTimeClose);
    if (picked != null) {
      setState(() {
        _selectedTimeClose = picked;
        widget.closeTime = timeOfDayToDateTime(picked);
        GlobalVariable.CloseTime = picked;
        GlobalVariable.closerTimeGlo = picked;
        widget.closeController.text = _formatTimeOfDay(picked);

        if (widget.onCloseTimeSelected != null) {
          widget.onCloseTimeSelected!(
              timeOfDayToDateTime(picked)); // ✅ Trigger callback
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.heading,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimensionNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: const Color(0xFFFC0000),
                  fontSize: Dimensions.dimensionNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  height: 0,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.dimensionNo5),
        Padding(
          padding: EdgeInsets.only(left: Dimensions.dimensionNo16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Opening Time ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimensionNo16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.dimensionNo20),
                    child: Icon(
                      CupertinoIcons.stopwatch,
                      size: Dimensions.dimensionNo16,
                    ),
                  ),
                  Container(
                    width: Dimensions.dimensionNo100,
                    height: Dimensions.dimensionNo30,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEEFF3),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Colors.black),
                        borderRadius:
                            BorderRadius.circular(Dimensions.dimensionNo5),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _selectTimesOpen(context),
                      child: Center(
                        child: Text(
                          _selectedTimeOpen.format(context),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimensionNo16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: Dimensions.dimensionNo10),
              Row(
                children: [
                  Text(
                    'Closing Time  ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimensionNo16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  ),
                  SizedBox(width: Dimensions.dimensionNo22),
                  Icon(
                    CupertinoIcons.stopwatch,
                    size: Dimensions.dimensionNo16,
                  ),
                  SizedBox(width: Dimensions.dimensionNo20),
                  Container(
                    width: Dimensions.dimensionNo100,
                    height: Dimensions.dimensionNo30,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEEFF3),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Colors.black),
                        borderRadius:
                            BorderRadius.circular(Dimensions.dimensionNo5),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _selectTimesClose(context),
                      child: Center(
                        child: Text(
                          _selectedTimeClose.format(context),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimensionNo16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
