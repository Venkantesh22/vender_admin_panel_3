import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Direct%20Billing/screen/edit_direct_billing.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/add_new_appointment/screen/edit_appointment.dart';
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
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/custom_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointInFoMobile extends StatefulWidget {
  final UserModel user;
  final AppointModel appointModel;
  final int index;

  const AppointInFoMobile({
    super.key,
    required this.appointModel,
    required this.index,
    required this.user,
  });

  @override
  State<AppointInFoMobile> createState() => _UserInfoSideBarState();
}

class _UserInfoSideBarState extends State<AppointInFoMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  // double extroDiscountAmount = 0.0;

  late SalonModel salonModel;
  late SettingModel _settingModel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    salonModel = appProvider.getSalonInformation;

    await serviceProvider.fetchSettingPro(salonModel.id);
    _settingModel = serviceProvider.getSettingModel!;

    setState(() {
      isLoading = false;
    });
  }

  double get _netPriceFun {
    double _net = (widget.appointModel.subtatal -
            widget.appointModel.discountAmount! -
            widget.appointModel.extraDiscountInAmount!) /
        1.18;
    return _net;
  }

  @override
  Widget build(BuildContext context) {
    Duration? appointDuration =
        Duration(minutes: widget.appointModel.serviceDuration);
    UserModel userModel = widget.user;
    bool activateDeleteAndEditButton = false;
    if (widget.appointModel.status == "(Cancel)" ||
        widget.appointModel.status == "Completed" ||
        widget.appointModel.status == "Bill Generate") {
      activateDeleteAndEditButton = true;
    } else {
      activateDeleteAndEditButton = false;
    }
    // // Method to launch the dialer with the phone number

    // Method to open WhatsApp with the phone number
    Future<void> _openWhatsApp(String phoneNumber) async {
      try {
        final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
        await launchUrl(whatsappUrl);
      } catch (e) {
        showMessage('Could not launch WhatsApp $e');
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(scaffoldKey: _scaffoldKey),
      ),
      drawer: MobileDrawer(),
      key: _scaffoldKey,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
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
                      apointHeadingPart(
                          context, activateDeleteAndEditButton, userModel),
                      Divider(thickness: Dimensions.dimenisonNo5),
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
                          horizontal: Dimensions.dimenisonNo16,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green[100],
                              backgroundImage: NetworkImage(
                                userModel.image,
                              ),
                              radius: Dimensions.dimenisonNo20,
                            ),
                            SizedBox(width: Dimensions.dimenisonNo10),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userModel.name,
                                        style: TextStyle(
                                          overflow: TextOverflow.clip,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimensions.dimenisonNo16,
                                        ),
                                      ),
                                      Text(
                                        "M.no ${userModel.phone}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dimensions.dimenisonNo14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomIconButton(
                                    icon: FontAwesomeIcons.whatsapp,
                                    ontap: () {
                                      _openWhatsApp(
                                          "${GlobalVariable.indiaCode}${widget.appointModel.userModel.phone.toString()}");
                                    },
                                    iconSize: Dimensions.dimenisonNo30,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.only(left: Dimensions.dimenisonNo16),
                        child: Center(
                          child: Text(
                            'Appointment Information',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimenisonNo18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.dimenisonNo16),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.dimenisonNo16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Appointment Time",
                              style: TextStyle(
                                fontSize: Dimensions.dimenisonNo15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: Dimensions.dimenisonNo5,
                                    left: Dimensions.dimenisonNo5,
                                    bottom: Dimensions.dimenisonNo10),
                                child: Text(
                                  "${DateFormat('hh:mm a').format(widget.appointModel.serviceStartTime)} To ${DateFormat('hh:mm a').format(widget.appointModel.serviceEndTime)} (${appointDuration.inHours}h : ${appointDuration.inMinutes % 60}m)",
                                  style: TextStyle(
                                    color: Color(0xFF1F1616),
                                    fontSize: Dimensions.dimenisonNo14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.90,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      UserInfoDateTimeColumn(
                        title: "Appointment Date",
                        time: widget.appointModel.serviceDate,
                        isTime: false,
                      ),
                      userInfoColumn(
                        title: "Appointment No.",
                        infoText:
                            ' 000${widget.appointModel.appointmentNo.toString()}',
                      ),
                      userInfoColumn(
                        title: "Service At.",
                        infoText: widget.appointModel.serviceAt,
                      ),
                      widget.appointModel.serviceAt ==
                              GlobalVariable.serviceAtHome
                          ? userInfoColumn(
                              title: "Address",
                              infoText: widget.appointModel.serviceAddress!,
                            )
                          : SizedBox(),
                      Divider(thickness: Dimensions.dimenisonNo5),
                      //Service List
                      servicerLIst(),
                      SizedBox(height: Dimensions.dimenisonNo10),

                      const Divider(),
                      widget.appointModel.userNote.length >= 2
                          ? userInfoColumn(
                              title: "Client Note",
                              infoText: widget.appointModel.userNote)
                          : const userInfoColumn(
                              title: "Client Note", infoText: "No user note"),
                      //payment section
                      SizedBox(height: Dimensions.dimenisonNo10),

                      const Divider(thickness: 3),

                      // Price Details Section

                      pricreInfor(),
                      SizedBox(height: Dimensions.dimenisonNo10),

                      const Divider(thickness: 3),
                      appointBookingInfor(userModel),
                      SizedBox(height: Dimensions.dimenisonNo20),
                      Opacity(
                        // opacity: widget.appointModel.status != "Completed" ? 0.5 : 1.0,
                        opacity:
                            widget.appointModel.status == "Pen" ? 0.5 : 1.0,
                        child: IgnorePointer(
                          // ignoring: widget.appointModel.status != "Completed",
                          ignoring: widget.appointModel.status == "Pen",
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.dimenisonNo16),
                            width: double.infinity,
                            child: CustomButtom(
                                text: "CheckOut",
                                ontap: () {
                                  Routes.instance.push(
                                      widget: UserSideBarPaymentScreen(
                                        appointModel: widget.appointModel,
                                        index: widget.index,
                                      ),
                                      context: context);
                                },
                                buttonColor: AppColor.buttonColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.dimenisonNo20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Padding apointHeadingPart(BuildContext context,
      bool activateDeleteAndEditButton, UserModel userModel) {
    final status = widget.appointModel.status ?? "";
    final isCancelled = status == "(Cancel)";
    final isUpdated = widget.appointModel.isUpdate == true;
    final isBillGenerated = status == "Bill Generate";

    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.dimenisonNo16,
        right: Dimensions.dimenisonNo16,
        top: Dimensions.dimenisonNo18,
      ),

      //! heading bar of Appointment

      child: Row(
        children: [
          Text(
            'Appointment',
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
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
                        SizedBox(width: Dimensions.dimenisonNo5),
                        cancelAppointButton(context, userModel),
                        if (isBillGenerated)
                          IconButton(
                            onPressed: () async {
                              try {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BillPdfPage(
                                      appointModel: widget.appointModel,
                                      salonModel: salonModel,
                                      settingModel: _settingModel,
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
                        SizedBox(width: Dimensions.dimenisonNo12),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editAppointButton(BuildContext context, UserModel userModel) {
    return IconButton(
      onPressed: () {
        BookingProvider bookingProvider =
            Provider.of<BookingProvider>(context, listen: false);
        bookingProvider.getWatchList.clear();
        bookingProvider.getWatchList.addAll(widget.appointModel.services);

        widget.appointModel.status == GlobalVariable.billGenerateAppointState
            ? Routes.instance.push(
                widget: EditDirectBillingScreen(
                  salonModel: salonModel,
                  appointModel: widget.appointModel,
                  userModel: userModel,
                ),
                context: context)
            : Routes.instance.push(
                widget: EditAppointment(
                  index: widget.index,
                  appintModel: widget.appointModel,
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
            List<TimeStampModel> _timeStampList = [];
            _timeStampList.addAll(widget.appointModel.timeStampList);
            TimeStampModel _timeStampModel = TimeStampModel(
                id: widget.appointModel.orderId,
                dateAndTime: GlobalVariable.today,
                updateBy: "${userModel.name} (Appointment has been canceled.)");
            _timeStampList.add(_timeStampModel);

            AppointModel orderUpdate = widget.appointModel
                .copyWith(status: "(Cancel)", timeStampList: _timeStampList);
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

  Padding servicerLIst() {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.dimenisonNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service List",
            style: TextStyle(
              fontSize: Dimensions.dimenisonNo15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.dimenisonNo10),
          ...widget.appointModel.services.map(
            (singleService) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimenisonNo18_5),
                child: SingleServiceOrderList(
                  serviceModel: singleService,
                  showDelectIcon: false,
                ),
              );
            },
          ).toList(),
        ],
      ),
    );
  }

  Padding appointBookingInfor(UserModel userModel) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.dimenisonNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Book Details",
            style: TextStyle(
              fontSize: Dimensions.dimenisonNo15,
              fontWeight: FontWeight.w600,
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.only(left: Dimensions.dimenisonNo5),
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
                      padding: EdgeInsets.only(
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
    return Padding(
      padding: EdgeInsets.all(Dimensions.dimenisonNo16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(
            height: Dimensions.dimenisonNo12,
          ),
          // Price Details Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Payment Status',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        // fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.appointModel.payment,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimenisonNo20),
                Row(
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.90,
                      ),
                    ),
                    SizedBox(width: Dimensions.dimenisonNo5),
                    Text(
                      '(services ${widget.appointModel.services.length})',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        // fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.currency_rupee,
                      size: Dimensions.dimenisonNo18,
                    ),
                    Text(
                      widget.appointModel.subtatal.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimenisonNo10),

// Item Discount
                widget.appointModel.discountInPer != 0.0
                    ? Row(
                        children: [
                          Text(
                            'item Discount ${widget.appointModel.discountInPer!.round().toString()}%',
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.90,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "-₹${widget.appointModel.discountAmount!.round().toString()}",
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                              letterSpacing: 0.90,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(height: Dimensions.dimenisonNo10),
// Extra Discount in per
                widget.appointModel.extraDiscountInPerAMT != 0.0
                    ? Padding(
                        padding:
                            EdgeInsets.only(bottom: Dimensions.dimenisonNo10),
                        child: Row(
                          children: [
                            Text(
                              'Extra Discount ${widget.appointModel.extraDiscountInPer!.round().toString()}%',
                              style: TextStyle(
                                fontSize: Dimensions.dimenisonNo14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.90,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "-₹${widget.appointModel.extraDiscountInAmount!.round().toString()}",
                              style: TextStyle(
                                fontSize: Dimensions.dimenisonNo14,
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
                            EdgeInsets.only(bottom: Dimensions.dimenisonNo10),
                        child: Row(
                          children: [
                            Text(
                              'Flat Discount',
                              style: TextStyle(
                                fontSize: Dimensions.dimenisonNo14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.90,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "-₹${widget.appointModel.extraDiscountInAmount!.round().toString()}",
                              style: TextStyle(
                                fontSize: Dimensions.dimenisonNo14,
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
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "₹${widget.appointModel.netPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimenisonNo10),
                // GST Price
                widget.appointModel.gstAmount != 0.0
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'GST 18% (SGST & CGST)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimenisonNo14,
                                  // fontWeight: FontWeight.w500,
                                  letterSpacing: 0.90,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.currency_rupee,
                                size: Dimensions.dimenisonNo14,
                              ),
                              Text(
                                widget.appointModel.gstAmount
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimenisonNo14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.90,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.dimenisonNo10),
                        ],
                      )
                    : SizedBox(),
                Row(
                  children: [
                    Text(
                      'Platform Fees',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        // fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.currency_rupee,
                      size: Dimensions.dimenisonNo14,
                    ),
                    Text(
                      widget.appointModel.platformFees.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimenisonNo20),

                // Total Amount
                Row(
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.90,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.currency_rupee,
                      size: Dimensions.dimenisonNo18,
                    ),
                    Text(
                      widget.appointModel.totalPrice.round().toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo16,
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
