// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/setting/widget/heading_text_of_page.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/setting_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class PaymentSettingPage extends StatefulWidget {
  const PaymentSettingPage({super.key});

  @override
  State<PaymentSettingPage> createState() => _SettingPaymentPageState();
}

class _SettingPaymentPageState extends State<PaymentSettingPage> {
  final TextEditingController _upiControiller = TextEditingController();

  bool _isLoading = false;
  bool _isUpdate = false;
  late VenderPaymentDetailsModel? _venderPaymentDetailsModel;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final settingProvider =
          Provider.of<SettingProvider>(context, listen: false);

      await settingProvider
          .fetchVenderPaymentDetailsPro(appProvider.getSalonInformation.id);

      _venderPaymentDetailsModel = settingProvider.getVenderPaymentDetailsModel;

      if (_venderPaymentDetailsModel != null) {
        _upiControiller.text = _venderPaymentDetailsModel!.upiID;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _upiControiller.dispose();

    super.dispose();
  }

  bool validateFields() {
    final regex = RegExp(r'^[a-zA-Z0-9.-]+@[a-zA-Z]+$');

    if (_upiControiller.text.trim().isEmpty) {
      showBottonMessageError("UPI is required.", context);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    SettingProvider settingProvider = Provider.of<SettingProvider>(context);
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: AppColor.bgForAdminCreateSec,
              child: Center(
                child: Container(
                  margin: ResponsiveLayout.isMobile(context)
                      ? EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo12,
                        )
                      : ResponsiveLayout.isTablet(context)
                          ? EdgeInsets.symmetric(
                              horizontal: Dimensions.dimenisonNo60,
                            )
                          : null,
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimenisonNo10
                          : Dimensions.dimenisonNo30,
                      vertical: Dimensions.dimenisonNo20),
                  // color: Colors.green,
                  color: Colors.white,
                  width: ResponsiveLayout.isDesktop(context)
                      ? Dimensions.screenWidth / 1.5
                      : null,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: headingTextOFPage(context, 'Payment Details'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimenisonNo10),
                        child: const Divider(),
                      ),
                      const SizedBox(height: 20),
                      FormCustomTextField(
                        controller: _upiControiller,
                        title: "Enter you any UPI ID",
                        hintText: "UPI ID",
                        requiredField: false,
                      ),
                      const SizedBox(height: 50),
                      CustomAuthButton(
                        text:
                            (_venderPaymentDetailsModel?.id.isNotEmpty ?? false)
                                ? "Update"
                                : "Save",
                        ontap: () async {
                          try {
                            final salonId = appProvider.getSalonInformation.id;

                            if (_venderPaymentDetailsModel != null) {
                              // _isSaving = true;
                              showLoaderDialog(context);
                              final updateVenderPayment = settingProvider
                                  .getVenderPaymentDetailsModel!
                                  .copyWith(
                                upiID: _upiControiller.text.trim(),
                              );
                              _isUpdate = await settingProvider
                                  .UpdateVenderPaymentDetailsPro(
                                      salonId,
                                      _venderPaymentDetailsModel!.id,
                                      updateVenderPayment);
                              // _isSaving = false;
                              Navigator.pop(context);
                              if (_isUpdate) {
                                showBottonMessage(
                                    "Vender Payment Details updated successfully.",
                                    context);
                              } else {
                                showBottonMessageError(
                                    "Failed to update Payment Details.",
                                    context);
                              }
                            } else {
                              showLoaderDialog(context);

                              SettingFb.instance.saveVenderPaymentFB(salonId,
                                  _upiControiller.text.trim(), context);

                              Navigator.pop(context);
                            }

                            showBottonMessage(
                                "UPI save successfully.", context);
                          } catch (e) {
                            showBottonMessageError(
                                "Failed to save UPI: $e", context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
