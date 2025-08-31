// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Direct%20Billing/screen/edit_direct_billing.dart';
import 'package:samay_admin_plan/features/add_new_appointment/screen/edit_appointment.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_product_delete_icon_widget.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/infor.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/infor_text_timedate.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/row_of_state.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/service_tap_orderlist.dart';
import 'package:samay_admin_plan/features/home/widget/state_text.dart';
import 'package:samay_admin_plan/features/payment/bill_pdf.dart';
import 'package:samay_admin_plan/features/payment/user_payment_screen.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/widget/custom_button.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/custom_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoSideBar extends StatefulWidget {
  final UserModel user;
  final AppointModel appointModel;
  final int index;

  const UserInfoSideBar({
    super.key,
    required this.appointModel,
    required this.index,
    required this.user,
  });

  @override
  State<UserInfoSideBar> createState() => _UserInfoSideBarState();
}

class _UserInfoSideBarState extends State<UserInfoSideBar> {
  bool isLoading = false;
  bool showServiceList = false;
  bool showProductList = false;

  late SalonModel salonModel;
  late SettingModel _settingModel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void didUpdateWidget(covariant UserInfoSideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the appointModel changes, refetch data
    if (oldWidget.appointModel.orderId != widget.appointModel.orderId) {
      getData();
    }
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    bookingProvider.getWatchList.clear();

    salonModel = appProvider.getSalonInformation;

    // Null checks for serviceBillModel and productBillModel
    if (widget.appointModel.serviceBillModel != null) {
      // if (widget.appointModel.serviceBillModel != null &&  appProvider.selectAppointModel != null &&  appProvider.selectAppointModel!.orderId != widget.appointModel.orderId  )  {
      await appProvider.fetchServiceListByListId(
          serviceIds: widget.appointModel.serviceBillModel!.serviceListId);
    }

    if (widget.appointModel.productBillModel != null) {
      // if (widget.appointModel.productBillModel != null  && appProvider.selectAppointModel != null &&     appProvider.selectAppointModel!.orderId != widget.appointModel.orderId) {
      await appProvider.fetchProductListByListId(
        productIds: widget
            .appointModel.productBillModel!.productListIdQty.entries
            .map((e) => e.key)
            .toList(),
        productIdQtyMap: widget.appointModel.productBillModel!.productListIdQty,
      );
      print("fetch product for ${widget.appointModel!.userModel.name}");
    }

    if (serviceProvider.getSettingModel == null) {
      await serviceProvider.fetchSettingPro(salonModel.id);
    }
    _settingModel = serviceProvider.getSettingModel!;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration? appointDuration =
        Duration(minutes: widget.appointModel.appointmentInfo!.serviceDuration);
    UserModel userModel = widget.user;

    // Method to open WhatsApp with the phone number
    Future<void> openWhatsApp(String phoneNumber) async {
      try {
        final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
        await launchUrl(whatsappUrl);
      } catch (e) {
        showMessage('Could not launch WhatsApp $e');
      }
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 2.0,
                color: Colors.black,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.dimensionNo16,
                  right: Dimensions.dimensionNo16,
                  top: Dimensions.dimensionNo18,
                ),

//! heading bar of Appointment

                child: appointHeadingPart(context, userModel),
              ),
              Divider(thickness: Dimensions.dimensionNo5),
//! Appointment State
              RowOfStates(
                index: widget.index,
                appointModel: widget.appointModel,
                salonModel: salonModel,
                userModel: userModel,
              ),

              const Divider(),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.dimensionNo16,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green[100],
                      backgroundImage: NetworkImage(
                        userModel.image,
                      ),
                      radius: Dimensions.dimensionNo20,
                    ),
                    SizedBox(width: Dimensions.dimensionNo10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel.name,
                                style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.dimensionNo16,
                                ),
                              ),
                              Text(
                                "M.no ${userModel.phone}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dimensions.dimensionNo14,
                                ),
                              ),
                            ],
                          ),
                          CustomIconButton(
                            icon: FontAwesomeIcons.whatsapp,
                            ontap: () {
                              openWhatsApp(
                                  "${GlobalVariable.indiaCode}${widget.appointModel.userModel.phone.toString()}");
                            },
                            iconSize: Dimensions.dimensionNo30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.dimensionNo16),
                child: Center(
                  child: Text(
                    'Appointment Information',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimensionNo18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.dimensionNo16),

              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Appointment Time",
                      style: TextStyle(
                        // color: Colors.black.withOpacity(0.699999988079071),
                        fontSize: Dimensions.dimensionNo15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: Dimensions.dimensionNo5,
                            left: Dimensions.dimensionNo5,
                            bottom: Dimensions.dimensionNo10),
                        child: Text(
                          "${DateFormat('hh:mm a').format(widget.appointModel.appointmentInfo!.serviceStartTime)} To ${DateFormat('hh:mm a').format(widget.appointModel.appointmentInfo!.serviceEndTime)} (${appointDuration.inHours}h : ${appointDuration.inMinutes % 60}m)",
                          style: TextStyle(
                            color: const Color(0xFF1F1616),
                            fontSize: Dimensions.dimensionNo14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.90,
                          ),
                        )),
                  ],
                ),
              ),
              UserInfoDateTimeColumn(
                title: "Appointment Date",
                time: widget.appointModel.appointmentInfo!.serviceDate,
                isTime: false,
              ),
              userInfoColumn(
                title: "Appointment No.",
                infoText:
                    ' 000${widget.appointModel.appointmentInfo!.appointmentNo.toString()}',
              ),
              userInfoColumn(
                title: "Service At.",
                infoText: widget.appointModel.appointmentInfo!.serviceAt,
              ),
              widget.appointModel.appointmentInfo!.serviceAt ==
                      GlobalVariable.serviceAtHome
                  ? userInfoColumn(
                      title: "Address",
                      infoText:
                          widget.appointModel.appointmentInfo!.serviceAddress!,
                    )
                  : const SizedBox(),
              const Divider(thickness: 3),
              //Service List
              servicerList(),
              SizedBox(height: Dimensions.dimensionNo10),
              const Divider(thickness: 3),
              //Service List
              productList(),

              widget.appointModel.appointmentInfo!.userNote.length != 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.dimensionNo10),
                        const Divider(),
                        userInfoColumn(
                            title: "Client Note",
                            infoText:
                                widget.appointModel.appointmentInfo!.userNote),
                      ],
                    )
                  : const SizedBox(),

              //payment section
              SizedBox(height: Dimensions.dimensionNo10),

              const Divider(thickness: 3),

              // Price Details Section

              pricreInfor(),
              SizedBox(height: Dimensions.dimensionNo10),

              const Divider(thickness: 3),
              appointBookingInfor(userModel),
              SizedBox(height: Dimensions.dimensionNo20),
              Opacity(
                // opacity: widget.appointModel.appointmentInfo!.status != "Completed" ? 0.5 : 1.0,
                opacity: widget.appointModel.appointmentInfo!.status == "Pen"
                    ? 0.5
                    : 1.0,
                child: IgnorePointer(
                  // ignoring: widget.appointModel.appointmentInfo!.status != "Completed",
                  ignoring:
                      widget.appointModel.appointmentInfo!.status == "Pen",
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.dimensionNo16),
                    width: double.infinity,
                    child: CustomButton(
                        text: "CheckOut",
                        ontap: () {
                          Routes.instance.push(
                              widget: UserSideBarPaymentScreen(
                                appointModel: widget.appointModel,
                              ),
                              context: context);
                        },
                        buttonColor: AppColor.buttonColor),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.dimensionNo20,
              ),
            ],
          ),
        ),
      );
    }
  }

  Row appointHeadingPart(BuildContext context, UserModel userModel) {
    final status = widget.appointModel.appointmentInfo!.status ?? "";
    final isCancelled = status == "(Cancel)";
    final isUpdated = widget.appointModel.isUpdate == true;
    final isBillGenerated = status == "Bill Generate";

    return Row(
      children: [
        Text(
          'Appointment',
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.dimensionNo18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        if (!isCancelled && isUpdated) const StateText(status: "(Update)"),
        Expanded(
          child: Align(
            alignment:
                isCancelled ? Alignment.centerRight : Alignment.centerLeft,
            child: isCancelled
                ? StateText(status: status)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      editAppointButton(context, userModel),
                      SizedBox(width: Dimensions.dimensionNo5),
                      cancelAppointButton(context, userModel),
                      if (isBillGenerated)
                        IconButton(
                          onPressed: () async {
                            AppProvider appProvider = Provider.of<AppProvider>(
                                context,
                                listen: false);
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BillPdfPage(
                                    appointModel: widget.appointModel,
                                    salonModel: salonModel,
                                    settingModel: _settingModel,
                                    productList:
                                        appProvider.getProductListWithQty,
                                    serviceList:
                                        appProvider.getServiceListFetchID,
                                        vendorLogo: appProvider.getSalonInformation.logImage,
                                  ),
                                ),
                              );
                            } catch (e) {
                              showMessage("Error opening bill PDF: $e");
                            }
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.green,
                          ),
                        ),
                      SizedBox(width: Dimensions.dimensionNo12),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget editAppointButton(
    BuildContext context,
    UserModel userModel,
  ) {
    return IconButton(
      onPressed: () {
        BookingProvider bookingProvider =
            Provider.of<BookingProvider>(context, listen: false);
        bookingProvider.getWatchList.clear();
        // bookingProvider.getWatchList.addAll(widget.appointModel.services);

        // widget.appointModel.appointmentInfo!.status == GlobalVariable.billGenerateAppointState
        //     ? Routes.instance.push(
        //         widget: EditDirectBillingScreen(
        //           salonModel: salonModel,
        //           appointModel: widget.appointModel,
        //           userModel: userModel,
        //         ),
        //         context: context)
        //     :

        Routes.instance.push(
            widget: EditAppointment(
              index: widget.index,
              appointModel: widget.appointModel,
              userModel: userModel,
              salonModel: salonModel,
            ),
            context: context);
      },
      icon: const Icon(
        Icons.edit_square,
        color: Colors.black,
      ),
    );
  }

  Widget cancelAppointButton(BuildContext context, UserModel userModel) {
    return IconButton(
      onPressed: () {
        showDeleteAlertDialog(
            context, "Cancel Appointment", "Do you want Cancel Appointment",
            () {
          try {
            showLoaderDialog(context);
            //create emptye list of timeDateList and add currently time for update
            List<TimeStampModel> timeStampList = [];
            timeStampList.addAll(widget.appointModel.timeStampList);
            TimeStampModel timeStampModel = TimeStampModel(
                id: widget.appointModel.orderId,
                dateAndTime: GlobalVariable.today,
                updateBy: "${userModel.name} (Appointment has been canceled.)");
            timeStampList.add(timeStampModel);

            AppointModel orderUpdate = widget.appointModel.copyWith(
              appointmentInfo: widget.appointModel.appointmentInfo!.copyWith(
                status: "(Cancel)",
              ),
              timeStampList: timeStampList,
            );
            BookingProvider bookingProvider =
                Provider.of<BookingProvider>(context, listen: false);

            bookingProvider.updateAppointment(
                userModel.id, widget.appointModel.orderId, orderUpdate);
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pop();
            showMessage("Appointment has been cancelled ");
          } catch (e) {
            Navigator.of(context, rootNavigator: true).pop();
            showMessage("Error : Appointment is not cancelled ");
            print("Error : $e ");
          }
        });
      },
      icon: const Icon(
        Icons.delete_forever_sharp,
        color: Colors.red,
      ),
    );
  }

  Padding servicerList() {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.dimensionNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Service List",
                style: TextStyle(
                  fontSize: Dimensions.dimensionNo15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showServiceList = !showServiceList;
                  });
                },
                icon: FaIcon(
                  showServiceList
                      ? FontAwesomeIcons.minus
                      : FontAwesomeIcons.plus,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.dimensionNo10),
          if (showServiceList) ...[
            ...appProvider.getServiceListFetchID.map(
              (singleService) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimensionNo18_5,
                  ),
                  child: SingleServiceOrderList(
                    serviceModel: singleService,
                    showDelectIcon: false,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Padding productList() {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.dimensionNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Product List",
                style: TextStyle(
                  fontSize: Dimensions.dimensionNo15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showProductList = !showProductList;
                  });
                },
                icon: FaIcon(
                  showProductList
                      ? FontAwesomeIcons.minus
                      : FontAwesomeIcons.plus,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.dimensionNo10),
          if (showProductList) ...[
            ...appProvider.getProductListFetchID.map(
              (singleProduct) {
                final qty = widget
                    .appointModel.productBillModel!.productListIdQty.entries
                    .firstWhere((e) => e.key == singleProduct.id,
                        orElse: () => MapEntry('', 0))
                    .value;
                return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.dimensionNo18_5,
                    ),
                    child: singleProductNameWithIncrOrDecrIcon(
                        product: singleProduct,
                        context: context,
                        showProductWithQty: true,
                        productQty: qty));
              },
            ),
          ],
        ],
      ),
    );
  }

  Padding appointBookingInfor(UserModel userModel) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.dimensionNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Book Details",
            style: TextStyle(
              fontSize: Dimensions.dimensionNo15,
              fontWeight: FontWeight.w600,
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.only(
                left: Dimensions.dimensionNo5, top: Dimensions.dimensionNo5),
            shrinkWrap: true,
            itemCount: widget.appointModel.timeStampList.length,
            itemBuilder: (context, index) {
              final singleTimeDate = widget.appointModel.timeStampList[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0) // Display first element separately
                    Text(
                      "Book on ${DateFormat('dd MMM yyyy').format(singleTimeDate.dateAndTime)} at ${DateFormat('hh:mm a').format(singleTimeDate.dateAndTime)} by ${singleTimeDate.updateBy}",
                    ),
                  if (index > 0) // Display remaining elements separately
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4), // Adds spacing for readability
                      child: Text(
                        "Update on ${DateFormat('dd MMM yyyy').format(singleTimeDate.dateAndTime)} at ${DateFormat('hh:mm a').format(singleTimeDate.dateAndTime)} by ${singleTimeDate.updateBy}",
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Padding pricreInfor() {
    final bool hasFlat = (widget.appointModel.extraDiscountInAmount != null &&
        widget.appointModel.extraDiscountInAmount != 0.0);
    final bool hasPer = (widget.appointModel.extraDiscountInPerAMT != null &&
        widget.appointModel.extraDiscountInPerAMT != 0.0);
    return Padding(
      padding: EdgeInsets.all(Dimensions.dimensionNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimensionNo18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(
            height: Dimensions.dimensionNo12,
          ),
          // Price Details Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Payment Status',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        // fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.appointModel.payment,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimensionNo20),
                Row(
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.90,
                      ),
                    ),
                    SizedBox(width: Dimensions.dimensionNo5),
                    Text(
                      '(services ${widget.appointModel.serviceBillModel!.serviceListId.length})',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        // fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.currency_rupee,
                      size: Dimensions.dimensionNo18,
                    ),
                    Text(
                      widget.appointModel.subTotalBill.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimensionNo10),

// Item Discount
                widget.appointModel.discountBill != 0.0
                    ? Row(
                        children: [
                          Text(
                            // 'item Discount ${widget.appointModel.discountInPer!.round().toString()}%',
                            'item Discount',

                            style: TextStyle(
                              fontSize: Dimensions.dimensionNo14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.90,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "-₹${widget.appointModel.discountBill.round().toString()}",
                            style: TextStyle(
                              fontSize: Dimensions.dimensionNo14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                              letterSpacing: 0.90,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(height: Dimensions.dimensionNo10),
// Extra Discount in per
                widget.appointModel.extraDiscountInPerAMT != 0.0
                    ? Padding(
                        padding:
                            EdgeInsets.only(bottom: Dimensions.dimensionNo10),
                        child: Row(
                          children: [
                            Text(
                              "Extra Discount ${widget.appointModel.extraDiscountInPer ?? 0} %",
                              style: TextStyle(
                                fontSize: Dimensions.dimensionNo14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.90,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "-₹${((widget.appointModel.extraDiscountInPerAMT ?? 0.0)).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: Dimensions.dimensionNo14,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                letterSpacing: 0.90,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
// Extra Discount in Flat Discount
                widget.appointModel.extraDiscountInAmount != 0.0
                    ? Padding(
                        padding:
                            EdgeInsets.only(bottom: Dimensions.dimensionNo10),
                        child: Row(
                          children: [
                            Text(
                              'Flat Discount',
                              style: TextStyle(
                                fontSize: Dimensions.dimensionNo14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.90,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "-₹${widget.appointModel.extraDiscountInAmount!.round().toString()}",
                              style: TextStyle(
                                fontSize: Dimensions.dimensionNo14,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                letterSpacing: 0.90,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                Row(
                  children: [
                    Text(
                      'Net',
                      style: TextStyle(
                        fontSize: Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "₹${widget.appointModel.netPriceBill.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimensionNo10),
                //
                // Price
                widget.appointModel.gstAmountBill != 0.0
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'GST 18% (SGST & CGST)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimensionNo14,
                                  // fontWeight: FontWeight.w500,
                                  letterSpacing: 0.90,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.currency_rupee,
                                size: Dimensions.dimensionNo14,
                              ),
                              Text(
                                widget.appointModel.gstAmountBill
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimensionNo14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.90,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.dimensionNo10),
                        ],
                      )
                    : const SizedBox(),
                Row(
                  children: [
                    Text(
                      'Platform Fees',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        // fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.currency_rupee,
                      size: Dimensions.dimensionNo14,
                    ),
                    Text(
                      widget.appointModel.platformFeeBill.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimensionNo20),

                // Total Amount
                Row(
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.currency_rupee,
                      size: Dimensions.dimensionNo18,
                    ),
                    Text(
                      widget.appointModel.finalTotalBill.round().toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
