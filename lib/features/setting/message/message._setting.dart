// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/setting/widget/heading_text_of_page.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/models/message_model/message_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/setting_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class SettingMessagePage extends StatefulWidget {
  const SettingMessagePage({super.key});

  @override
  State<SettingMessagePage> createState() => _SettingMessagePageState();
}

class _SettingMessagePageState extends State<SettingMessagePage> {
  final TextEditingController _wMesPDFBillController = TextEditingController();

  bool _isLoading = false;
  bool _isUpdate = false;
  MessageModel? _messageModel;

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
          .fetchMessagesDetailsPro(appProvider.getSalonInformation.id);

      _messageModel = settingProvider.getMessageModel;

      if (_messageModel != null && _messageModel!.wMasForbillPFD != null) {
        _wMesPDFBillController.text = _messageModel!.wMasForbillPFD!;
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      showBottomMessageError("Failed to load messages.", context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _wMesPDFBillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final settingProvider = Provider.of<SettingProvider>(context);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: AppColor.bgForAdminCreateSec,
              child: Center(
                child: Container(
                  margin: ResponsiveLayout.isMobile(context)
                      ? EdgeInsets.symmetric(
                          horizontal: Dimensions.dimensionNo12,
                        )
                      : ResponsiveLayout.isTablet(context)
                          ? EdgeInsets.symmetric(
                              horizontal: Dimensions.dimensionNo60,
                            )
                          : null,
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimensionNo10
                          : Dimensions.dimensionNo30,
                      vertical: Dimensions.dimensionNo20),
                  // color: Colors.green,
                  color: Colors.white,
                  width: ResponsiveLayout.isDesktop(context)
                      ? Dimensions.screenWidth / 1.5
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: headingTextOFPage(
                          context,
                          'Messages Details',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimensionNo10),
                        child: const Divider(),
                      ),
                      const SizedBox(height: 20),
                      FormCustomTextField(
                        controller: _wMesPDFBillController,
                        title:
                            "Enter the WhatsApp message to send when the bill PDF is sent.",
                        hintText: "Bill PDF message",
                        requiredField: false,
                      ),
                      const SizedBox(height: 50),
                      CustomAuthButton(
                        text: (_messageModel?.id.isNotEmpty ?? false)
                            ? "Update"
                            : "Save",
                        ontap: () async {
                          try {
                            final salonId = appProvider.getSalonInformation.id;
                            if (salonId.isEmpty) {
                              showBottomMessageError(
                                  "Salon ID is missing.", context);
                              return;
                            }

                            if (_messageModel != null &&
                                _messageModel!.id.isNotEmpty) {
                              showLoaderDialog(context);

                              final updatedMessageModel =
                                  _messageModel!.copyWith(
                                wMasForbillPFD:
                                    _wMesPDFBillController.text.trim(),
                              );

                              _isUpdate = await settingProvider
                                  .updateMessagesDetailsPro(
                                salonId,
                                _messageModel!.id,
                                updatedMessageModel,
                              );

                              Navigator.pop(context);

                              if (_isUpdate) {
                                showBottomMessage(
                                    "Messages updated successfully.", context);
                              } else {
                                showBottomMessageError(
                                    "Failed to update messages.", context);
                              }
                            } else {
                              showLoaderDialog(context);

                              await SettingFb.instance.saveMessagestFB(
                                salonId,
                                _wMesPDFBillController.text.trim(),
                                context,
                              );

                              Navigator.pop(context);

                              showBottomMessage(
                                  "Messages saved successfully.", context);
                            }
                          } catch (e) {
                            showBottomMessageError(
                                "Failed to update message: $e", context);
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
