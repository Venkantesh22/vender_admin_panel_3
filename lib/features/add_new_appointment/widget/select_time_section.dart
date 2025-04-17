import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSlotGrid extends StatelessWidget {
  final String openTime;
  final String closeTime;
  final List<DateTime> selectedTimeSlots;
  final Function(DateTime) onSlotTapped;

  const TimeSlotGrid({
    Key? key,
    required this.openTime,
    required this.closeTime,
    required this.selectedTimeSlots,
    required this.onSlotTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime open;
    DateTime close;

    try {
      open = _parseTime(openTime);
      close = _parseTime(closeTime);
    } catch (e) {
      // Handle parsing error
      print('Error parsing time: $e');
      return Center(child: Text('Invalid time format.'));
    }

    // Generate time slots
    List<DateTime> timeSlots = [];
    for (var slot = open;
        slot.isBefore(close);
        slot = slot.add(Duration(minutes: 30))) {
      timeSlots.add(slot);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        DateTime slot = timeSlots[index];
        bool isSelected = selectedTimeSlots.contains(slot);

        return GestureDetector(
          onTap: () => onSlotTapped(slot),
          child: Container(
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                DateFormat.jm().format(slot),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  DateTime _parseTime(String timeString) {
    try {
      // Normalize the time string to handle various formats
      String normalizedTime = _normalizeTimeString(timeString);
      return DateFormat('h:mm a').parse(normalizedTime);
    } catch (e) {
      print('Error initializing time: $e');
      throw FormatException('Invalid time format');
    }
  }

  String _normalizeTimeString(String timeString) {
    // Ensure that the time format is consistent
    return timeString.trim().replaceAllMapped(
          RegExp(r'(\d{1,2})\s*:\s*(\d{2})\s*(AM|PM)'),
          (match) => '${match[1]!.padLeft(2, '0')}:${match[2]} ${match[3]}',
        );
  }
}
