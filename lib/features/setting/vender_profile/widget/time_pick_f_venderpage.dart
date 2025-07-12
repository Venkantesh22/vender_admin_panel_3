import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class PickTimeSectionForVenderPage extends StatefulWidget {
  TextEditingController openController;
  TextEditingController closeController;
  TimeOfDay openTime;
  TimeOfDay closeTime;
  String heading;
  final Function(TimeOfDay)? onOpenTimeSelected;
  final Function(TimeOfDay)? onCloseTimeSelected;

  PickTimeSectionForVenderPage({
    super.key,
    required this.openController,
    required this.closeController,
    required this.openTime,
    required this.closeTime,
    this.heading = "Select the timing of ${GlobalVariable.salon}",
    this.onOpenTimeSelected, // ✅ Callback for open time
    this.onCloseTimeSelected,
  });

  @override
  State<PickTimeSectionForVenderPage> createState() =>
      _PickTimeSectionForVenderPageState();
}

class _PickTimeSectionForVenderPageState
    extends State<PickTimeSectionForVenderPage> {
  late TimeOfDay _selectedTimeOpen;
  late TimeOfDay _selectedTimeClose;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.openController.text.isEmpty) {
      widget.openController.text = GlobalVariable.OpenTime != null
          ? _formatTimeOfDay(GlobalVariable.OpenTime!)
          : _formatTimeOfDay(TimeOfDay.now());
    }
    if (widget.closeController.text.isEmpty) {
      widget.closeController.text = GlobalVariable.CloseTime != null
          ? _formatTimeOfDay(GlobalVariable.CloseTime!)
          : _formatTimeOfDay(TimeOfDay.now());
    }

    _selectedTimeOpen = widget.openTime;
    _selectedTimeClose = widget.closeTime;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hours.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _selectTimesOpen(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTimeOpen);
    if (picked != null) {
      setState(() {
        _selectedTimeOpen = picked;
        // print("Direct form open ${picked.toString()}");
        GlobalVariable.OpenTime = picked;
        GlobalVariable.openTimeGlo = picked;
        widget.openController.text = _formatTimeOfDay(picked);
        if (widget.onOpenTimeSelected != null) {
          widget.onOpenTimeSelected!(picked); // ✅ Trigger callback
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
        // print("Direct form close ${picked.toString()}");

        GlobalVariable.CloseTime = picked;
        GlobalVariable.closerTimeGlo = picked;
        widget.closeController.text = _formatTimeOfDay(picked);
        if (widget.onCloseTimeSelected != null) {
          widget.onCloseTimeSelected!(picked); // ✅ Trigger callback
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
          padding: ResponsiveLayout.isMobile(context)
              ? EdgeInsets.zero
              : EdgeInsets.only(left: Dimensions.dimensionNo16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  openCloseText('Opening Time'),
                  stopWatctIcons(context),
                  selectTimeTextBox(
                    context,
                    () => _selectTimesOpen(context),
                    _selectedTimeOpen.format(context),
                  )
                ],
              ),
              SizedBox(height: Dimensions.dimensionNo10),
              Row(
                children: [
                  openCloseText('Closing Time'),
                  stopWatctIcons(context),
                  selectTimeTextBox(
                    context,
                    () => _selectTimesClose(context),
                    _selectedTimeClose.format(context),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Container selectTimeTextBox(
      BuildContext context, VoidCallback onTap, String time) {
    return Container(
      width: Dimensions.dimensionNo100,
      height: Dimensions.dimensionNo30,
      decoration: ShapeDecoration(
        color: const Color(0xFFEEEFF3),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            time,
            //
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimensionNo16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Padding stopWatctIcons(BuildContext context) {
    return Padding(
      padding: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo8)
          : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo20),
      child: Icon(
        CupertinoIcons.stopwatch,
        size: Dimensions.dimensionNo16,
      ),
    );
  }

  Text openCloseText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: Dimensions.dimensionNo16,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
    );
  }
}
