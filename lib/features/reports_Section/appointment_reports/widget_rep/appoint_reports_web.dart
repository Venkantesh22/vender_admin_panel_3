// import 'package:flutter/material.dart';
// import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
// import 'package:samay_admin_plan/models/user_model/user_model.dart';
// import 'package:samay_admin_plan/provider/report_provider.dart';
// import 'package:samay_admin_plan/provider/app_provider.dart';
// import 'package:samay_admin_plan/utility/dimenison.dart';
// import 'package:samay_admin_plan/features/home/user_list/widget/user_booking.dart';

// class AppointListWebWidget extends StatelessWidget {
//   final ReportProvider reportProvider;
//   final AppProvider appProvider;
//   final BuildContext context;
//   final List<AppointModel> appointList;
//   final bool isLoading;

//   const AppointListWebWidget({
//     super.key,
//     required this.reportProvider,
//     required this.appProvider,
//     required this.context,
//     required this.appointList,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(Dimensions.dimenisonNo16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               'Appointment List',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: Dimensions.dimenisonNo16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               'Show Appointment List information for sales',
//               style: TextStyle(
//                 color: const Color(0xFF595959),
//                 fontSize: Dimensions.dimenisonNo12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: Dimensions.dimenisonNo20),
//             if (isLoading)
//               const Center(child: CircularProgressIndicator())
//             else
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: Dimensions.dimenisonNo20),
//                     alignment: Alignment.topCenter,
//                     height: Dimensions.dimenisonNo34,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(153, 215, 166, 166),
//                       border: Border.all(
//                         color: Colors.black,
//                         width: 1,
//                       ),
//                       borderRadius:
//                           BorderRadius.circular(Dimensions.dimenisonNo5),
//                     ),
//                     child: Center(
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: Dimensions.dimenisonNo30,
//                             child: Center(
//                               child: Text(
//                                 "No",
//                                 style: TextStyle(
//                                   fontSize: Dimensions.dimenisonNo14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: Dimensions.dimenisonNo50,
//                             child: Center(
//                               child: Text(
//                                 "Image",
//                                 style: TextStyle(
//                                   fontSize: Dimensions.dimenisonNo14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: Dimensions.dimenisonNo10),
//                           SizedBox(
//                             width: Dimensions.dimenisonNo200,
//                             child: Text(
//                               "Name",
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontSize: Dimensions.dimenisonNo14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           SizedBox(
//                             child: Text(
//                               "Date and Time",
//                               style: TextStyle(
//                                 fontSize: Dimensions.dimenisonNo14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           SizedBox(
//                             width: Dimensions.dimenisonNo80,
//                             child: Center(
//                               child: Text(
//                                 "Status",
//                                 style: TextStyle(
//                                   fontSize: Dimensions.dimenisonNo14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: Dimensions.dimenisonNo30),
//                         ],
//                       ),
//                     ),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: appointList.length,
//                     itemBuilder: (context, index) {
//                       AppointModel order = appointList[index];
//                       UserModel user = order.userModel;
//                       int no = index + 1;
//                       return UserBookingTap(
//                         appointModel: order,
//                         userModel: user,
//                         index: no,
//                         isUseForReportSce: true,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
