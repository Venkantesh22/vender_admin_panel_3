// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/price_text.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/features/payment/bill_pdf.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class UserSideBarPaymentScreen extends StatefulWidget {
  final int index;
  final AppointModel appointModel;
  const UserSideBarPaymentScreen({
    super.key,
    required this.appointModel,
    required this.index,
  });

  @override
  State<UserSideBarPaymentScreen> createState() =>
      _UserSideBarPaymentScreenState();
}

class _UserSideBarPaymentScreenState extends State<UserSideBarPaymentScreen> {
  bool isExtroDiscountApply = false;
  bool _isLoading = false;

  UPIDetails? upiDetails;
  late VenderPaymentDetailsModel? _venderPaymentDetailsModel;
  late AppointModel _appointModel;
  SettingModel? _settingModel;

  double finalAmount = 0.0;
  double netAmount = 0.0;
  double gstAmount = 0.0;
  double extraDiscountAmount = 0.0;

  final List<String> _paymentOptions = ["Cash", "QR", "Custom"];
  String _selectedPaymentMethod = "Cash";
  final TextEditingController _cashReceivedController =
      TextEditingController(text: "0.0");
  final TextEditingController _extraDiscountInPer =
      TextEditingController(text: "0.0");
  final TextEditingController _transactionIdController =
      TextEditingController(text: "0");

//
  double get _cashToGiveBack {
    final cashReceived = double.tryParse(_cashReceivedController.text) ?? 0.0;
    return cashReceived - finalTotalAmountFun();
  }

// Cal Extra Discount Fun
  double _extraDiscontAmountFun1() {
    final discountPercentage = double.tryParse(_extraDiscountInPer.text) ?? 0.0;
    final validPercentage = discountPercentage.clamp(0.0, 100.0);
    double _discountAmount = (validPercentage / 100) * _appointModel.subtatal;
    return _discountAmount;
  }

//cal for final Amount
  double finalTotalAmountFun() {
    double finalAmountlocal =
        netPriceFun() + calGSTInclustiveFun() + _appointModel.platformFees;
    return finalAmountlocal;
  }

  // Cal for GST price
  double calGSTInclustiveFun() {
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    if (_appointModel.gstIsIncludingOrExcluding ==
        GlobalVariable.GstInclusive) {
      double gSTInclustive = netPriceFun() * 0.18;
      return _appointModel.gstNo.isEmpty || _appointModel.gstNo == null
          ? 0.0
          : gSTInclustive;
    } else if (_appointModel.gstIsIncludingOrExcluding ==
        GlobalVariable.GstExclusive) {
      double gSTInclustive =
          (bookingProvider.getSalonGSTPer! / 100) * netPriceFun();
      return _appointModel.gstNo.isEmpty || _appointModel.gstNo == null
          ? 0.0
          : gSTInclustive;
    } else {
      return 0.0;
    }
  }

  // Cal for Net price
  double netPriceFun() {
    if (_appointModel.gstIsIncludingOrExcluding ==
        GlobalVariable.GstInclusive) {
      double _net = (widget.appointModel.subtatal -
              widget.appointModel.discountAmount! -
              _extraDiscontAmountFun1()) /
          1.18;
      return _net;
    } else if (_appointModel.gstIsIncludingOrExcluding ==
        GlobalVariable.GstExclusive) {
      double _net = (widget.appointModel.subtatal -
          widget.appointModel.discountAmount! -
          _extraDiscontAmountFun1());
      return _net;
    } else {
      double _net = (widget.appointModel.subtatal -
          widget.appointModel.discountAmount! -
          _extraDiscontAmountFun1());
      return _net;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    _venderPaymentDetailsModel = await SettingFb.instance
        .fetchVenderPaymentFB(appProvider.getSalonInformation.id);

    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);

    await serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);
    _settingModel = serviceProvider.getSettingModel!;

    _appointModel = widget.appointModel;

    _cashReceivedController.text = "0.0";
    _extraDiscountInPer.text = "0.0";
    _transactionIdController.text = "0";
    finalAmount = widget.appointModel.totalPrice;
    gstAmount = widget.appointModel.gstAmount;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _cashReceivedController.dispose();
    _extraDiscountInPer.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BillPaymentAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  color: AppColor.whileColor,
                  constraints: BoxConstraints(
                    maxWidth: Dimensions.screenWidth / 1.5,
                    maxHeight: Dimensions.screenHeight * 0.9,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimenisonNo16,
                    vertical: Dimensions.dimenisonNo10,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPaymentDetailsSection(),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        _buildPaymentOptionsSection(),
                        billButtom(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  AppBar BillPaymentAppBar() {
    return AppBar(
      backgroundColor: AppColor.mainColor,
      actions: [
        Container(
          margin: EdgeInsets.only(left: Dimensions.dimenisonNo20),
          child: IconButton(
            onPressed: () {
              setState(() {
                isExtroDiscountApply = !isExtroDiscountApply;
              });
            },
            icon: Icon(
              Icons.percent,
              color: Colors.white,
              size: Dimensions.dimenisonNo18,
            ),
          ),
        )
      ],
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Bill Page",
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.dimenisonNo18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: Dimensions.dimenisonNo8),
            Text(
              "Power by Samay",
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.dimenisonNo12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          firstText: "Payment Method:",
          lastText: widget.appointModel.payment,
        ),
        SizedBox(height: Dimensions.dimenisonNo10),
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              pricreInfor(),
              SizedBox(height: Dimensions.dimenisonNo10),
              SizedBox(height: Dimensions.dimenisonNo8),
              const Divider(),
              _buildFinalAmountRow(),
            ],
          ),
        ),
      ],
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
                Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.dimenisonNo10),
                  child: Row(
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
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.90,
                        ),
                      ),
                    ],
                  ),
                ),

// Item Discount
                widget.appointModel.discountInPer != 0.0
                    ? Padding(
                        padding:
                            EdgeInsets.only(bottom: Dimensions.dimenisonNo10),
                        child: Row(
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
                        ),
                      )
                    : const SizedBox(),

// Extra Discount
                isExtroDiscountApply
                    ? _buildDiscountInputRow()
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
                      // "₹${}",
                      "₹${netPriceFun().toStringAsFixed(2)}",
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
                              Text(
                                "₹${calGSTInclustiveFun().toStringAsFixed(2)}",
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
                SizedBox(height: Dimensions.dimenisonNo8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountInputRow() {
    return Column(
      children: [
        // Row for entering the extra discount percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Extra Discount :",
              style: TextStyle(
                fontSize: Dimensions.dimenisonNo14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: Dimensions.dimenisonNo110,
              child: TextField(
                controller: _extraDiscountInPer,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Discount",
                  errorText: _validateDiscountInput(),
                  errorStyle: TextStyle(fontSize: Dimensions.dimenisonNo12),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Icon(Icons.percent, size: Dimensions.dimenisonNo16),
          ],
        ),
        SizedBox(height: Dimensions.dimenisonNo8),
        // Row for displaying calculated extra discount amount
        Row(
          children: [
            Text(
              "Extra Discount Amount:",
              style: TextStyle(
                fontSize: Dimensions.dimenisonNo14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: Dimensions.dimenisonNo110,
              child: Text(
                "-₹${_extraDiscontAmountFun1().toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: Dimensions.dimenisonNo14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.80,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.dimenisonNo10),
      ],
    );
  }

  String? _validateDiscountInput() {
    final value = double.tryParse(_extraDiscountInPer.text);
    if (value == null && _extraDiscountInPer.text.isNotEmpty) {
      return 'Invalid number';
    }
    if (value != null && (value < 0 || value > 100)) {
      return '0-100% only';
    }
    return null;
  }

  Widget _buildFinalAmountRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.dimenisonNo16),
      child: Row(
        children: [
          Text(
            "Final Total Amount :",
            style: TextStyle(
              fontSize: Dimensions.dimenisonNo15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            "₹${finalTotalAmountFun().round()}",
            style: TextStyle(
              fontSize: Dimensions.dimenisonNo16,
              fontWeight: FontWeight.bold,
              color: finalTotalAmountFun() < finalAmount
                  ? Colors.green
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionsSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Options',
          style: TextStyle(
            fontSize: Dimensions.dimenisonNo20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Dimensions.dimenisonNo12),
        Container(
          padding: EdgeInsets.all(Dimensions.dimenisonNo8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo12),
            border: Border.all(width: 1.6, color: Colors.black),
          ),
          child: _buildPaymentMethodSelector(),
        ),
        SizedBox(height: Dimensions.dimenisonNo12),
        Text(
          "Note: Online payments coming soon. Currently only cash payments available.",
          style: TextStyle(
            color: Colors.red,
            fontSize: Dimensions.dimenisonNo12,
          ),
          softWrap: true,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      constraints: BoxConstraints(maxHeight: Dimensions.screenHeight * 0.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                items: _paymentOptions
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (newValue) => setState(() {
                  _selectedPaymentMethod = newValue!;
                  if (_selectedPaymentMethod == "QR") {
                    if (_venderPaymentDetailsModel != null &&
                        _venderPaymentDetailsModel!.upiID.isNotEmpty) {
                      upiDetails = UPIDetails(
                        upiID: _venderPaymentDetailsModel!.upiID,
                        payeeName: widget.appointModel.userModel.name,
                        amount: finalTotalAmountFun(),
                        transactionNote:
                            "Thank you for booking services on Samay.",
                      );
                    } else {
                      // Fallback default UPI value if not available
                      upiDetails = UPIDetails(
                        upiID: " ",
                        payeeName: '',
                        amount: 0,
                        transactionNote: "",
                      );
                    }
                  } else if (_selectedPaymentMethod == "Custom") {
                    // For custom, we may show a custom payment section
                    upiDetails = null;
                  } else {
                    upiDetails = null;
                  }
                }),
                decoration: const InputDecoration(
                  labelText: "Payment Method",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey.shade100,
              child: _selectedPaymentMethod == "Cash"
                  ? _buildCashPaymentSection()
                  : _selectedPaymentMethod == "QR"
                      ? _buildQRPaymentSection()
                      : _buildCustomPaymentSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashPaymentSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _cashReceivedController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Cash Received",
            errorText: _validateCashInput(),
          ),
          onChanged: (value) => setState(() {}),
        ),
        SizedBox(height: Dimensions.dimenisonNo16),
        Text(
          "Change Due: ₹${_cashToGiveBack.round()}",
          style: TextStyle(
            fontSize: Dimensions.dimenisonNo16,
            color: _cashToGiveBack >= 0 ? Colors.green : Colors.red,
          ),
        ),
        if (finalTotalAmountFun() < 0)
          Text(
            "Insufficient cash received",
            style: TextStyle(
              color: Colors.red,
              fontSize: Dimensions.dimenisonNo12,
            ),
          ),
      ],
    );
  }

  String? _validateCashInput() {
    final value = double.tryParse(_cashReceivedController.text);
    if (value == null && _cashReceivedController.text.isNotEmpty) {
      return 'Invalid amount';
    }
    return null;
  }

  Widget _buildQRPaymentSection() {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Dimensions.screenHeight * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Dimensions.dimenisonNo150,
              width: Dimensions.dimenisonNo150,
              child: UPIPaymentQRCode(upiDetails: upiDetails!),
            ),
            SizedBox(height: Dimensions.dimenisonNo8),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo20),
              child: SizedBox(
                height: Dimensions.dimenisonNo30,
                child: TextField(
                  controller: _transactionIdController,
                  style: TextStyle(fontSize: Dimensions.dimenisonNo12),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Transaction ID",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Payment Section for "Custom" payment option
  Widget _buildCustomPaymentSection() {
    return Center(
      child: Text(
        "Custom Payment method selected.",
        style: TextStyle(fontSize: Dimensions.dimenisonNo14),
      ),
    );
  }

  CustomAuthButton billButtom() => CustomAuthButton(
        text: "Generate Bill",
        ontap: () async {
          showLoaderDialog(context);

          BookingProvider _bookingProvider =
              Provider.of<BookingProvider>(context, listen: false);
          AppProvider appProvider =
              Provider.of<AppProvider>(context, listen: false);
          // ServiceProvider serviceProvider =
          //     Provider.of<ServiceProvider>(context, listen: false);

          // await serviceProvider
          //     .fetchSettingPro(appProvider.getSalonInformation.id);
          // _settingModel = serviceProvider.getSettingModel!;

          SalonModel _salonModle = await appProvider.getSalonInformation;
// update TimeStamp List
          List<TimeStampModel> _timeStampList = [];
          _timeStampList.addAll(widget.appointModel.timeStampList);

          TimeStampModel _timeStampModel = TimeStampModel(
              id: widget.appointModel.orderId,
              dateAndTime: GlobalVariable.today,
              updateBy:
                  "${appProvider.getSalonInformation.name} Bill Generate");
          _timeStampList.add(_timeStampModel);

// Update Appointment Payment information
          AppointModel _updataAppointModel =
              //  _settingModel!
              //             .gSTIsIncludingOrExcluding ==
              //         GlobalVariable.GstInclusive
              // ?
              widget.appointModel.copyWith(
            extraDiscountInPer:
                double.tryParse(_extraDiscountInPer.text.trim()) ?? 0.0,
            extraDiscountInAmount: _extraDiscontAmountFun1() ?? 0.0,
            transactionId: _transactionIdController.text.trim().isNotEmpty
                ? _transactionIdController.text.trim()
                : "00",
            gstAmount: calGSTInclustiveFun(),
            totalPrice: finalTotalAmountFun(),
            netPrice: netPriceFun(),
            status: "Bill Generate",
            payment:
                _selectedPaymentMethod == "QR" ? "UPI" : _selectedPaymentMethod,
            timeStampList: _timeStampList,
          );

          bool _isUpdate = await _bookingProvider.updateAppointment(
            widget.index,
            widget.appointModel.userModel.id,
            widget.appointModel.orderId,
            _updataAppointModel,
          );

          Navigator.pop(context);
          print(
              "salon Id ${widget.appointModel.vendorId}   ,${appProvider.getSalonInformation.id}");

          AppointModel _appointModel = await UserBookingFB.instance
              .getSingleApointByIdFB(
                  widget.appointModel.userId, widget.appointModel.orderId);

          if (_isUpdate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BillPdfPage(
                  appointModel: _appointModel,
                  salonModel: _salonModle,
                  settingModel: _settingModel!,
                ),
              ),
            );
            showMessage("Successfully billing an appointment");
          }
        },
      );
}
