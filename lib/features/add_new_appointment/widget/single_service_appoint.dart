import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/custom_button.dart';

class SingleServiceTapAppoint extends StatefulWidget {
  final ServiceModel serviceModel;
  const SingleServiceTapAppoint({
    super.key,
    required this.serviceModel,
  });

  @override
  State<SingleServiceTapAppoint> createState() => _SingleServiceTapState();
}

class _SingleServiceTapState extends State<SingleServiceTapAppoint> {
  bool _isAdd = false;

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    Duration? _serviceDuration =
        Duration(minutes: widget.serviceModel.serviceDurationMin);

    // Determine if the screen is mobile
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: Dimensions.dimensionNo16,
            right: Dimensions.dimensionNo16,
            top: Dimensions.dimensionNo10,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.dimensionNo8,
            horizontal: Dimensions.dimensionNo10,
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5),
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.serviceModel.servicesName,
                          style: TextStyle(
                            color: AppColor.serviceTapTextColor,
                            fontSize: isMobile
                                ? Dimensions.dimensionNo14
                                : Dimensions.dimensionNo16,
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: Dimensions.dimensionNo8),
                          child: Text(
                            'Service Code: ${widget.serviceModel.serviceCode}',
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
                  // CustomChip(text: widget.serviceModel.categoryName),

                  CustomButton(
                    buttonColor: bookingProvider.getWatchList
                            .contains(widget.serviceModel)
                        ? Colors.red
                        : AppColor.buttonColor,
                    ontap: () {
                      setState(() {
                        _isAdd = !_isAdd;
                      });
                      bookingProvider.getWatchList.contains(widget.serviceModel)
                          ? setState(() {
                              bookingProvider.removeServiceToWatchList(
                                  widget.serviceModel);
                              bookingProvider.calculateTotalBookingDuration();
                              bookingProvider.calculateSubTotal();
                            })
                          : setState(() {
                              bookingProvider
                                  .addServiceToWatchList(widget.serviceModel);
                              bookingProvider.calculateTotalBookingDuration();
                              bookingProvider.calculateSubTotal();
                            });
                    },
                    text: bookingProvider.getWatchList
                            .contains(widget.serviceModel)
                        ? "Remove -"
                        : "Add+",
                    width: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo100
                        : null,
                  ),
                ],
              ),
              // Padding(
              //   padding:
              //       EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
              //   child: const CustomDotttedLine(),
              // ),
              // Row(
              //   children: [
              //     Icon(
              //       Icons.watch_later_outlined,
              //       size: Dimensions.dimensionNo14,
              //       color: Colors.black,
              //     ),
              //     _serviceDuration.inHours >= 1
              //         ? Text(
              //             ' ${_serviceDuration.inHours.toString()}h : ',
              //             style: TextStyle(
              //               color: AppColor.serviceTapTextColor,
              //               fontSize: Dimensions.dimensionNo12,
              //               fontFamily: GoogleFonts.roboto().fontFamily,
              //               fontWeight: FontWeight.bold,
              //               letterSpacing: 1,
              //             ),
              //           )
              //         : const SizedBox(),
              //     Text(
              //       " ${(_serviceDuration.inMinutes % 60).toString()}min",
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: Dimensions.dimensionNo12,
              //         fontFamily: GoogleFonts.roboto().fontFamily,
              //         fontWeight: FontWeight.bold,
              //         letterSpacing: 1,
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     PriceRow(serviceModel: widget.serviceModel),
              //     const Spacer(),
              //     CustomButton(
              //       buttonColor: bookingProvider.getWatchList
              //               .contains(widget.serviceModel)
              //           ? Colors.red
              //           : AppColor.buttonColor,
              //       ontap: () {
              //         setState(() {
              //           _isAdd = !_isAdd;
              //         });
              //         bookingProvider.getWatchList.contains(widget.serviceModel)
              //             ? setState(() {
              //                 bookingProvider.removeServiceToWatchList(
              //                     widget.serviceModel);
              //                 bookingProvider.calculateTotalBookingDuration();
              //                 bookingProvider.calculateSubTotal();
              //               })
              //             : setState(() {
              //                 bookingProvider
              //                     .addServiceToWatchList(widget.serviceModel);
              //                 bookingProvider.calculateTotalBookingDuration();
              //                 bookingProvider.calculateSubTotal();
              //               });
              //       },
              //       text: bookingProvider.getWatchList
              //               .contains(widget.serviceModel)
              //           ? "Remove -"
              //           : "Add+",
              //       width: ResponsiveLayout.isMobile(context)
              //           ? Dimensions.dimensionNo100
              //           : null,
              //     ),
              //   ],
              // ),
              // SizedBox(height: Dimensions.dimensionNo10),
              // Text(
              //   widget.serviceModel.description! ?? "",
              //   overflow: TextOverflow.ellipsis,
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: isMobile
              //         ? Dimensions.dimensionNo10
              //         : Dimensions.dimensionNo12,
              //     fontFamily: GoogleFonts.roboto().fontFamily,
              //     letterSpacing: 1,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
// class SingleServiceTapAppoint extends StatefulWidget {
//   final ServiceModel serviceModel;
//   const SingleServiceTapAppoint({
//     super.key,
//     required this.serviceModel,
//   });

//   @override
//   State<SingleServiceTapAppoint> createState() => _SingleServiceTapState();
// }

// class _SingleServiceTapState extends State<SingleServiceTapAppoint> {
//   bool _isAdd = false;

//   @override
//   Widget build(BuildContext context) {
//     BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
//     Duration? _serviceDuration =
//         Duration(minutes: widget.serviceModel.serviceDurationMin);

//     // Determine if the screen is mobile
//     bool isMobile = MediaQuery.of(context).size.width < 600;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: EdgeInsets.only(
//             left: Dimensions.dimensionNo16,
//             right: Dimensions.dimensionNo16,
//             top: Dimensions.dimensionNo10,
//           ),
//           padding: EdgeInsets.symmetric(
//             vertical: Dimensions.dimensionNo8,
//             horizontal: Dimensions.dimensionNo10,
//           ),
//           decoration: BoxDecoration(
//             border: Border.all(width: 1.5),
//             borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.serviceModel.servicesName,
//                           style: TextStyle(
//                             color: AppColor.serviceTapTextColor,
//                             fontSize: isMobile
//                                 ? Dimensions.dimensionNo14
//                                 : Dimensions.dimensionNo16,
//                             fontFamily: GoogleFonts.lato().fontFamily,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                               EdgeInsets.only(left: Dimensions.dimensionNo8),
//                           child: Text(
//                             'Service Code: ${widget.serviceModel.serviceCode}',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: isMobile
//                                   ? Dimensions.dimensionNo10
//                                   : Dimensions.dimensionNo12,
//                               fontFamily: GoogleFonts.roboto().fontFamily,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   CustomChip(text: widget.serviceModel.categoryName),
//                 ],
//               ),
//               Padding(
//                 padding:
//                     EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
//                 child: const CustomDotttedLine(),
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.watch_later_outlined,
//                     size: Dimensions.dimensionNo14,
//                     color: Colors.black,
//                   ),
//                   _serviceDuration.inHours >= 1
//                       ? Text(
//                           ' ${_serviceDuration.inHours.toString()}h : ',
//                           style: TextStyle(
//                             color: AppColor.serviceTapTextColor,
//                             fontSize: Dimensions.dimensionNo12,
//                             fontFamily: GoogleFonts.roboto().fontFamily,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1,
//                           ),
//                         )
//                       : const SizedBox(),
//                   Text(
//                     " ${(_serviceDuration.inMinutes % 60).toString()}min",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: Dimensions.dimensionNo12,
//                       fontFamily: GoogleFonts.roboto().fontFamily,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   PriceRow(serviceModel: widget.serviceModel),
//                   const Spacer(),
//                   CustomButton(
//                     buttonColor: bookingProvider.getWatchList
//                             .contains(widget.serviceModel)
//                         ? Colors.red
//                         : AppColor.buttonColor,
//                     ontap: () {
//                       setState(() {
//                         _isAdd = !_isAdd;
//                       });
//                       bookingProvider.getWatchList.contains(widget.serviceModel)
//                           ? setState(() {
//                               bookingProvider.removeServiceToWatchList(
//                                   widget.serviceModel);
//                               bookingProvider.calculateTotalBookingDuration();
//                               bookingProvider.calculateSubTotal();
//                             })
//                           : setState(() {
//                               bookingProvider
//                                   .addServiceToWatchList(widget.serviceModel);
//                               bookingProvider.calculateTotalBookingDuration();
//                               bookingProvider.calculateSubTotal();
//                             });
//                     },
//                     text: bookingProvider.getWatchList
//                             .contains(widget.serviceModel)
//                         ? "Remove -"
//                         : "Add+",
//                     width: ResponsiveLayout.isMobile(context)
//                         ? Dimensions.dimensionNo100
//                         : null,
//                   ),
//                 ],
//               ),
//               SizedBox(height: Dimensions.dimensionNo10),
//               Text(
//                 widget.serviceModel.description! ?? "",
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: isMobile
//                       ? Dimensions.dimensionNo10
//                       : Dimensions.dimensionNo12,
//                   fontFamily: GoogleFonts.roboto().fontFamily,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
