import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/custom_chip.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/pricerow.dart';

class SingleServiceTapDeleteIcon extends StatelessWidget {
  final ServiceModel serviceModel;
  final VoidCallback onTap;

  const SingleServiceTapDeleteIcon({
    Key? key,
    required this.serviceModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration? _serviceDuration =
        Duration(minutes: serviceModel.serviceDurationMin);

    // Determine if the screen is mobile
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.dimensionNo12),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.dimensionNo5,
        horizontal: Dimensions.dimensionNo12,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.dimensionNo12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '▪️ ${serviceModel.servicesName}',
                        style: TextStyle(
                          overflow: TextOverflow.clip,
                          color: Colors.black,
                          fontSize: isMobile
                              ? Dimensions.dimensionNo12
                              : Dimensions.dimensionNo14,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.dimensionNo8),
                        child: Text(
                          'Service Code: ${serviceModel.serviceCode}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isMobile
                                ? Dimensions.dimensionNo10
                                : Dimensions.dimensionNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomChip(
                  text: serviceModel.categoryName,
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.dimensionNo5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Duration: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isMobile
                              ? Dimensions.dimensionNo10
                              : Dimensions.dimensionNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      _serviceDuration.inHours >= 1
                          ? Text(
                              ' ${_serviceDuration.inHours.toString()}h : ',
                              style: TextStyle(
                                color: AppColor.serviceTapTextColor,
                                fontSize: isMobile
                                    ? Dimensions.dimensionNo10
                                    : Dimensions.dimensionNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            )
                          : const SizedBox(),
                      Text(
                        "${(_serviceDuration.inMinutes % 60).toString()}min",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isMobile
                              ? Dimensions.dimensionNo10
                              : Dimensions.dimensionNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.dimensionNo5,
                  ),
                  PriceRow(serviceModel: serviceModel),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: isMobile
                      ? Dimensions.dimensionNo24
                      : Dimensions.dimensionNo30,
                ),
              ),
              SizedBox(
                width: Dimensions.dimensionNo20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
