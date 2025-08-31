// updated_bill_pdf_page.dart
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/home/screen/loading_home_page/loading_home_page.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/setting_provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as Math;
import 'package:url_launcher/url_launcher.dart';

class BillPdfPage extends StatelessWidget {
  final AppointModel appointModel;
  final SalonModel salonModel;
  final SettingModel settingModel;
  final String? vendorLogo;
  // Accept flexible productList: callers can pass Map<ProductModel,int> or Map<List<ProductModel>,int>
  final Map<dynamic, int> productList;
  final List<ServiceModel> serviceList;

  const BillPdfPage({
    super.key,
    required this.appointModel,
    required this.salonModel,
    required this.settingModel,
    this.vendorLogo,
    required this.productList,
    required this.serviceList,
  });

  Future<pw.Font> _loadCustomFont() async {
    try {
      final ByteData fontData =
          await rootBundle.load('assets/fonts/Roboto.ttf');
      return pw.Font.ttf(fontData);
    } catch (e) {
      debugPrint("Error loading custom font: $e");
      return pw.Font.helvetica();
    }
  }

  Future<pw.MemoryImage> _loadLogoImage() async {
    try {
      final String logUri = GlobalVariable.samayLogo;
      final ByteData logoBytes = await rootBundle.load(logUri);
      return pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (e) {
      debugPrint("Error loading logo image: $e");
      rethrow;
    }
  }

  Future<pw.MemoryImage?> _loadVendorLogoImage() async {
    try {
      if (vendorLogo == null || vendorLogo!.isEmpty) return null;

      if (vendorLogo!.startsWith('http')) {
        final response = await http.get(Uri.parse(vendorLogo!));
        if (response.statusCode == 200) {
          return pw.MemoryImage(response.bodyBytes);
        } else {
          debugPrint(
              'Vendor logo network request failed: ${response.statusCode}');
          return null;
        }
      } else {
        final ByteData vendorBytes = await rootBundle.load(vendorLogo!);
        return pw.MemoryImage(vendorBytes.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint("Error loading vendor logo image: $e");
      return null;
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final customFont = await _loadCustomFont();
    final logoImage = await _loadLogoImage();
    final vendorLogoImage = await _loadVendorLogoImage();

    final String taxAmt = (appointModel.gstAmountBill / 2).toStringAsFixed(2);
    final bool isTaxShow = (settingModel.gstNo.length >= 10);

    final serviceRows = <List<String>>[];
    for (int i = 0; i < serviceList.length; i++) {
      final s = serviceList[i];
      serviceRows.add([
        (i + 1).toString(),
        "Service",
        s.servicesName ?? '-',
        (s.originalPrice ?? 0.0).toStringAsFixed(2),
        "1",
        (s.originalPrice ?? 0.0).toStringAsFixed(2),
      ]);
    }

    final productRows = <List<String>>[];
    int prodIndex = 0;
    productList.forEach((product, qty) {
      if (product == null) return;
      prodIndex++;
      final String pname = product.name ?? '-';
      final double prate = (product.originalPrice ?? 0.0).toDouble();
      final double total = prate * (qty ?? 1);
      productRows.add([
        prodIndex.toString(),
        'Product',
        pname,
        prate.toStringAsFixed(2),
        qty.toString(),
        total.toStringAsFixed(2),
      ]);
    });

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(12), // Set margin to 12 on all sides
        pageFormat: format,
        build: (pw.Context context) => [
          _buildTopLogo(logoImage, customFont),
          pw.SizedBox(height: Dimensions.dimensionNo8),
          // _buildInvoiceTitle(customFont),
          pw.SizedBox(height: Dimensions.dimensionNo16),
          _buildHeaderSection(vendorLogoImage, customFont),
          pw.SizedBox(height: Dimensions.dimensionNo16),
          pw.Divider(),
          _buildClientInvoiceDetails(customFont),
          pw.SizedBox(height: Dimensions.dimensionNo16),
          _buildServiceTable(serviceRows, productRows, customFont),
          pw.SizedBox(height: Dimensions.dimensionNo16),
          _buildTaxAndTotalsSection(taxAmt, customFont, isTaxShow),
          pw.SizedBox(height: Dimensions.dimensionNo50),
          _buildFooter(customFont),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildTopLogo(pw.MemoryImage? logoImage, pw.Font customFont) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (logoImage != null)
          pw.Container(
            width: Dimensions.dimensionNo40,
            height: Dimensions.dimensionNo40,
            child: pw.Image(logoImage, fit: pw.BoxFit.cover),
          ),
        pw.SizedBox(width: Dimensions.dimensionNo8),
        pw.Expanded(
          child: pw.Center(
            child: pw.Text(
              "INVOICE",
              style: pw.TextStyle(
                fontSize: Dimensions.dimensionNo24,
                fontWeight: pw.FontWeight.bold,
                font: customFont,
              ),
            ),
          ),
        ),
        pw.SizedBox(width: Dimensions.dimensionNo8),
        pw.SizedBox(
          width: Dimensions.dimensionNo40,
          height: Dimensions.dimensionNo40,
        )
      ],
    );
  }



  pw.Widget _buildHeaderSection(
      pw.MemoryImage? vendorLogoImage, pw.Font customFont) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        if (vendorLogoImage != null)
          pw.Column(
            children: [
              pw.Container(
                width: Dimensions.dimensionNo40,
                height: Dimensions.dimensionNo40,
                child: pw.ClipOval(
                    child: pw.Image(vendorLogoImage, fit: pw.BoxFit.cover)),
              ),
              pw.SizedBox(height: Dimensions.dimensionNo8),
              pw.Text(
                "Power by Samay",
                style: pw.TextStyle(
                    fontSize: Dimensions.dimensionNo5, font: customFont),
              ),
            ],
          ),
        pw.SizedBox(
          width: Dimensions.dimensionNo200,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                salonModel.name ?? '-',
                style: pw.TextStyle(
                    fontSize: Dimensions.dimensionNo16,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont),
              ),
              pw.Text(
                "${salonModel.address ?? ''}${salonModel.city ?? ''} - ${salonModel.pinCode ?? ''}",
                style: pw.TextStyle(
                    fontSize: Dimensions.dimensionNo8, font: customFont),
              ),
              if (settingModel.gstNo.length >= 10)
                pw.Text("GSTIN: ${settingModel.gstNo}",
                    style: pw.TextStyle(
                        fontSize: Dimensions.dimensionNo8, font: customFont)),
              pw.Text("Contact No: ${salonModel.number ?? '-'}",
                  style: pw.TextStyle(
                      fontSize: Dimensions.dimensionNo8, font: customFont)),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildClientInvoiceDetails(pw.Font customFont) {
    final user = appointModel.userModel;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Client : ${user?.name ?? '-'}",
                style: pw.TextStyle(
                    fontSize: Dimensions.dimensionNo8,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont)),
            pw.Text("Mobile : ${user?.phone ?? '-'}",
                style: pw.TextStyle(
                    fontSize: Dimensions.dimensionNo8,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text("Invoice No: ${appointModel.orderId ?? '-'}",
                style: pw.TextStyle(
                    fontSize: Dimensions.dimensionNo8,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont)),
            pw.Text(
                "Date: ${GlobalVariable.getCurrentDate()} ${GlobalVariable.getCurrentTime()}",
                style: pw.TextStyle(
                    fontSize: Dimensions.dimensionNo8,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildServiceTable(
    List<List<String>> serviceRows,
    List<List<String>> productsRows,
    pw.Font customFont,
  ) {
    final List<List<String>> data = [...serviceRows, ...productsRows];
    return pw.TableHelper.fromTextArray(
      headers: ['No', 'TYPE', 'NAME', 'RATE', 'QTY', 'PRICE'],
      data: data,
      headerStyle: pw.TextStyle(
          fontSize: Dimensions.dimensionNo10,
          fontWeight: pw.FontWeight.bold,
          font: customFont),
      cellStyle:
          pw.TextStyle(fontSize: Dimensions.dimensionNo10, font: customFont),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
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

    // safe accessors for numbers, fallback to 0.0
    double subTotal = appointModel.subTotalBill ?? 0.0;
    double discount = appointModel.discountBill ?? 0.0;
    double gstAmountBill = appointModel.gstAmountBill ?? 0.0;
    double extraFlat = appointModel.extraDiscountInAmount ?? 0.0;
    double extraPerAmt = appointModel.extraDiscountInPerAMT ?? 0.0;
    double netPrice = appointModel.netPriceBill ?? 0.0;
    double platformFee = appointModel.platformFeeBill ?? 0.0;
    double finalTotal = appointModel.finalTotalBill ?? 0.0;

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
                        child: pw.Text("TAX SUMMARY",
                            style: pw.TextStyle(
                                fontSize: Dimensions.dimensionNo10,
                                fontWeight: pw.FontWeight.bold,
                                font: customFont))),
                    pw.TableHelper.fromTextArray(
                      headers: ["TAX DESC", "TAX %", "TAXABLE AMT", "TAX AMT"],
                      data: [
                        [
                          "SGST",
                          "9",
                          "₹${(subTotal - discount - gstAmountBill - extraFlat).toStringAsFixed(2)}",
                          "₹$taxAmt"
                        ],
                        [
                          "CGST",
                          "9",
                          "₹${(subTotal - discount - gstAmountBill - extraFlat).toStringAsFixed(2)}",
                          "₹$taxAmt"
                        ],
                      ],
                      headerStyle: pw.TextStyle(
                          fontSize: Dimensions.dimensionNo10,
                          fontWeight: pw.FontWeight.bold,
                          font: customFont),
                      cellStyle: pw.TextStyle(
                          fontSize: Dimensions.dimensionNo10, font: customFont),
                      headerDecoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
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
              _buildKeyValueRow(
                  "SUBTOTAL", "₹${subTotal.toStringAsFixed(2)}", customFont),
              if (discount != 0.0)
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(
                        vertical: Dimensions.dimensionNo5),
                    child: _buildKeyValueRow("ITEM DISCOUNT",
                        "-₹${discount.toStringAsFixed(2)}", customFont)),
              if (appointModel.extraDiscountInPer != null &&
                  appointModel.extraDiscountInPer != 0.0)
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(
                        vertical: Dimensions.dimensionNo5),
                    child: _buildKeyValueRow(
                        "EXTRA DISCOUNT  ${appointModel.extraDiscountInPer ?? 0} %",
                        "-₹${extraPerAmt.toStringAsFixed(2)}",
                        customFont)),
              if (hasFlat)
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(
                        vertical: Dimensions.dimensionNo5),
                    child: _buildKeyValueRow("Flat",
                        "-₹${extraFlat.toStringAsFixed(2)}", customFont)),
              pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                      vertical: Dimensions.dimensionNo5),
                  child: _buildKeyValueRow(
                      "NET", "₹${netPrice.toStringAsFixed(2)}", customFont)),
              if (platformFee != 0.0)
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(
                        vertical: Dimensions.dimensionNo5),
                    child: _buildKeyValueRow("PLATFORM FEES",
                        "₹${platformFee.toStringAsFixed(2)}", customFont)),
              pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                      vertical: Dimensions.dimensionNo5),
                  child: _buildKeyValueRow("GRAND",
                      "₹${finalTotal.toStringAsFixed(2)}", customFont)),
              pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                      vertical: Dimensions.dimensionNo5),
                  child: _buildKeyValueRow("TOTAL PAID",
                      "₹${finalTotal.toStringAsFixed(2)}", customFont)),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildKeyValueRow(String key, String value, pw.Font customFont) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(key,
              style: pw.TextStyle(
                  fontSize: Dimensions.dimensionNo10, font: customFont)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: Dimensions.dimensionNo10, font: customFont)),
        ]);
  }

  pw.Widget _buildFooter(pw.Font customFont) {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text("visit again !",
              style: pw.TextStyle(
                  fontSize: Dimensions.dimensionNo16,
                  color: PdfColors.grey,
                  font: customFont)),
          pw.SizedBox(height: Dimensions.dimensionNo8),
          pw.Text("Main hu Samay, mere Sath chalo.!",
              style: pw.TextStyle(
                  fontSize: Dimensions.dimensionNo16, font: customFont)),
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
                SettingProvider settingProvider =
                    Provider.of<SettingProvider>(context, listen: false);

                // message and phone
                String message = settingProvider
                        .getMessageModel?.wMasForbillPFD ??
                    "Thank you for using the Samay service. Please visit us again!";
                final String userPhone = appointModel.userModel?.phone ?? '';
                if (userPhone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('User phone number is not available.')));
                  return;
                }
                final String number = "${GlobalVariable.indiaCode}$userPhone";

                // Generate the PDF bytes
                final pdfBytes = await _generatePdf(PdfPageFormat.a6);

                // Use Printing.sharePdf to share across platforms (web/mobile/desktop).
                await Printing.sharePdf(
                    bytes: pdfBytes,
                    filename:
                        'invoice_${appointModel.orderId ?? 'invoice'}.pdf');

                // Launch WhatsApp (universal wa.me link)
                final whatsappUrl = Uri.parse(
                    'https://wa.me/$number?text=${Uri.encodeComponent(message)}');
                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Could not launch WhatsApp.')));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error sharing invoice: $e")));
                debugPrint("Error sharing invoice: $e");
              }
            },
            icon: FaIcon(FontAwesomeIcons.whatsapp,
                size: Dimensions.dimensionNo24, color: Colors.white),
          ),
        )
      ],
      leading: IconButton(
        onPressed: () {
          Routes.instance.pushAndRemoveUntil(
              widget: const LoadingHomePage(), context: context);
        },
        icon: Icon(Icons.home,
            color: Colors.white, size: Dimensions.dimensionNo24),
      ),
      title: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("INVOICE ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.dimensionNo18,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: Dimensions.dimensionNo8),
              Text("Power by Samay",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.dimensionNo12,
                      fontWeight: FontWeight.w400)),
            ]),
      ),
    );
  }
}
