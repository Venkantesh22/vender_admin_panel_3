import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/custom_chip.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/pricerow.dart';

class SingleServiceOrderList extends StatelessWidget {
  final ServiceModel serviceModel;
  final bool showDelectIcon;

  const SingleServiceOrderList({
    Key? key,
    required this.serviceModel,
    required this.showDelectIcon,
  }) : super(key: key);

  // @override
  @override
  Widget build(BuildContext context) {
    Duration? _serviceDuration =
        Duration(minutes: serviceModel.serviceDurationMin);
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.dimenisonNo12),
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.dimenisonNo5,
          horizontal: Dimensions.dimenisonNo12),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.dimenisonNo12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '▪️ ${serviceModel.servicesName}',
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.dimenisonNo8),
                      child: Text(
                        'service code : ${serviceModel.serviceCode}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimensions.dimenisonNo10,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CustomChip(
                  text: serviceModel.categoryName,
                )
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.dimenisonNo5,
                  ),
                  Row(
                    children: [
                      Text(
                        "During : ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo12,
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
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            )
                          : SizedBox(),
                      Text(
                        "${(_serviceDuration.inMinutes % 60).toString()}min",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.dimenisonNo5,
                  ),
                  PriceRow(serviceModel: serviceModel),
                ],
              ),
              const Spacer(),
              showDelectIcon
                  ? IconButton(
                      onPressed: () {
                        try {
                          showLoaderDialog(context);
                          // appProvider.removeServiceToWatchList(serviceModel);
                          // appProvider.calculateSubTotal();
                          // appProvider.calculateTotalBookingDuration();

                          // Navigator.of(context, rootNavigator: true).pop();

                          showMessage('Service is removed from Watch List');
                        } catch (e) {
                          showMessage(
                              'Error occurred while removing service from Watch List: ${e.toString()}');
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: Dimensions.dimenisonNo30,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                width: Dimensions.dimenisonNo20,
              )
            ],
          ),
        ],
      ),
    );
  }
}
