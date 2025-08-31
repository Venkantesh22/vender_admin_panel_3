import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class StateText extends StatelessWidget {
  final String status; // Mark appointModel as final
  const StateText({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Check if appointModel is null and handle it gracefully
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // reschedule state

        // (Update) state
        status == "(Update)"
            ? Text(
                status,
                style: GoogleFonts.roboto(
                    fontSize: Dimensions.dimensionNo16,
                    color: AppColor.buttonColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .90),
              )
            // Pending state
            : status == "Pending"
                ? Row(
                    children: [
                      Icon(
                        CupertinoIcons.exclamationmark_circle,
                        size: Dimensions.dimensionNo18,
                        color: Colors.red,
                      ),
                      SizedBox(width: Dimensions.dimensionNo5),
                      Text(
                        status,
                        style: GoogleFonts.roboto(
                          fontSize: Dimensions.dimensionNo16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                // Confirmed state
                : status == "Confirmed"
                    ? Row(
                        children: [
                          Icon(
                            CupertinoIcons.checkmark_alt_circle,
                            size: Dimensions.dimensionNo18,
                            color: Colors.white,
                          ),
                          SizedBox(width: Dimensions.dimensionNo5),
                          Text(
                            status,
                            style: GoogleFonts.roboto(
                              fontSize: Dimensions.dimensionNo16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    :
                    // Completed state
                    status == "Completed"
                        ? Row(
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt_circle,
                                size: Dimensions.dimensionNo18,
                                color: Colors.blue,
                              ),
                              SizedBox(width: Dimensions.dimensionNo5),
                              Text(
                                status,
                                style: GoogleFonts.roboto(
                                  fontSize: Dimensions.dimensionNo16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        // Cancel state
                        : status == "(Cancel)"
                            ? Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 1.5, color: Colors.red),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: Dimensions.dimensionNo16,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.dimensionNo5),
                                  Text(
                                    status,
                                    style: GoogleFonts.roboto(
                                      fontSize: Dimensions.dimensionNo16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : status == "InProcces"
                                ? Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.checkmark_alt_circle,
                                        size: Dimensions.dimensionNo14,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: Dimensions.dimensionNo10),
                                      Text(
                                        status,
                                        style: GoogleFonts.roboto(
                                          fontSize: Dimensions.dimensionNo16,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : status == "Check-In"
                                    ? Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.checkmark_alt_circle,
                                            size: Dimensions.dimensionNo14,
                                            color: Colors.orange,
                                          ),
                                          SizedBox(
                                              width: Dimensions.dimensionNo10),
                                          Text(
                                            status,
                                            style: GoogleFonts.roboto(
                                              fontSize:
                                                  Dimensions.dimensionNo16,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    // Bill Generate
                                    : status == "Bill Generate"
                                        ? Text(
                                            status,
                                            style: GoogleFonts.roboto(
                                                fontSize:
                                                    Dimensions.dimensionNo16,
                                                color: AppColor.orangeColor,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: .90),
                                          )
                                        : Text(
                                            status,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize:
                                                  Dimensions.dimensionNo16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
      ],
    );
  }
}
