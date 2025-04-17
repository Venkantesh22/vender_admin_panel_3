import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

// ignore: must_be_immutable
class WeekRow extends StatefulWidget {
  final String dayOfWeek;
  TextEditingController time;
  String value;

  WeekRow({
    super.key,
    required this.dayOfWeek,
    required this.time,
    this.value = "",
  });

  @override
  State<WeekRow> createState() => _WeekRowState();
}

class _WeekRowState extends State<WeekRow> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    String? _Timing;
    final List<String> _timeOrClose = [
      "${appProvider.getSalonInformation.openTime?.format(context).toString()} To ${appProvider.getSalonInformation.closeTime!.format(context).toString()}",
      'Close',
    ];
    String? dropdownValue = widget.value.isNotEmpty
        ? _timeOrClose.contains(widget.value)
            ? widget.value
            : null
        : (widget.time.text.isNotEmpty &&
                _timeOrClose.contains(widget.time.text))
            ? widget.time.text
            : null;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimenisonNo10
              : Dimensions.dimenisonNo30,
          vertical: Dimensions.dimenisonNo10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.dayOfWeek,
            style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimenisonNo14
                  : Dimensions.dimenisonNo16,
              fontFamily: GoogleFonts.roboto().fontFamily,
              letterSpacing: 0.02,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: Dimensions.dimenisonNo50,
            width: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimenisonNo200
                : Dimensions.dimenisonNo250,
            child: DropdownButtonFormField<String>(
              hint: Text(
                'Select Time',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimenisonNo14
                      : Dimensions.dimenisonNo16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.40,
                ),
              ),
              value: dropdownValue, // ✅ Ensured valid value
              items: _timeOrClose.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  widget.time.text = newValue!;
                });
              },
            ),
          ),
          SizedBox(
            width: Dimensions.dimenisonNo10,
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:samay_admin_plan/constants/responsive_layout.dart';
// import 'package:samay_admin_plan/provider/app_provider.dart';
// import 'package:samay_admin_plan/utility/dimenison.dart';

// // ignore: must_be_immutable
// class WeekRow extends StatefulWidget {
//   final String dayOfWeek;
//   TextEditingController time;
//   String value;

//   WeekRow({
//     super.key,
//     required this.dayOfWeek,
//     required this.time,
//     this.value = "",
//   });

//   @override
//   State<WeekRow> createState() => _WeekRowState();
// }

// class _WeekRowState extends State<WeekRow> {
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);

//     String? _Timing;
//     final List<String> _timeOrClose = [
//       "${appProvider.getSalonInformation.openTime?.format(context).toString()} To ${appProvider.getSalonInformation.closeTime!.format(context).toString()}",
//       'Close',
//     ];
//     String? dropdownValue = widget.value.isNotEmpty
//         ? _timeOrClose.contains(widget.value)
//             ? widget.value
//             : null
//         : (widget.time.text.isNotEmpty &&
//                 _timeOrClose.contains(widget.time.text))
//             ? widget.time.text
//             : null;

//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: ResponsiveLayout.isMobile(context)
//               ? Dimensions.dimenisonNo10
//               : Dimensions.dimenisonNo30,
//           vertical: Dimensions.dimenisonNo10),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             widget.dayOfWeek,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? Dimensions.dimenisonNo14
//                   : Dimensions.dimenisonNo16,
//               fontFamily: GoogleFonts.roboto().fontFamily,
//               letterSpacing: 0.02,
//             ),
//           ),
//           const Spacer(),
//           SizedBox(
//             height: Dimensions.dimenisonNo50,
//             width: ResponsiveLayout.isMobile(context)
//                 ? Dimensions.dimenisonNo200
//                 : Dimensions.dimenisonNo250,
//             child: DropdownButtonFormField<String>(
//               hint: Text(
//                 'Select Time',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: ResponsiveLayout.isMobile(context)
//                       ? Dimensions.dimenisonNo14
//                       : Dimensions.dimenisonNo16,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.40,
//                 ),
//               ),
//               value: dropdownValue, // ✅ Ensured valid value
//               items: _timeOrClose.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 setState(() {
//                   widget.time.text = newValue!;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
