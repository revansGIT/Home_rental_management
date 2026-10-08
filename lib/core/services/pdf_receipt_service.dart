import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/payment_model.dart';
import '../models/rent_invoice_model.dart';
import '../models/tenant_model.dart';
import '../models/property_model.dart';
import '../models/unit_model.dart';

class PdfReceiptService {
  static Future<void> generateAndShareReceipt({
    required PaymentModel payment,
    required RentInvoiceModel invoice,
    required TenantModel tenant,
    required PropertyModel property,
    required UnitModel unit,
  }) async {
    final pdf = pw.Document();

    final dateFormatter = DateFormat('dd MMM yyyy');
    final monthFormatter = DateFormat('MMMM yyyy');
    final currencyFormatter = NumberFormat.currency(symbol: '৳', decimalDigits: 0);

    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'HOME RENTAL MANAGEMENT',
                    style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.blue900),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                    'Rent Payment Receipt',
                    style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.grey700),
                  ),
                ),
                pw.Divider(thickness: 2, height: 32),
                
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Tenant: ${tenant.name}', style: pw.TextStyle(font: font, fontSize: 14)),
                          pw.Text('Property: ${property.name}', style: pw.TextStyle(font: font, fontSize: 14)),
                          pw.Text('Unit: ${unit.unitNumber}', style: pw.TextStyle(font: font, fontSize: 14)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('Rent Month: ${monthFormatter.format(invoice.monthYear)}', style: pw.TextStyle(font: font, fontSize: 14)),
                          pw.Text('Receipt #: RCPT-${DateFormat('yyyyMMdd').format(payment.date)}-${payment.id.substring(0, 4)}', style: pw.TextStyle(font: font, fontSize: 14)),
                          pw.Text('Date: ${dateFormatter.format(payment.date)}', style: pw.TextStyle(font: font, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 32),
                
                // Invoice Details Table
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey400),
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Description', style: pw.TextStyle(font: fontBold))),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Amount', textAlign: pw.TextAlign.right, style: pw.TextStyle(font: fontBold))),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Monthly Rent', style: pw.TextStyle(font: font))),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(currencyFormatter.format(invoice.baseRent), textAlign: pw.TextAlign.right, style: pw.TextStyle(font: font))),
                      ],
                    ),
                    if (invoice.serviceCharge > 0)
                      pw.TableRow(
                        children: [
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Service Charge', style: pw.TextStyle(font: font))),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(currencyFormatter.format(invoice.serviceCharge), textAlign: pw.TextAlign.right, style: pw.TextStyle(font: font))),
                        ],
                      ),
                    if (invoice.previousBalance > 0)
                      pw.TableRow(
                        children: [
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Previous Due', style: pw.TextStyle(font: font))),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(currencyFormatter.format(invoice.previousBalance), textAlign: pw.TextAlign.right, style: pw.TextStyle(font: font))),
                        ],
                      ),
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Total Due', style: pw.TextStyle(font: fontBold))),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(currencyFormatter.format(invoice.totalDue), textAlign: pw.TextAlign.right, style: pw.TextStyle(font: fontBold))),
                      ],
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 24),
                
                // Payment Summary
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Paid: ${currencyFormatter.format(payment.amount)}', style: pw.TextStyle(font: fontBold, fontSize: 16, color: PdfColors.green800)),
                        pw.SizedBox(height: 4),
                        pw.Text('Remaining: ${currencyFormatter.format(invoice.remainingBalance)}', style: pw.TextStyle(font: fontBold, fontSize: 14, color: invoice.remainingBalance > 0 ? PdfColors.red800 : PdfColors.grey800)),
                      ],
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 32),
                pw.Text('Payment Method: Cash/Bank', style: pw.TextStyle(font: font, fontSize: 14)),
                
                pw.Spacer(),
                pw.Divider(),
                pw.Center(
                  child: pw.Text('Thank you for your payment!', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey600)),
                ),
              ],
            ),
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Receipt_RCPT_${DateFormat('yyyyMMdd').format(payment.date)}_${payment.id.substring(0, 4)}.pdf',
    );
  }
}
