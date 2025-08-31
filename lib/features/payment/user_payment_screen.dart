// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/price_text.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/features/payment/bill_pdf.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/samay_salon_settng_model/samay_salon_setting.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/billing_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class UserSideBarPaymentScreen extends StatefulWidget {
  final AppointModel? appointModel;

  const UserSideBarPaymentScreen({
    super.key,
    this.appointModel,
  });

  @override
  State<UserSideBarPaymentScreen> createState() =>
      _UserSideBarPaymentScreenState();
}

class _UserSideBarPaymentScreenState extends State<UserSideBarPaymentScreen> {
  bool isExtraDiscountApply = false;
  bool _isLoading = false;
  bool serviceIsGstInclusive = false;

  UPIDetails? upiDetails;
  late VenderPaymentDetailsModel? _venderPaymentDetailsModel;
  late AppointModel _appointModel;
  SettingModel? _settingModel;
  SamaySalonSettingModel? _samaySalonSettingModel;

  // double finalAmount = 0.0;
  // double gstAmount = 0.0;

  late BillingProvider _billingProvider;

  final List<String> _paymentOptions = [
    GlobalVariable.cashPayment,
    GlobalVariable.qRPayment,
    GlobalVariable.pAPPayment
  ];
  String _selectedPaymentMethod = GlobalVariable.cashPayment;
  final TextEditingController _cashReceivedController =
      TextEditingController(text: "0.0");
  final TextEditingController _extraDiscountInPer =
      TextEditingController(text: "0.0");
  final TextEditingController _extraDiscountInDirectAmount =
      TextEditingController(text: "0.0");
  final TextEditingController _transactionIdController =
      TextEditingController(text: "0");

  double get _cashToGiveBack {
    BillingProvider billingProvider =
        Provider.of<BillingProvider>(context, listen: false);

    final cashReceived = double.tryParse(_cashReceivedController.text) ?? 0.0;
    return cashReceived - billingProvider.getFinalTotal;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void applyExtraDisco() {
    if (widget.appointModel!.extraDiscountInAmount != null &&
            widget.appointModel!.extraDiscountInAmount! > 0 ||
        widget.appointModel!.extraDiscountInPer != null &&
            widget.appointModel!.extraDiscountInPer! > 0) {

      _extraDiscountInDirectAmount.text =
          widget.appointModel!.extraDiscountInAmount.toString();
      _extraDiscountInPer.text =
          widget.appointModel!.extraDiscountInPer.toString();
      isExtraDiscountApply = true;
 Provider.of<BillingProvider>(context, listen: false)
                      .setExtraFixed(double.tryParse(_extraDiscountInDirectAmount.text) ?? 0.0);
      Provider.of<BillingProvider>(context, listen: false)
          .setExtraPercent(double.tryParse(_extraDiscountInPer.text) ?? 0.0);
      // Keep bookingProvider in sync if you need:
      Provider.of<BookingProvider>(context, listen: false)
          .setExtraDiscountInPerAmount(
              /* you can compute amount or pass 0 here */ 0.0);
    }
  }

  @override
  void dispose() {
    _cashReceivedController.dispose();
    _extraDiscountInPer.dispose();
    _extraDiscountInDirectAmount.dispose();
    _transactionIdController.dispose();
    super.dispose();
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
    _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();

    _settingModel = serviceProvider.getSettingModel!;

    // Fix: Only fetch by ID if appointModel is null and appointID is not null or empty

    _appointModel = widget.appointModel!;

    serviceIsGstInclusive =
        _appointModel.serviceBillModel?.gstIsIncludingOrExcluding ==
                GlobalVariable.inclusiveGST
            ? true
            : false;
    print("serviceIsGstInclusive  : $serviceIsGstInclusive");

    _billingProvider = Provider.of<BillingProvider>(context, listen: false);
    // initialize billing provider with appointment values
    final billingProvider =
        Provider.of<BillingProvider>(context, listen: false);
    billingProvider.init(
      serviceSubtotalIn: _appointModel.serviceBillModel?.subTotalService ?? 0.0,
      serviceDiscountIn:
          _appointModel.serviceBillModel?.discountATMService ?? 0.0,
      productSubtotalIn: _appointModel.productBillModel?.subTotalProduct ?? 0.0,
      productDiscountIn:
          _appointModel.productBillModel?.discountATMProduct ?? 0.0,
      serviceGstInclusive: serviceIsGstInclusive,

      // (_appointModel.serviceBillModel?.gstIsIncludingOrExcluding ==
      //     "Inclusive"),
      gstPercentIn: GlobalVariable.gST18, // adapt to your setting field
    );

//! if update update a billing status appoint update extra discount
    applyExtraDisco();

    setState(() {
      _isLoading = false;
    });

    _cashReceivedController.text = "0.0";
    // _extraDiscountInPer.text = "0.0";
    _transactionIdController.text = "0";
    

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    // Show loading if still fetching or _appointModel is not loaded
    if (_isLoading || (_appointModel == null && widget.appointModel == null)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: BillPaymentAppBar(),
      backgroundColor: AppColor.whileColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  color: AppColor.whileColor,
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveLayout.isMobile(context)
                        ? Dimensions.screenHeightM
                        : Dimensions.screenWidth / 1.5,
                    // maxHeight: ResponsiveLayout.isMobile(context)
                    //     ? Dimensions.screenHeight
                    //     : Dimensions.screenHeight * 0.9,
                  ),
                  padding: ResponsiveLayout.isMobile(context)
                      ? EdgeInsets.symmetric(
                          horizontal: Dimensions.dimensionNo10,
                          vertical: Dimensions.dimensionNo10,
                        )
                      : EdgeInsets.symmetric(
                          horizontal: Dimensions.dimensionNo16,
                          vertical: Dimensions.dimensionNo10,
                        ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPaymentDetailsSection(bookingProvider),
                        SizedBox(height: Dimensions.dimensionNo20),
                        _buildPaymentOptionsSection(),
                        billButton(),
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
          margin: EdgeInsets.only(left: Dimensions.dimensionNo20),
          child: IconButton(
            onPressed: () {
              setState(() {
                isExtraDiscountApply = !isExtraDiscountApply;
              });
            },
            icon: Icon(
              Icons.percent,
              color: Colors.white,
              size: Dimensions.dimensionNo18,
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
                fontSize: Dimensions.dimensionNo18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: Dimensions.dimensionNo8),
            Text(
              "Power by Samay",
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.dimensionNo12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsSection(BookingProvider bookingProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          firstText: "Payment Method:",
          lastText: widget.appointModel!.payment,
        ),
        SizedBox(height: Dimensions.dimensionNo10),
        const Divider(),
        Padding(
          padding: ResponsiveLayout.isMobile(context)
              ? EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo5)
              : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              pricreInfor(),
              SizedBox(height: Dimensions.dimensionNo10),
              SizedBox(height: Dimensions.dimensionNo8),
              const Divider(),
              _buildFinalAmountRow(bookingProvider),
            ],
          ),
        ),
      ],
    );
  }

  Padding pricreInfor() {
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    return Padding(
      padding: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.zero
          : EdgeInsets.all(Dimensions.dimensionNo16),
      child: Consumer<BillingProvider>(
        builder: (context, billing, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo14
                      : Dimensions.dimensionNo18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: Dimensions.dimensionNo12),

              // Subtotal row
              _priceRow(
                label: 'Subtotal',
                value: billing.subtotal, // uses provider computed subtotal
                // optionally show breakdown
                trailing: Text(
                    '(services ${widget.appointModel!.serviceBillModel!.serviceListId.length})'),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.90,
                ),
              ),

              SizedBox(height: Dimensions.dimensionNo8),

              // Existing Discount row (existing discount from model)
              if (widget.appointModel!.discountBill != 0.0)
                Row(
                  children: [
                    Text(
                      // 'Item Discount ${bookingProvider.getDiscountInPer!.round()}%',
                      'Discount',
                      style: TextStyle(
                        fontSize: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo12
                            : Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "- ₹${_appointModel.discountBill.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo12
                            : Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ],
                ),

             

              SizedBox(height: Dimensions.dimensionNo8),

              // Extra Discount input row (keep your existing UI)
              isExtraDiscountApply
                  ? _buildDiscountInputRow(bookingProvider, billing)
                  : const SizedBox(),

              SizedBox(height: Dimensions.dimensionNo8),

              // Net Price
              _priceRow(
                label: 'Net Price',
                value: billing.getNetPrice,
                style: TextStyle(
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.90,
                ),
              ),

              SizedBox(height: Dimensions.dimensionNo8),

              // Platform Fee
              _priceRow(
                label: 'Platform Fees',
                value: double.tryParse(_samaySalonSettingModel!.platformFee) ??
                    0.0,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.90,
                ),
              ),

              SizedBox(height: Dimensions.dimensionNo8),

              // Taxable Amount
              // _priceRow(
              //     label: 'Taxable Amount', value: billing.getTaxableAmount),

              _settingModel!.gSTIsIncludingOrExcluding == null ||
                      _settingModel!.gSTIsIncludingOrExcluding!.isNotEmpty
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Taxable Amount',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? Dimensions.dimensionNo12
                                  : Dimensions.dimensionNo14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.90,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.currency_rupee,
                            size: Dimensions.dimensionNo14),
                        Text(
                          billing.getTaxableAmount.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveLayout.isMobile(context)
                                ? Dimensions.dimensionNo12
                                : Dimensions.dimensionNo14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.90,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),

              SizedBox(height: Dimensions.dimensionNo8),

              // GST row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'GST ${billing.gstPercent.toStringAsFixed(0)}% (SGST & CGST)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo12
                            : Dimensions.dimensionNo14,
                        // fontWeight: FontWeight.w500,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.currency_rupee, size: Dimensions.dimensionNo14),
                  Text(
                    billing.getGstAmount.toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimensionNo12
                          : Dimensions.dimensionNo14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.90,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.dimensionNo10),
            ],
          );
        },
      ),
    );
  }

// small helper for label/value rows
  Widget _priceRow(
      {required String label,
      required double value,
      Widget? trailing,
      required TextStyle style}) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.dimensionNo10),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14)),
          if (trailing != null) ...[SizedBox(width: 6), trailing],
          const Spacer(),
          Icon(Icons.currency_rupee, size: Dimensions.dimensionNo14),
          Text(value.toString(), style: style),
          // Text(value.toStringAsFixed(2), style: style),
        ],
      ),
    );
  }

// Extra Discount Input Row

  Widget _buildDiscountInputRow(
      BookingProvider bookingProvider, BillingProvider billingProvider) {
    return Column(
      children: [
        // Row for entering the extra discount percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Extra Discount :",
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimensionNo12
                    : Dimensions.dimensionNo14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: Dimensions.dimensionNo10,
            ),
            Expanded(
              child: TextField(
                controller: _extraDiscountInDirectAmount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Rupess ₹",
                  errorText:
                      validateDiscountInput(_extraDiscountInDirectAmount.text),
                  errorStyle: TextStyle(fontSize: Dimensions.dimensionNo12),
                ),
                onChanged: (value) {
                  final fixed = double.tryParse(value) ?? 0.0;
                  Provider.of<BillingProvider>(context, listen: false)
                      .setExtraFixed(fixed);

                  setState(() {}); // update UI
                },
              ),
            ),
            SizedBox(width: Dimensions.dimensionNo8),
            Expanded(
              child: TextField(
                controller: _extraDiscountInPer,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Discount",
                  errorText: validateDiscountInput(_extraDiscountInPer.text),
                  errorStyle: TextStyle(fontSize: Dimensions.dimensionNo12),
                ),
                onChanged: (value) {
                  final rawPercent = double.tryParse(value) ?? 0.0;
                  final clamped = rawPercent.clamp(0.0, 100.0);
                  Provider.of<BillingProvider>(context, listen: false)
                      .setExtraPercent(clamped);
                  // Keep bookingProvider in sync if you need:
                  Provider.of<BookingProvider>(context, listen: false)
                      .setExtraDiscountInPerAmount(
                          /* you can compute amount or pass 0 here */ 0.0);
                  setState(() {});
                },
              ),
            ),
            Icon(Icons.percent, size: Dimensions.dimensionNo16),
          ],
        ),
        SizedBox(height: Dimensions.dimensionNo8),
        // Row for displaying calculated extra discount amount
        Consumer<BillingProvider>(builder: (_, billing, __) {
          return Row(
            children: [
              Text(
                "Extra Discount Percentage Amount:",
                style: TextStyle(
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo12
                      : Dimensions.dimensionNo14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: Dimensions.dimensionNo110,
                child: Text(
                  // "-₹${(billingProvider.getTotalDiscountApplied - (widget.appointModel!.discountBill)).toStringAsFixed(2)}",
                  '-₹${billing.getExtraPercentApplied.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo12
                        : Dimensions.dimensionNo14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.80,
                  ),
                ),
              ),
            ],
          );
        }),
        SizedBox(height: Dimensions.dimensionNo10),
        _extraDiscountInDirectAmount.text.isEmpty
            ? const SizedBox()
            : Row(
                children: [
                  Text(
                    "Extra Discount Amount:",
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimensionNo12
                          : Dimensions.dimensionNo14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: Dimensions.dimensionNo110,
                    child: Text(
                      // "-₹${_extraDiscontDirectAmount().toStringAsFixed(2)}",
                      "-₹${_extraDiscountInDirectAmount.text}",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo12
                            : Dimensions.dimensionNo14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.80,
                      ),
                    ),
                  ),
                ],
              ),
        SizedBox(height: Dimensions.dimensionNo10),
      ],
    );
  }

  Widget _buildFinalAmountRow(BookingProvider bookingProvider) {
    return Consumer<BillingProvider>(builder: (context, billing, _) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.dimensionNo16),
        child: Row(
          children: [
            Text(
              "Final Total Amount :",
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context)
                    ? 13
                    : Dimensions.dimensionNo15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              billing.getFinalTotal.round().toString(),
              style: TextStyle(
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo14
                      : Dimensions.dimensionNo16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPaymentOptionsSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Options',
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimensionNo16
                : Dimensions.dimensionNo20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Dimensions.dimensionNo12),
        Container(
          padding: EdgeInsets.all(Dimensions.dimensionNo8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
            border: Border.all(width: 1.6, color: Colors.black),
          ),
          child: _buildPaymentMethodSelector(),
        ),
        SizedBox(height: Dimensions.dimensionNo12),
        Text(
          "Note: Online payments coming soon. Currently only cash payments available.",
          style: TextStyle(
            color: Colors.red,
            fontSize: Dimensions.dimensionNo12,
          ),
          softWrap: true,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

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
                        payeeName: widget.appointModel!.userModel.name,
                        amount: bookingProvider.getFinalPayableAMT!,
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
                  ? _buildCashPaymentSection(bookingProvider)
                  : _selectedPaymentMethod == "QR"
                      ? _buildQRPaymentSection()
                      : _buildCustomPaymentSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashPaymentSection(BookingProvider bookingProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _cashReceivedController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Cash Received",
            errorText: _validateCashInput(),
          ),
          onChanged: (value) => setState(() {}),
        ),
        SizedBox(height: Dimensions.dimensionNo16),
        Text(
          "Change Due: ₹${_cashToGiveBack.round()}",
          style: TextStyle(
            fontSize: Dimensions.dimensionNo16,
            color: _cashToGiveBack >= 0 ? Colors.green : Colors.red,
          ),
        ),
        if (bookingProvider.getFinalPayableAMT! < 0)
          Text(
            "Insufficient cash received",
            style: TextStyle(
              color: Colors.red,
              fontSize: Dimensions.dimensionNo12,
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
          maxHeight: ResponsiveLayout.isMobile(context)
              ? Dimensions.screenHeight * 0.8
              : Dimensions.screenHeight * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Dimensions.dimensionNo150,
              width: Dimensions.dimensionNo150,
              child: UPIPaymentQRCode(upiDetails: upiDetails!),
            ),
            SizedBox(height: Dimensions.dimensionNo8),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo20),
              child: SizedBox(
                height: Dimensions.dimensionNo30,
                child: TextField(
                  controller: _transactionIdController,
                  style: TextStyle(fontSize: Dimensions.dimensionNo12),
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
        style: TextStyle(fontSize: Dimensions.dimensionNo14),
      ),
    );
  }

  TextStyle appointSummaryTextStyle(BuildContext context,
      {Color? color, bool bold = false}) {
    double fontSize;
    if (ResponsiveLayout.isMobile(context)) {
      fontSize = Dimensions.dimensionNo13;
    } else if (ResponsiveLayout.isTablet(context)) {
      fontSize = Dimensions.dimensionNo15;
    } else {
      fontSize = Dimensions.dimensionNo17;
    }
    return TextStyle(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: color ?? Colors.black87,
      letterSpacing: 0.5,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  CustomAuthButton billButton() => CustomAuthButton(
        text: "Generate Bill",
        ontap: () async {
          showLoaderDialog(context);

          BookingProvider _bookingProvider =
              Provider.of<BookingProvider>(context, listen: false);

          AppProvider appProvider =
              Provider.of<AppProvider>(context, listen: false);
          final billing = Provider.of<BillingProvider>(context, listen: false);

          SalonModel _salonModel = appProvider.getSalonInformation;
// update TimeStamp List
          List<TimeStampModel> _timeStampList = [];
          _timeStampList.addAll(widget.appointModel!.timeStampList);

          TimeStampModel _timeStampModel = TimeStampModel(
              id: widget.appointModel!.orderId,
              dateAndTime: GlobalVariable.today,
              updateBy:
                  "${appProvider.getSalonInformation.name} Bill Generate");
          _timeStampList.add(_timeStampModel);

          double _extraDiscountInAmountLocal =
              _extraDiscountInDirectAmount.text.trim().isEmpty
                  ? 0.0
                  : double.parse(_extraDiscountInDirectAmount.text.trim());

          double _extraDiscountInPerLocal =
              _extraDiscountInPer.text.trim().isEmpty
                  ? 0.0
                  : double.parse(_extraDiscountInPer.text.trim());

          print("Extra Discount in %: $_extraDiscountInPerLocal");
          // Create updated model with discount values from billing provider
          AppointModel _updataAppointModel = widget.appointModel!.copyWith(
            // existing extra fields
            extraDiscountInPer:
                double.tryParse(_extraDiscountInPer.text.trim()) ?? 0.0,
            extraDiscountInPerAMT: billing
                .getExtraPercentApplied, // amount that extra discounts applied
            extraDiscountInAmount:
                double.tryParse(_extraDiscountInDirectAmount.text.trim()) ??
                    0.0,

            // Update discountBill (total discount), netPriceBill, taxableAmountBill, gstAmountBill, finalTotalBill

            netPriceBill: billing.getNetPrice, // subtotal - totalDiscount
            taxableAmountBill: billing.getTaxableAmount,
            gstAmountBill: billing.getGstAmount,
            finalTotalBill: billing.getFinalTotal,

            transactionId: _transactionIdController.text.trim().isNotEmpty
                ? _transactionIdController.text.trim()
                : "00",

            appointmentInfo: widget.appointModel!.appointmentInfo!
                .copyWith(status: GlobalVariable.billGenerateAppointState),
            payment:
                _selectedPaymentMethod == "QR" ? "UPI" : _selectedPaymentMethod,
            timeStampList: _timeStampList,
          );

// Update Appointment Payment information
          // AppointModel _updataAppointModel = widget.appointModel!.copyWith(
          //   extraDiscountInPer: _extraDiscountInPerLocal ?? 0.0,
          //   extraDiscountInPerAMT: billingProvider.getTotalDiscount,
          //   extraDiscountInAmount: _extraDiscountInAmountLocal ?? 0.0,
          //   transactionId: _transactionIdController.text.trim().isNotEmpty
          //       ? _transactionIdController.text.trim()
          //       : "00",
          //   gstAmountBill: _settingModel!.gstNo.length == 15
          //       ? _bookingProvider.gstAmountBill
          //       : 0.0,
          //   finalTotalBill: _bookingProvider.getFinalTotalBill,
          //   netPriceBill: _bookingProvider.getNetPriceBill,
          //   appointmentInfo: widget.appointModel!.appointmentInfo!
          //       .copyWith(status: GlobalVariable.billGenerateAppointState),
          //   payment:
          //       _selectedPaymentMethod == "QR" ? "UPI" : _selectedPaymentMethod,
          //   timeStampList: _timeStampList,
          // );
          print(
              "Extra Discount in update %: ${_updataAppointModel.extraDiscountInPer}");

          bool _isUpdate = await _bookingProvider.updateAppointment(
            widget.appointModel!.userModel.id,
            widget.appointModel!.orderId,
            _updataAppointModel,
          );

          Navigator.pop(context);
          print(
              "salon Id ${widget.appointModel!.vendorId}   ,${appProvider.getSalonInformation.id}");
          print(
              "map length is ${appProvider.getProductListWithQty}---------------------------------------------------------------------");
          print(
              "getProductListFetchID length is ${appProvider.getProductListFetchID.length}---------------------------------------------------------------------");

          if (_isUpdate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BillPdfPage(
                  appointModel: _updataAppointModel,
                  salonModel: _salonModel,
                  settingModel: _settingModel!,
                  vendorLogo: _salonModel.logImage,
                  serviceList: appProvider.getServiceListFetchID,
                  productList: appProvider.getProductListWithQty,
                ),
              ),
            );
            showMessage("Successfully billing an appointment");
          }
        },
      );
}
