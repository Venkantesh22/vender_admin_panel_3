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
//         width: Dimensions.dimenisonNo200,
//         height: Dimensions.dimenisonNo45,
//         decoration: ShapeDecoration(
//           color: bgColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(Dimensions.dimenisonNo60),
//           ),
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               width: Dimensions.dimenisonNo16,
//             ),
//             Container(
//               width: Dimensions.dimenisonNo24,
//               height: Dimensions.dimenisonNo24,
//               decoration: BoxDecoration(
//                   borderRadius:
//                       BorderRadius.circular(Dimensions.dimenisonNo100),
//                   border: Border.all(color: iconColor!, width: 2)),
//               child: Icon(Icons.add,
//                   color: iconColor!, size: Dimensions.dimenisonNo18),
//             ),
//             SizedBox(
//               width: Dimensions.dimenisonNo10,
//             ),
//             Text(
//               text,
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: Dimensions.dimenisonNo18,
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
import 'package:samay_admin_plan/utility/dimenison.dart';

class AddButton extends StatelessWidget {
  final String text;
  Color? bgColor;
  Color? textColor;
  Color? iconColor;
  final VoidCallback onTap;

  AddButton({
    Key? key,
    required this.text,
    this.bgColor = AppColor.mainColor,
    this.textColor = Colors.white,
    this.iconColor = const Color(0xFF08BA85),
    required this.onTap,
  }) : super(key: key);

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
        height: Dimensions.dimenisonNo45,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo60),
          ),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Adjusts the button size to fit content
          children: [
            SizedBox(
              width: Dimensions.dimenisonNo16,
            ),
            Container(
              width: Dimensions.dimenisonNo24,
              height: Dimensions.dimenisonNo24,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.dimenisonNo100),
                  border: Border.all(color: iconColor!, width: 2)),
              child: Icon(Icons.add,
                  color: iconColor!, size: Dimensions.dimenisonNo18),
            ),
            SizedBox(
              width: Dimensions.dimenisonNo10,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: Dimensions.dimenisonNo18,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(
              width: Dimensions.dimenisonNo16,
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
        height: Dimensions.dimenisonNo40,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo50),
          ),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Adjusts the button size to fit content
          children: [
            SizedBox(
              width: Dimensions.dimenisonNo12,
            ),
            Container(
              width: Dimensions.dimenisonNo20,
              height: Dimensions.dimenisonNo20,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.dimenisonNo100),
                  border: Border.all(color: iconColor!, width: 2)),
              child: Icon(Icons.add,
                  color: iconColor!, size: Dimensions.dimenisonNo16),
            ),
            SizedBox(
              width: Dimensions.dimenisonNo8,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: Dimensions.dimenisonNo16,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(
              width: Dimensions.dimenisonNo12,
            ),
          ],
        ),
      ),
    );
  }
}
