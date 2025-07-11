import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/features/home/screen/loading_home_page/loading_home_page.dart';
import 'package:samay_admin_plan/provider/setting_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:http/http.dart' as http;

class BillPdfPage extends StatelessWidget {
  final AppointModel appointModel;
  final SalonModel salonModel;
  final SettingModel settingModel;
  final String? vendorLogo;

  const BillPdfPage({
    super.key,
    required this.appointModel,
    required this.salonModel,
    required this.settingModel,
    this.vendorLogo,
  });

  Future<pw.Font> _loadCustomFont() async {
    try {
      final fontData = await rootBundle.load('assets/fonts/Roboto.ttf');
      return pw.Font.ttf(fontData);
    } catch (e) {
      print("Error loading custom font: $e");
      return pw.Font.helvetica();
    }
  }

  Future<pw.MemoryImage> _loadLogoImage() async {
    try {
      final String logUri = GlobalVariable.samayLogo;
      final logoBytes = await rootBundle.load(logUri);
      print('Logo loaded: ${logoBytes.lengthInBytes} bytes');
      return pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (e) {
      print("Error loading logo image: $e");
      throw Exception("Logo image could not be loaded.");
    }
  }

  Future<pw.MemoryImage?> _loadVendorLogoImage() async {
    try {
      if (vendorLogo == null || vendorLogo!.isEmpty) {
        return null;
      }
      if (vendorLogo!.startsWith('http')) {
        final response = await http.get(Uri.parse(vendorLogo!));
        if (response.statusCode == 200) {
          return pw.MemoryImage(response.bodyBytes);
        } else {
          return null;
        }
      } else {
        final logoVendorBytes = await rootBundle.load(vendorLogo!);
        return pw.MemoryImage(logoVendorBytes.buffer.asUint8List());
      }
    } catch (e) {
      print("Error loading vendor logo image: $e");
      return null;
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    try {
      final customFont = await _loadCustomFont();
      final logoImage = await _loadLogoImage();
      final vendorLogoImage = await _loadVendorLogoImage();
      final String taxAmt = (appointModel.gstAmount / 2).toStringAsFixed(2);
      final bool isTaxShow =
          (settingModel.gstNo != null && settingModel.gstNo.length >= 10);

      final serviceRows = appointModel.services.map((service) {
        return [
          '${appointModel.services.indexOf(service) + 1}',
          "service",
          service.servicesName,
          service.originalPrice.toString(),
          "1",
          service.price.toStringAsFixed(2),
        ];
      }).toList();

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Padding(
              padding: pw.EdgeInsets.all(Dimensions.dimensionNo8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildTopLogo(logoImage, customFont),
                      _buildInvoiceTitle(customFont),
                      pw.SizedBox(height: Dimensions.dimensionNo16),
                      _buildHeaderSection(vendorLogoImage, customFont),
                      pw.SizedBox(height: Dimensions.dimensionNo16),
                      pw.Divider(),
                      _buildClientInvoiceDetails(customFont),
                      pw.SizedBox(height: Dimensions.dimensionNo16),
                      _buildServiceTable(serviceRows, customFont),
                      pw.SizedBox(height: Dimensions.dimensionNo16),
                      _buildTaxAndTotalsSection(taxAmt, customFont, isTaxShow),
                      pw.SizedBox(height: Dimensions.dimensionNo50),
                      _buildFooter(customFont),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
      return pdf.save();
    } catch (e) {
      print("Error generating PDF: $e");
      rethrow;
    }
  }

  pw.Widget _buildTopLogo(pw.MemoryImage? logoImage, pw.Font customFont) {
    return pw.Column(
      children: [
        pw.Container(
          alignment: pw.Alignment.topLeft,
          decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(Dimensions.dimensionNo18)),
          width: Dimensions.dimensionNo40,
          height: Dimensions.dimensionNo40,
          child: pw.Image(logoImage!, fit: pw.BoxFit.cover),
        ),
        pw.Text(
          "Power by Samay",
          style: pw.TextStyle(
            fontSize: Dimensions.dimensionNo5,
            font: customFont,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildInvoiceTitle(pw.Font customFont) {
    return pw.Center(
      child: pw.Text(
        "INVOICE",
        style: pw.TextStyle(
          fontSize: Dimensions.dimensionNo24,
          fontWeight: pw.FontWeight.bold,
          font: customFont,
        ),
      ),
    );
  }

  pw.Widget _buildHeaderSection(
      pw.MemoryImage? vendorLogoImage, pw.Font customFont) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        vendorLogoImage != null
            ? pw.Column(
                children: [
                  pw.Container(
                    width: Dimensions.dimensionNo40,
                    height: Dimensions.dimensionNo40,
                    child: pw.ClipOval(
                      child: pw.Image(vendorLogoImage, fit: pw.BoxFit.cover),
                    ),
                  ),
                  pw.Text(
                    "Power by Samay",
                    style: pw.TextStyle(
                      fontSize: Dimensions.dimensionNo5,
                      font: customFont,
                    ),
                  ),
                ],
              )
            : pw.SizedBox(),
        pw.SizedBox(
          width: Dimensions.dimensionNo200,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                salonModel.name,
                style: pw.TextStyle(
                  fontSize: Dimensions.dimensionNo16,
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                ),
              ),
              pw.Text(
                "${salonModel.address}\n${salonModel.city} - ${salonModel.pinCode}",
                style: pw.TextStyle(
                  fontSize: Dimensions.dimensionNo8,
                  font: customFont,
                ),
              ),
              (settingModel.gstNo != null && settingModel.gstNo.length >= 10)
                  ? pw.Text(
                      "GSTIN: ${settingModel.gstNo}",
                      style: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo8,
                        font: customFont,
                      ),
                    )
                  : pw.SizedBox(),
              pw.Text(
                "Contact No: ${salonModel.number}",
                style: pw.TextStyle(
                  fontSize: Dimensions.dimensionNo8,
                  font: customFont,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildClientInvoiceDetails(pw.Font customFont) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Client : ${appointModel.userModel.name}",
              style: pw.TextStyle(
                fontSize: Dimensions.dimensionNo8,
                fontWeight: pw.FontWeight.bold,
                font: customFont,
              ),
            ),
            pw.Text(
              "Mobile : ${appointModel.userModel.phone}",
              style: pw.TextStyle(
                fontSize: Dimensions.dimensionNo8,
                fontWeight: pw.FontWeight.bold,
                font: customFont,
              ),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              "Invoice No: ${appointModel.orderId}",
              style: pw.TextStyle(
                fontSize: Dimensions.dimensionNo8,
                fontWeight: pw.FontWeight.bold,
                font: customFont,
              ),
            ),
            pw.Text(
              "Date: ${GlobalVariable.getCurrentDate()} ${GlobalVariable.getCurrentTime()}",
              style: pw.TextStyle(
                fontSize: Dimensions.dimensionNo8,
                fontWeight: pw.FontWeight.bold,
                font: customFont,
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildServiceTable(
      List<List<String>> serviceRows, pw.Font customFont) {
    return pw.TableHelper.fromTextArray(
      headers: ['No', 'TYPE', 'NAME', 'RATE', 'QTY', 'PRICE'],
      data: serviceRows,
      headerStyle: pw.TextStyle(
        fontSize: Dimensions.dimensionNo10,
        fontWeight: pw.FontWeight.bold,
        font: customFont,
      ),
      cellStyle: pw.TextStyle(
        fontSize: Dimensions.dimensionNo10,
        font: customFont,
      ),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }

  pw.Widget _buildTaxAndTotalsSection(
      String taxAmt, pw.Font customFont, bool isTaxShow) {
    final bool hasFlat = (appointModel.extraDiscountInAmount != null &&
        appointModel.extraDiscountInAmount != 0.0);
    final bool hasPer = (appointModel.extraDiscountInPerAMT != null &&
        appointModel.extraDiscountInPerAMT != 0.0);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          flex: 1,
          child: isTaxShow
              ? pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "TAX SUMMARY",
                        style: pw.TextStyle(
                          fontSize: Dimensions.dimensionNo10,
                          fontWeight: pw.FontWeight.bold,
                          font: customFont,
                        ),
                      ),
                    ),
                    pw.TableHelper.fromTextArray(
                      headers: ["TAX DESC", "TAX %", "TAXABLE AMT", "TAX AMT"],
                      data: [
                        [
                          "SGST",
                          "9",
                          "₹${(appointModel.subtatal - (appointModel.discountAmount ?? 0) - appointModel.gstAmount - (appointModel.extraDiscountInAmount ?? 0)).toStringAsFixed(2)}",
                          "₹$taxAmt"
                        ],
                        [
                          "CGST",
                          "9",
                          "₹${(appointModel.subtatal - (appointModel.discountAmount ?? 0) - appointModel.gstAmount - (appointModel.extraDiscountInAmount ?? 0)).toStringAsFixed(2)}",
                          "₹$taxAmt"
                        ],
                      ],
                      headerStyle: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo10,
                        fontWeight: pw.FontWeight.bold,
                        font: customFont,
                      ),
                      cellStyle: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo10,
                        font: customFont,
                      ),
                      headerDecoration:
                          pw.BoxDecoration(color: PdfColors.grey300),
                    ),
                  ],
                )
              : pw.SizedBox(),
        ),
        pw.SizedBox(width: Dimensions.dimensionNo30),
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: Dimensions.dimensionNo12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("SUBTOTAL",
                      style: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo10,
                        font: customFont,
                      )),
                  pw.Text("₹${appointModel.subtatal.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo10,
                        font: customFont,
                      )),
                ],
              ),
              (appointModel.discountInPer != null &&
                      appointModel.discountInPer != 0.0)
                  ? pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          vertical: Dimensions.dimensionNo5),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                              "ITEM DISCOUNT ${appointModel.discountInPer!.round().toString()}%",
                              style: pw.TextStyle(
                                fontSize: Dimensions.dimensionNo10,
                                font: customFont,
                              )),
                          pw.Text(
                              "-₹${appointModel.discountAmount?.toStringAsFixed(2) ?? '0.00'}",
                              style: pw.TextStyle(
                                fontSize: Dimensions.dimensionNo10,
                                font: customFont,
                              )),
                        ],
                      ),
                    )
                  : pw.SizedBox(),
              (appointModel.extraDiscountInPer != null &&
                      appointModel.extraDiscountInPer != 0.0)
                  ? pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          vertical: Dimensions.dimensionNo5),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "EXTRA DISCOUNT ${appointModel.extraDiscountInPer ?? 0} %",
                            style: pw.TextStyle(
                              fontSize: Dimensions.dimensionNo10,
                              font: customFont,
                            ),
                          ),
                          pw.Text(
                            "-₹${((appointModel.extraDiscountInPerAMT ?? 0.0).toStringAsFixed(2))}",
                            style: pw.TextStyle(
                              fontSize: Dimensions.dimensionNo10,
                              font: customFont,
                            ),
                          ),
                        ],
                      ),
                    )
                  : pw.SizedBox(),
              (appointModel.extraDiscountInAmount != null &&
                      appointModel.extraDiscountInAmount != 0.0)
                  ? pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          vertical: Dimensions.dimensionNo5),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Flat",
                              style: pw.TextStyle(
                                fontSize: Dimensions.dimensionNo10,
                                font: customFont,
                              )),
                          pw.Text(
                              "-₹${appointModel.extraDiscountInAmount?.toStringAsFixed(2) ?? '0.00'}",
                              style: pw.TextStyle(
                                fontSize: Dimensions.dimensionNo10,
                                font: customFont,
                              )),
                        ],
                      ),
                    )
                  : pw.SizedBox(),
              pw.Padding(
                padding:
                    pw.EdgeInsets.symmetric(vertical: Dimensions.dimensionNo5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("NET",
                        style: pw.TextStyle(
                          fontSize: Dimensions.dimensionNo10,
                          font: customFont,
                        )),
                    pw.Text(
                      "₹${appointModel.netPrice.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo10,
                        font: customFont,
                      ),
                    )
                  ],
                ),
              ),
              (appointModel.platformFees != null ||
                      appointModel.subtatal != 0.0)
                  ? pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          vertical: Dimensions.dimensionNo5),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("PLATFORM FEES",
                              style: pw.TextStyle(
                                fontSize: Dimensions.dimensionNo10,
                                font: customFont,
                              )),
                          pw.Text(
                            "₹${appointModel.platformFees.toStringAsFixed(2)}",
                            style: pw.TextStyle(
                              fontSize: Dimensions.dimensionNo10,
                              font: customFont,
                            ),
                          )
                        ],
                      ),
                    )
                  : pw.SizedBox(),
              pw.Padding(
                padding:
                    pw.EdgeInsets.symmetric(vertical: Dimensions.dimensionNo5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("GRAND",
                        style: pw.TextStyle(
                          fontSize: Dimensions.dimensionNo10,
                          font: customFont,
                        )),
                    pw.Text(
                      "₹${appointModel.totalPrice.round().toString()}",
                      style: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo10,
                        font: customFont,
                      ),
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding:
                    pw.EdgeInsets.symmetric(vertical: Dimensions.dimensionNo5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("TOTAL PAID",
                        style: pw.TextStyle(
                          fontSize: Dimensions.dimensionNo10,
                          font: customFont,
                        )),
                    pw.Text(
                      "₹${appointModel.totalPrice.round().toString()}",
                      style: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo10,
                        font: customFont,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Font customFont) {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text("visit again !",
              style: pw.TextStyle(
                fontSize: Dimensions.dimensionNo16,
                color: PdfColors.grey,
                font: customFont,
              )),
          pw.SizedBox(height: Dimensions.dimensionNo8),
          pw.Text("Main hu Samay, mere Sath chalo.!",
              style: pw.TextStyle(
                fontSize: Dimensions.dimensionNo16,
                font: customFont,
              )),
        ],
      ),
    );
  }

  Future<Uint8List> _buildPdfAndReturnBytes(PdfPageFormat format) async {
    return await _generatePdf(format);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BillPaymentAppBar(context),
      body: PdfPreview(
        build: _buildPdfAndReturnBytes,
        allowPrinting: true,
        allowSharing: true,
        // canChangePageFormat: false,
        // initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }

  AppBar BillPaymentAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.mainColor,
      actions: [
        Container(
          margin: EdgeInsets.only(left: Dimensions.dimensionNo20),
          child: IconButton(
            onPressed: () async {
              try {
                SettingProvider _settingProvider =
                    Provider.of<SettingProvider>(context, listen: false);

                // Ensure message has a default value if null
                String message = _settingProvider
                        .getMessageModel?.wMasForbillPFD ??
                    "Thank you for using the Samay service. Please visit us again!";

                // Ensure number is not null
                final String? userPhone = appointModel.userModel.phone;
                if (userPhone == null || userPhone.isEmpty) {
                  showMessage("User phone number is not available.");
                  return;
                }
                final String number = "${GlobalVariable.indiaCode}$userPhone";

                // Generate the PDF
                final pdfBytes = await _generatePdf(PdfPageFormat.a4);

                if (kIsWeb) {
                  // Web platform: Use Printing.sharePdf and WhatsApp Web
                  await Printing.sharePdf(
                    bytes: pdfBytes,
                    filename:
                        'invoice_${appointModel.userModel.name} ${GlobalVariable.getCurrentDate()}.pdf',
                  );

                  // Launch WhatsApp Web with a pre-filled message
                  final whatsappUrl = Uri.parse(
                      'https://wa.me/$number/?text=${Uri.encodeComponent(message)}');
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl);
                  } else {
                    showMessage("WhatsApp not available.");
                  }
                } else if (Platform.isAndroid || Platform.isIOS) {
                  // Mobile platforms: Save and share the PDF
                  final directory = await getTemporaryDirectory();
                  final file = File(
                      '${directory.path}/invoice_${appointModel.orderId}.pdf');
                  await file.writeAsBytes(pdfBytes);

                  // Share the PDF file
                  await Share.shareXFiles([XFile(file.path)], text: message);

                  // Launch WhatsApp with a pre-filled message
                  final whatsappUrl = Uri.parse(
                      'whatsapp://send?phone=$number&text=${Uri.encodeComponent(message)}');
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl);
                  } else {
                    showMessage("WhatsApp not available.");
                  }
                } else if (Platform.isWindows ||
                    Platform.isMacOS ||
                    Platform.isLinux) {
                  // Desktop platforms: Save the PDF and open it
                  final directory = await getDownloadsDirectory();
                  final file = File(
                      '${directory?.path}/invoice_${appointModel.orderId}.pdf');
                  await file.writeAsBytes(pdfBytes);

                  // Open the PDF file
                  if (await file.exists()) {
                    await OpenFile.open(file.path);
                  }

                  // Launch WhatsApp Web with a pre-filled message
                  final whatsappUrl = Uri.parse(
                      'https://wa.me/$number/?text=${Uri.encodeComponent(message)}');
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl);
                  } else {
                    showMessage("WhatsApp not available.");
                  }
                }
              } catch (e) {
                showMessage("Error sharing invoice: $e");
                print("Error sharing invoice: $e");
              }
            },
            icon: FaIcon(
              FontAwesomeIcons.whatsapp,
              size: Dimensions.dimensionNo24,
              color: Colors.white,
            ),
          ),
        )
      ],
      leading: IconButton(
        onPressed: () {
          Routes.instance.pushAndRemoveUntil(
              widget: const LoadingHomePage(), context: context);
        },
        icon: Icon(
          Icons.home,
          color: Colors.white,
          size: Dimensions.dimensionNo24,
        ),
      ),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "INVOICE ",
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
}
