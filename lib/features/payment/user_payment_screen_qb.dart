// // ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:samay_admin_plan/constants/responsive_layout.dart';
// import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/price_text.dart';
// import 'package:samay_admin_plan/constants/constants.dart';
// import 'package:samay_admin_plan/constants/global_variable.dart';
// import 'package:samay_admin_plan/features/payment/bill_pdf.dart';
// import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
// import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
// import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
// import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
// import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
// import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
// import 'package:samay_admin_plan/models/samay_salon_settng_model/samay_salon_setting.dart';
// import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
// import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';
// import 'package:samay_admin_plan/provider/app_provider.dart';
// import 'package:samay_admin_plan/provider/booking_provider.dart';
// import 'package:samay_admin_plan/provider/service_provider.dart';
// import 'package:samay_admin_plan/utility/color.dart';
// import 'package:samay_admin_plan/utility/dimension.dart';
// import 'package:samay_admin_plan/widget/customauthbutton.dart';
// import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

// class UserSideBarPaymentScreenForQB extends StatefulWidget {
//   final String? appointID;
//   final String? userId;

//   const UserSideBarPaymentScreenForQB({
//     super.key,
//     this.appointID,
//     this.userId,
//   });

//   @override
//   State<UserSideBarPaymentScreenForQB> createState() =>
//       _UserSideBarPaymentScreenForQBState();
// }

// class _UserSideBarPaymentScreenForQBState
//     extends State<UserSideBarPaymentScreenForQB> {
//   bool isExtroDiscountApply = false;
//   bool _isLoading = false;

//   UPIDetails? upiDetails;
//   late VenderPaymentDetailsModel? _venderPaymentDetailsModel;
//   late AppointModel _appointModel;
//   SettingModel? _settingModel;
//   SamaySalonSettingModel? _samaySalonSettingModel;

//   double finalAmount = 0.0;
//   double gstAmount = 0.0;
//   double _extraDiscountInPerAMTLoc = 0.0;
//   // double _extraDiscountAMTLoc = 0.0;

//   final List<String> _paymentOptions = ["Cash", "QR", "Custom"];
//   String _selectedPaymentMethod = "Cash";
//   final TextEditingController _cashReceivedController =
//       TextEditingController(text: "0.0");
//   final TextEditingController _extraDiscountInPer =
//       TextEditingController(text: "0.0");
//   final TextEditingController _extraDiscountInDirectAmount =
//       TextEditingController(text: "0.0");
//   final TextEditingController _transactionIdController =
//       TextEditingController(text: "0");

//   double get _cashToGiveBack {
//     BookingProvider bookingProvider =
//         Provider.of<BookingProvider>(context, listen: false);
//     final cashReceived = double.tryParse(_cashReceivedController.text) ?? 0.0;
//     return cashReceived - bookingProvider.getFinalPayableAMT!;
//   }

//   void calBill() {
//     BookingProvider bookingProvider =
//         Provider.of<BookingProvider>(context, listen: false);
//     bookingProvider.getWatchList.clear();
//     bookingProvider.setAllZero();

//     bookingProvider.addServiceListToWatchList(_appointModel.services);
//     _extraDiscontAmountFun1();
//     bookingProvider.setExtraDiscountInPerAmount(_extraDiscountInPerAMTLoc);
//     bookingProvider.setExtraDiscountAmount(
//         double.tryParse(_extraDiscountInDirectAmount.text) ?? 0.0);
//     bookingProvider.calculateSubTotal();
//   }

// // Cal Extra Discount Fun
//   void _extraDiscontAmountFun1() {
//     final discountPercentage = double.tryParse(_extraDiscountInPer.text) ?? 0.0;
//     final validPercentage = discountPercentage.clamp(0.0, 100.0);
//     final double _formDiscAMT =
//         _appointModel.subTotal - _appointModel.discountAmount!;
//     _extraDiscountInPerAMTLoc = (validPercentage / 100) * _formDiscAMT;
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   void dispose() {
//     _cashReceivedController.dispose();
//     _extraDiscountInPer.dispose();
//     _extraDiscountInDirectAmount.dispose();
//     _transactionIdController.dispose();
//     super.dispose();
//   }

//   void getData() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });
//       AppProvider appProvider =
//           Provider.of<AppProvider>(context, listen: false);
//       _venderPaymentDetailsModel = await SettingFb.instance
//           .fetchVenderPaymentFB(appProvider.getSalonInformation.id);

//       ServiceProvider serviceProvider =
//           Provider.of<ServiceProvider>(context, listen: false);

//       await serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);
//       _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();

//       _settingModel = serviceProvider.getSettingModel!;

//       _appointModel = await UserBookingFB.instance
//           .getSingleAppointByIdFB(widget.userId!, widget.appointID!);

//       print("Appointment fetched: ${_appointModel.orderId}");

//       _cashReceivedController.text = "0.0";
//       _extraDiscountInPer.text = "0.0";
//       _transactionIdController.text = "0";
//       finalAmount = _appointModel.serviceTotalPrice;
//       gstAmount = _appointModel.gstAmount;

//       if (_appointModel.extraDiscountInAmount != 0.0 ||
//           _appointModel.extraDiscountInPerAMT != 0.0 ||
//           _appointModel.extraDiscountInAmount != null ||
//           _appointModel.extraDiscountInPerAMT != null) {
//         isExtroDiscountApply = true;
//         _extraDiscountInPerAMTLoc = _appointModel.extraDiscountInPerAMT ?? 0.0;
//       } else {
//         isExtroDiscountApply = false;
//       }

//       if (isExtroDiscountApply) {
//         _extraDiscountInPer.text =
//             _appointModel.extraDiscountInPer!.toStringAsFixed(2);
//         _extraDiscountInDirectAmount.text =
//             _appointModel.extraDiscountInAmount!.toStringAsFixed(2);
//       }

//       calBill();
//     } catch (e) {
//       print("Error in funtion GetDate $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
//     // Show loading if still fetching or _appointModel is not loaded
//     if (_isLoading || (_appointModel == null && _appointModel == null)) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return Scaffold(
//       appBar: BillPaymentAppBar(),
//       backgroundColor: AppColor.whileColor,
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Center(
//                 child: Container(
//                   color: AppColor.whileColor,
//                   constraints: BoxConstraints(
//                     maxWidth: ResponsiveLayout.isMobile(context)
//                         ? Dimensions.screenHeightM
//                         : Dimensions.screenWidth / 1.5,
//                     // maxHeight: ResponsiveLayout.isMobile(context)
//                     //     ? Dimensions.screenHeight
//                     //     : Dimensions.screenHeight * 0.9,
//                   ),
//                   padding: ResponsiveLayout.isMobile(context)
//                       ? EdgeInsets.symmetric(
//                           horizontal: Dimensions.dimensionNo10,
//                           vertical: Dimensions.dimensionNo10,
//                         )
//                       : EdgeInsets.symmetric(
//                           horizontal: Dimensions.dimensionNo16,
//                           vertical: Dimensions.dimensionNo10,
//                         ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         _buildPaymentDetailsSection(bookingProvider),
//                         SizedBox(height: Dimensions.dimensionNo20),
//                         _buildPaymentOptionsSection(bookingProvider),
//                         billButtom(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   AppBar BillPaymentAppBar() {
//     return AppBar(
//       backgroundColor: AppColor.mainColor,
//       actions: [
//         Container(
//           margin: EdgeInsets.only(left: Dimensions.dimensionNo20),
//           child: IconButton(
//             onPressed: () {
//               setState(() {
//                 isExtroDiscountApply = !isExtroDiscountApply;
//               });
//             },
//             icon: Icon(
//               Icons.percent,
//               color: Colors.white,
//               size: Dimensions.dimensionNo18,
//             ),
//           ),
//         )
//       ],
//       title: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               "Bill Page",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: Dimensions.dimensionNo18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(width: Dimensions.dimensionNo8),
//             Text(
//               "Power by Samay",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: Dimensions.dimensionNo12,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentDetailsSection(BookingProvider bookingProvider) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CustomText(
//           firstText: "Payment Method:",
//           lastText: _appointModel.payment,
//         ),
//         SizedBox(height: Dimensions.dimensionNo10),
//         const Divider(),
//         Padding(
//           padding: ResponsiveLayout.isMobile(context)
//               ? EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo5)
//               : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               pricreInfor(),
//               SizedBox(height: Dimensions.dimensionNo10),
//               SizedBox(height: Dimensions.dimensionNo8),
//               const Divider(),
//               _buildFinalAmountRow(bookingProvider),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Padding pricreInfor() {
//     BookingProvider bookingProvider =
//         Provider.of<BookingProvider>(context, listen: false);
//     return Padding(
//       padding: ResponsiveLayout.isMobile(context)
//           ? EdgeInsets.zero
//           : EdgeInsets.all(Dimensions.dimensionNo16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Price Details',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? Dimensions.dimensionNo14
//                   : Dimensions.dimensionNo18,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 1.0,
//             ),
//           ),
//           SizedBox(
//             height: Dimensions.dimensionNo12,
//           ),
//           // Price Details Section
//           Padding(
//             padding: ResponsiveLayout.isMobile(context)
//                 ? EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo5)
//                 : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo10),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: Dimensions.dimensionNo10),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Price',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: ResponsiveLayout.isMobile(context)
//                               ? Dimensions.dimensionNo12
//                               : Dimensions.dimensionNo14,
//                           fontWeight: FontWeight.w400,
//                           letterSpacing: 0.90,
//                         ),
//                       ),
//                       SizedBox(width: Dimensions.dimensionNo5),
//                       Text(
//                         '(services ${_appointModel.services.length})',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: ResponsiveLayout.isMobile(context)
//                               ? Dimensions.dimensionNo12
//                               : Dimensions.dimensionNo14,
//                           letterSpacing: 0.90,
//                         ),
//                       ),
//                       const Spacer(),
//                       Icon(
//                         Icons.currency_rupee,
//                         size: Dimensions.dimensionNo18,
//                       ),
//                       Text(
//                         bookingProvider.getSubTotal.toString(),
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: ResponsiveLayout.isMobile(context)
//                               ? Dimensions.dimensionNo12
//                               : Dimensions.dimensionNo14,
//                           fontWeight: FontWeight.w400,
//                           letterSpacing: 0.90,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

// // Item Discount
//                 _appointModel.discountInPer != 0.0
//                     ? Padding(
//                         padding:
//                             EdgeInsets.only(bottom: Dimensions.dimensionNo10),
//                         child: Row(
//                           children: [
//                             Text(
//                               'Item Discount ${bookingProvider.getDiscountInPer!.round()}%',
//                               style: TextStyle(
//                                 fontSize: ResponsiveLayout.isMobile(context)
//                                     ? Dimensions.dimensionNo12
//                                     : Dimensions.dimensionNo14,
//                                 fontWeight: FontWeight.w500,
//                                 letterSpacing: 0.90,
//                               ),
//                             ),
//                             const Spacer(),
//                             Text(
//                               "-₹${bookingProvider.getDiscountAmount.toString()}",
//                               style: TextStyle(
//                                 fontSize: ResponsiveLayout.isMobile(context)
//                                     ? Dimensions.dimensionNo12
//                                     : Dimensions.dimensionNo14,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.green,
//                                 letterSpacing: 0.90,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : const SizedBox(),

// // Extra Discount
//                 isExtroDiscountApply
//                     ? _buildDiscountInputRow(bookingProvider)
//                     : const SizedBox(),

//                 Row(
//                   children: [
//                     Text(
//                       _appointModel.gstIsIncludingOrExcluding ==
//                               GlobalVariable.inclusiveGST
//                           ? 'Net Price (incl. GST)'
//                           : 'Net Price',
//                       style: TextStyle(
//                         fontSize: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo12
//                             : Dimensions.dimensionNo14,
//                         fontWeight: FontWeight.w500,
//                         letterSpacing: 0.90,
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       "₹${bookingProvider.getNetPrice!.toStringAsFixed(2)}",
//                       style: TextStyle(
//                         fontSize: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo12
//                             : Dimensions.dimensionNo14,
//                         fontWeight: FontWeight.w500,
//                         letterSpacing: 0.90,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: Dimensions.dimensionNo10),

//                 Row(
//                   children: [
//                     Text(
//                       'Platform Fees',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo12
//                             : Dimensions.dimensionNo14,
//                         letterSpacing: 0.90,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       Icons.currency_rupee,
//                       size: Dimensions.dimensionNo14,
//                     ),
//                     Text(
//                       _samaySalonSettingModel!.platformFee,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo12
//                             : Dimensions.dimensionNo14,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.90,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: Dimensions.dimensionNo10),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _settingModel!.gSTIsIncludingOrExcluding == null ||
//                                 _settingModel!
//                                     .gSTIsIncludingOrExcluding!.isEmpty
//                             ? "Total Amount"
//                             : 'Taxable Amount',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: ResponsiveLayout.isMobile(context)
//                               ? Dimensions.dimensionNo12
//                               : Dimensions.dimensionNo14,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.90,
//                         ),
//                       ),
//                     ),
//                     Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
//                     Text(
//                       bookingProvider.getTaxAbleAmount!
//                           .round()
//                           .toStringAsFixed(2),
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo12
//                             : Dimensions.dimensionNo14,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.90,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: Dimensions.dimensionNo10),
//                 // GST Price
//                 _appointModel.gstAmount != 0.0
//                     ? Column(
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 'GST 18% (SGST & CGST)',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: ResponsiveLayout.isMobile(context)
//                                       ? Dimensions.dimensionNo12
//                                       : Dimensions.dimensionNo14,
//                                   // fontWeight: FontWeight.w500,
//                                   letterSpacing: 0.90,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Text(
//                                 _settingModel!.gSTIsIncludingOrExcluding ==
//                                         GlobalVariable.exclusiveGST
//                                     ? bookingProvider.getExcludingGSTAMT!
//                                         .toStringAsFixed(2)
//                                     : bookingProvider.getIncludingGSTAMT!
//                                         .toStringAsFixed(2),
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: ResponsiveLayout.isMobile(context)
//                                       ? Dimensions.dimensionNo12
//                                       : Dimensions.dimensionNo14,
//                                   fontWeight: FontWeight.w600,
//                                   letterSpacing: 0.90,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: Dimensions.dimensionNo10),
//                         ],
//                       )
//                     : const SizedBox(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// // Extra Discount Input Row

//   Widget _buildDiscountInputRow(BookingProvider bookingProvider) {
//     return Column(
//       children: [
//         // Row for entering the extra discount percentage
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Extra Discount :",
//               style: TextStyle(
//                 fontSize: ResponsiveLayout.isMobile(context)
//                     ? Dimensions.dimensionNo12
//                     : Dimensions.dimensionNo14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: Dimensions.dimensionNo10,
//             ),
//             Expanded(
//               child: TextField(
//                 controller: _extraDiscountInDirectAmount,
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                 textAlign: TextAlign.end,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   labelText: "Rupess ₹",
//                   errorText:
//                       validateDiscountInput(_extraDiscountInDirectAmount.text),
//                   errorStyle: TextStyle(fontSize: Dimensions.dimensionNo12),
//                 ),
//                 onChanged: (value) {
//                   double _discount = double.tryParse(value) ?? 0.0;
//                   bookingProvider.setExtraDiscountAmount(_discount);
//                   bookingProvider.calculateSubTotal();
//                   setState(() {});
//                 },
//               ),
//             ),
//             SizedBox(width: Dimensions.dimensionNo8),
//             Expanded(
//               child: TextField(
//                 controller: _extraDiscountInPer,
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                 textAlign: TextAlign.end,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   labelText: "Discount",
//                   errorText: validateDiscountInput(_extraDiscountInPer.text),
//                   errorStyle: TextStyle(fontSize: Dimensions.dimensionNo12),
//                 ),
//                 onChanged: (value) {
//                   _extraDiscontAmountFun1();
//                   double _discountPercentage = _extraDiscountInPerAMTLoc;
//                   bookingProvider
//                       .setExtraDiscountInPerAmount(_discountPercentage);
//                   bookingProvider.calculateSubTotal();

//                   setState(() {});
//                 },
//               ),
//             ),
//             Icon(Icons.percent, size: Dimensions.dimensionNo16),
//           ],
//         ),
//         SizedBox(height: Dimensions.dimensionNo8),
//         // Row for displaying calculated extra discount amount
//         Row(
//           children: [
//             Text(
//               "Extra Discount Percentage Amount:",
//               style: TextStyle(
//                 fontSize: ResponsiveLayout.isMobile(context)
//                     ? Dimensions.dimensionNo12
//                     : Dimensions.dimensionNo14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: Dimensions.dimensionNo110,
//               child: Text(
//                 "-₹${_extraDiscountInPerAMTLoc.toStringAsFixed(2)}",
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontSize: ResponsiveLayout.isMobile(context)
//                       ? Dimensions.dimensionNo12
//                       : Dimensions.dimensionNo14,
//                   fontWeight: FontWeight.w400,
//                   letterSpacing: 0.80,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: Dimensions.dimensionNo10),
//         _extraDiscountInDirectAmount.text.isEmpty
//             ? const SizedBox()
//             : Row(
//                 children: [
//                   Text(
//                     "Extra Discount Amount:",
//                     style: TextStyle(
//                       fontSize: ResponsiveLayout.isMobile(context)
//                           ? Dimensions.dimensionNo12
//                           : Dimensions.dimensionNo14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const Spacer(),
//                   SizedBox(
//                     width: Dimensions.dimensionNo110,
//                     child: Text(
//                       "-₹${_extraDiscountInDirectAmount.text}",
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontSize: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo12
//                             : Dimensions.dimensionNo14,
//                         fontWeight: FontWeight.w400,
//                         letterSpacing: 0.80,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//         SizedBox(height: Dimensions.dimensionNo10),
//       ],
//     );
//   }

//   Widget _buildFinalAmountRow(BookingProvider bookingProvider) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: Dimensions.dimensionNo16),
//       child: Row(
//         children: [
//           Text(
//             "Final Total Amount :",
//             style: TextStyle(
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? 13
//                   : Dimensions.dimensionNo15,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             bookingProvider.getFinalPayableAMT!.round().toString(),
//             style: TextStyle(
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? Dimensions.dimensionNo14
//                   : Dimensions.dimensionNo16,
//               fontWeight: FontWeight.bold,
//               color: bookingProvider.getFinalPayableAMT! < finalAmount
//                   ? Colors.green
//                   : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentOptionsSection(BookingProvider bookingProvider) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Payment Options',
//           style: TextStyle(
//             fontSize: ResponsiveLayout.isMobile(context)
//                 ? Dimensions.dimensionNo16
//                 : Dimensions.dimensionNo20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(height: Dimensions.dimensionNo12),
//         Container(
//           padding: EdgeInsets.all(Dimensions.dimensionNo8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
//             border: Border.all(width: 1.6, color: Colors.black),
//           ),
//           child: _buildPaymentMethodSelector(bookingProvider),
//         ),
//         SizedBox(height: Dimensions.dimensionNo12),
//         Text(
//           "Note: Online payments coming soon. Currently only cash payments available.",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: Dimensions.dimensionNo12,
//           ),
//           softWrap: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildPaymentMethodSelector(BookingProvider bookingProvider) {
//     return Container(
//       constraints: BoxConstraints(maxHeight: Dimensions.screenHeight * 0.4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: DropdownButtonFormField<String>(
//                 value: _selectedPaymentMethod,
//                 items: _paymentOptions
//                     .map((method) => DropdownMenuItem(
//                           value: method,
//                           child: Text(method),
//                         ))
//                     .toList(),
//                 onChanged: (newValue) => setState(() {
//                   _selectedPaymentMethod = newValue!;
//                   if (_selectedPaymentMethod == "QR") {
//                     if (_venderPaymentDetailsModel != null &&
//                         _venderPaymentDetailsModel!.upiID.isNotEmpty) {
//                       upiDetails = UPIDetails(
//                         upiID: _venderPaymentDetailsModel!.upiID,
//                         payeeName: _appointModel.userModel.name,
//                         amount: bookingProvider.getFinalPayableAMT!,
//                         transactionNote:
//                             "Thank you for booking services on Samay.",
//                       );
//                     } else {
//                       // Fallback default UPI value if not available
//                       upiDetails = UPIDetails(
//                         upiID: " ",
//                         payeeName: '',
//                         amount: 0,
//                         transactionNote: "",
//                       );
//                     }
//                   } else if (_selectedPaymentMethod == "Custom") {
//                     // For custom, we may show a custom payment section
//                     upiDetails = null;
//                   } else {
//                     upiDetails = null;
//                   }
//                 }),
//                 decoration: const InputDecoration(
//                   labelText: "Payment Method",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               color: Colors.grey.shade100,
//               child: _selectedPaymentMethod == "Cash"
//                   ? _buildCashPaymentSection(bookingProvider)
//                   : _selectedPaymentMethod == "QR"
//                       ? _buildQRPaymentSection()
//                       : _buildCustomPaymentSection(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCashPaymentSection(BookingProvider bookingProvider) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: _cashReceivedController,
//           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           decoration: InputDecoration(
//             border: const OutlineInputBorder(),
//             labelText: "Cash Received",
//             errorText: _validateCashInput(),
//           ),
//           onChanged: (value) => setState(() {}),
//         ),
//         SizedBox(height: Dimensions.dimensionNo16),
//         Text(
//           "Change Due: ₹${_cashToGiveBack.round()}",
//           style: TextStyle(
//             fontSize: Dimensions.dimensionNo16,
//             color: _cashToGiveBack >= 0 ? Colors.green : Colors.red,
//           ),
//         ),
//         if (bookingProvider.getFinalPayableAMT! < 0)
//           Text(
//             "Insufficient cash received",
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: Dimensions.dimensionNo12,
//             ),
//           ),
//       ],
//     );
//   }

//   String? _validateCashInput() {
//     final value = double.tryParse(_cashReceivedController.text);
//     if (value == null && _cashReceivedController.text.isNotEmpty) {
//       return 'Invalid amount';
//     }
//     return null;
//   }

//   Widget _buildQRPaymentSection() {
//     return SingleChildScrollView(
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: ResponsiveLayout.isMobile(context)
//               ? Dimensions.screenHeight * 0.8
//               : Dimensions.screenHeight * 0.5,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               height: Dimensions.dimensionNo150,
//               width: Dimensions.dimensionNo150,
//               child: UPIPaymentQRCode(upiDetails: upiDetails!),
//             ),
//             SizedBox(height: Dimensions.dimensionNo8),
//             Padding(
//               padding:
//                   EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo20),
//               child: SizedBox(
//                 height: Dimensions.dimensionNo30,
//                 child: TextField(
//                   controller: _transactionIdController,
//                   style: TextStyle(fontSize: Dimensions.dimensionNo12),
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Transaction ID",
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Custom Payment Section for "Custom" payment option
//   Widget _buildCustomPaymentSection() {
//     return Center(
//       child: Text(
//         "Custom Payment method selected.",
//         style: TextStyle(fontSize: Dimensions.dimensionNo14),
//       ),
//     );
//   }

//   TextStyle appointSummaryTextStyle(BuildContext context,
//       {Color? color, bool bold = false}) {
//     double fontSize;
//     if (ResponsiveLayout.isMobile(context)) {
//       fontSize = Dimensions.dimensionNo13;
//     } else if (ResponsiveLayout.isTablet(context)) {
//       fontSize = Dimensions.dimensionNo15;
//     } else {
//       fontSize = Dimensions.dimensionNo17;
//     }
//     return TextStyle(
//       fontSize: fontSize,
//       fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
//       color: color ?? Colors.black87,
//       letterSpacing: 0.5,
//       fontFamily: GoogleFonts.roboto().fontFamily,
//     );
//   }

//   CustomAuthButton billButtom() => CustomAuthButton(
//         text: "Generate Bill",
//         ontap: () async {
//           showLoaderDialog(context);

//           BookingProvider _bookingProvider =
//               Provider.of<BookingProvider>(context, listen: false);
//           AppProvider appProvider =
//               Provider.of<AppProvider>(context, listen: false);

//           SalonModel _salonModle = appProvider.getSalonInformation;
// // update TimeStamp List
//           List<TimeStampModel> _timeStampList = [];
//           _timeStampList.addAll(_appointModel.timeStampList);

//           TimeStampModel _timeStampModel = TimeStampModel(
//               id: _appointModel.orderId,
//               dateAndTime: GlobalVariable.today,
//               updateBy:
//                   "${appProvider.getSalonInformation.name} Bill Generate");
//           _timeStampList.add(_timeStampModel);

//           double _extraDiscountInAmountLocal =
//               _extraDiscountInDirectAmount.text.trim().isEmpty
//                   ? 0.0
//                   : double.parse(_extraDiscountInDirectAmount.text.trim());

//           double _extraDiscountInPerLocal =
//               _extraDiscountInPer.text.trim().isEmpty
//                   ? 0.0
//                   : double.parse(_extraDiscountInPer.text.trim());

//           print("Extra Discount in %: $_extraDiscountInPerLocal");

// // Update Appointment Payment information
//           AppointModel _updataAppointModel = _appointModel.copyWith(
//             extraDiscountInPer: _extraDiscountInPerLocal ?? 0.0,
//             extraDiscountInPerAMT: _extraDiscountInPerAMTLoc,
//             extraDiscountInAmount: _extraDiscountInAmountLocal ?? 0.0,
//             transactionId: _transactionIdController.text.trim().isNotEmpty
//                 ? _transactionIdController.text.trim()
//                 : "00",
//             // gstAmount: calGSTInclustiveFun(),
//             gstAmount: _settingModel!.gstNo.length == 15
//                 ? _settingModel!.gSTIsIncludingOrExcluding ==
//                         GlobalVariable.exclusiveGST
//                     ? _bookingProvider.getExcludingGSTAMT!
//                     : _bookingProvider.getIncludingGSTAMT!
//                 : 0.0,

//             serviceTotalPrice: _bookingProvider.getFinalPayableAMT!,
//             netPrice: _bookingProvider.getNetPrice!,
//             status: "Bill Generate",
//             payment:
//                 _selectedPaymentMethod == "QR" ? "UPI" : _selectedPaymentMethod,
//             timeStampList: _timeStampList,
//           );
//           print(
//               "Extra Discount in update %: ${_updataAppointModel.extraDiscountInPer}");

//           bool _isUpdate = await _bookingProvider.updateAppointment(
//             _appointModel.userModel.id,
//             _appointModel.orderId,
//             _updataAppointModel,
//           );

//           Navigator.pop(context);
//           print(
//               "salon Id ${_appointModel.vendorId}   ,${appProvider.getSalonInformation.id}");

//           if (_isUpdate) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BillPdfPage(
//                   appointModel: _updataAppointModel,
//                   salonModel: _salonModle,
//                   settingModel: _settingModel!,
//                   vendorLogo: _salonModle.logImage,
//                 ),
//               ),
//             );
//             showMessage("Successfully billing an appointment");
//           }
//         },
//       );
// }
