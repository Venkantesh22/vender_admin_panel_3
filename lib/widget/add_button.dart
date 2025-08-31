// ignore_for_file: must_be_immutable

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:samay_admin_plan/utility/color.dart';
// import 'package:samay_admin_plan/utility/dimenison.dart';

// class AddButton extends StatelessWidget {
//   final String text;
//   Color? bgColor;
//   Color? textColor;
//   Color? iconColor;
//   final VoidCallback onTap;

//   AddButton({
//     Key? key,
//     required this.text,
//     this.bgColor = AppColor.mainColor,
//     this.textColor = Colors.white,
//     this.iconColor = const Color(0xFF08BA85),
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoButton(
//       padding: EdgeInsets.zero,
//       onPressed: onTap,
//       child: Container(
//         width: Dimensions.dimensionNo200,
//         height: Dimensions.dimensionNo45,
//         decoration: ShapeDecoration(
//           color: bgColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(Dimensions.dimensionNo60),
//           ),
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               width: Dimensions.dimensionNo16,
//             ),
//             Container(
//               width: Dimensions.dimensionNo24,
//               height: Dimensions.dimensionNo24,
//               decoration: BoxDecoration(
//                   borderRadius:
//                       BorderRadius.circular(Dimensions.dimensionNo100),
//                   border: Border.all(color: iconColor!, width: 2)),
//               child: Icon(Icons.add,
//                   color: iconColor!, size: Dimensions.dimensionNo18),
//             ),
//             SizedBox(
//               width: Dimensions.dimensionNo10,
//             ),
//             Text(
//               text,
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: Dimensions.dimensionNo18,
//                 fontFamily: GoogleFonts.roboto().fontFamily,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 0.15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';

import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class AddButton extends StatelessWidget {
  final String text;
  Color? bgColor;
  Color? textColor;
  Color? iconColor;
  final VoidCallback onTap;

  AddButton({
    super.key,
    required this.text,
    this.bgColor = AppColor.mainColor,
    this.textColor = Colors.white,
    this.iconColor = const Color(0xFF08BA85),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout.isDesktop(context)
        ? addButtonWedWidget()
        : addButtonMobileWidget();

    //  ResponsiveLayout(
    //   mobile:,
    //   desktop: addButtonWedWidget(),
    // );
  }

  // Desktop Widget
  CupertinoButton addButtonWedWidget() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: Dimensions.dimensionNo45,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo60),
          ),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Adjusts the button size to fit content
          children: [
            SizedBox(
              width: Dimensions.dimensionNo16,
            ),
            Container(
              width: Dimensions.dimensionNo24,
              height: Dimensions.dimensionNo24,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.dimensionNo100),
                  border: Border.all(color: iconColor!, width: 2)),
              child: Icon(Icons.add,
                  color: iconColor!, size: Dimensions.dimensionNo18),
            ),
            SizedBox(
              width: Dimensions.dimensionNo10,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: Dimensions.dimensionNo18,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(
              width: Dimensions.dimensionNo16,
            ),
          ],
        ),
      ),
    );
  }

  // Mobile Widget
  CupertinoButton addButtonMobileWidget() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: Dimensions.dimensionNo40,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo50),
          ),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Adjusts the button size to fit content
          children: [
            SizedBox(
              width: Dimensions.dimensionNo12,
            ),
            Container(
              width: Dimensions.dimensionNo20,
              height: Dimensions.dimensionNo20,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.dimensionNo100),
                  border: Border.all(color: iconColor!, width: 2)),
              child: Icon(Icons.add,
                  color: iconColor!, size: Dimensions.dimensionNo16),
            ),
            SizedBox(
              width: Dimensions.dimensionNo8,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: Dimensions.dimensionNo16,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(
              width: Dimensions.dimensionNo12,
            ),
          ],
        ),
      ),
    );
  }
}
