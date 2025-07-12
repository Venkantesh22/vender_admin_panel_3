import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class TimeSlot extends StatefulWidget {
  final String section;
  final List<String> timeSlots;
  final String? selectedTimeSlot;
  final int serviceDurationInMinutes;
  final DateTime? endTime;
  final ValueChanged<String> onTimeSlotSelected;

  const TimeSlot({
    super.key,
    required this.section,
    required this.timeSlots,
    required this.selectedTimeSlot,
    required this.serviceDurationInMinutes,
    required this.endTime,
    required this.onTimeSlotSelected,
  });

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  @override
  Widget build(BuildContext context) {
    if (widget.timeSlots.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          widget.section,
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimensionNo14 // Smaller font for mobile
                : Dimensions.dimensionNo16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Dimensions.dimensionNo12),
        // Time slots grid
        Container(
          color: Colors.white,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveLayout.isMobile(context)
                  ? 2
                  : 4, // Fewer columns for mobile
              childAspectRatio: ResponsiveLayout.isMobile(context)
                  ? 3
                  : 2.5, // Adjust aspect ratio
              crossAxisSpacing: Dimensions.dimensionNo10,
              mainAxisSpacing: Dimensions.dimensionNo10,
            ),
            itemCount: widget.timeSlots.length,
            itemBuilder: (context, index) {
              final timeSlot = widget.timeSlots[index];
              final DateTime slotStartTime =
                  DateFormat('hh:mm a').parse(timeSlot);
              final DateTime slotEndTime = slotStartTime
                  .add(Duration(minutes: widget.serviceDurationInMinutes));

              bool isWithinDuration = slotEndTime.isBefore(widget.endTime!) ||
                  slotEndTime.isAtSameMomentAs(widget.endTime!);

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.selectedTimeSlot == timeSlot
                      ? Colors.blue
                      : isWithinDuration
                          ? Colors.green
                          : Colors.grey,
                  foregroundColor: widget.selectedTimeSlot == timeSlot
                      ? Colors.white
                      : Colors.black,
                  side: const BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo8 // Smaller padding for mobile
                        : Dimensions.dimensionNo12,
                  ),
                ),
                onPressed: isWithinDuration
                    ? () {
                        widget.onTimeSlotSelected(timeSlot);
                        setState(() {
                          Provider.of<BookingProvider>(context, listen: false)
                              .updatAppointStartTime(slotStartTime);

                          Provider.of<BookingProvider>(context, listen: false)
                              .updateAppointEndTime(slotEndTime);

                          Provider.of<BookingProvider>(context, listen: false)
                              .updateAppointDuration(Duration(
                                  minutes: widget.serviceDurationInMinutes));
                        });
                      }
                    : null,
                child: Text(
                  timeSlot,
                  style: TextStyle(
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo12 // Smaller font for mobile
                        : Dimensions.dimensionNo14,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: Dimensions.dimensionNo16),
      ],
    );
  }
}
