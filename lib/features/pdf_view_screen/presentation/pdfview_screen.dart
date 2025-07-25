import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../main.dart';
import '../../../router/app_pages.dart';
import '../../estimation_screen/data/model/estimation_response_model.dart';
import '../../estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../../legal_entity_screen/presentation/bloc/legal_entity_bloc.dart';

class PdfviewScreen extends StatefulWidget {
  final EstimationResponseModel estimationResponseModel;

  const PdfviewScreen({super.key, required this.estimationResponseModel});

  @override
  State<PdfviewScreen> createState() => _PdfviewScreenState();
}

class _PdfviewScreenState extends State<PdfviewScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        // context.go(AppPages.ESTIMATION);
        context.go(AppPages.SEARCH_PRODUCT);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
          leading: BackButton(
            color: Colors.white,
            onPressed: () => context.go(AppPages.SEARCH_PRODUCT),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                context.read<EstimationBloc>().add(LogoutEvent());
                context.read<LegalEntityBloc>().add(ClearStateEvent());
                Future.delayed(Duration(milliseconds: 500), () {
                  if (mounted) {
                    context.go(
                      // AppPages.LOGIN,
                      AppPages.STORE_LIST,
                    );
                  }
                });
                /*context.go(
                    // AppPages.ESTIMATION,
                    AppPages.SEARCH_PRODUCT,
                  );*/
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                decoration: BoxDecoration(
                  color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 24,
                width: 24,
                child: Icon(Icons.home, color: Colors.white),
              ),
            ),
          ],
          centerTitle: true,
          title: const Text(
            "Print Layout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            // Adjust size based on orientation
            final adjustedSize =
                orientation == Orientation.portrait
                    ? size
                    : Size(
                      size.height,
                      size.width,
                    ); // Swap dimensions for landscape

            return SafeArea(
              child: PdfPreview(
                allowSharing: false,
                allowPrinting: true,
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                useActions: false,
                build: (format) => _createPdf(format, adjustedSize),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _printWithSunmi(),
          label: const Text('Print'),
          icon: const Icon(Icons.print),
          backgroundColor: AppColors.APP_BACKGROUND_COLOR, //Colors.blue,
        ),
      ),
    );
  }

  Future<void> _printWithSunmi() async {
    final pdfData = await _createPdf(
      PdfPageFormat.roll80,
      MediaQuery.of(context).size,
    );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfData,
        name: 'Estimation_Print_Copy',
        format: PdfPageFormat.roll80,
      );
  }

  Future<Uint8List> _createPdf(PdfPageFormat format, Size size) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

    for (int i = 0; i < 3; i++) {
      pdf.addPage(
        pw.Page(
          // pageFormat: PdfPageFormat.a4,
          // orientation: pw.PageOrientation.portrait,
          pageFormat: PdfPageFormat(
            size.width,
            AppDimensions.getResponsiveHeight(context),
            //(80 * (72.0 / 25.4)) // * 0.98
            marginAll: 5,
          ), // * (72.0 / 25.4)
          /*pageFormat: PdfPageFormat.roll80.copyWith(
          marginBottom: 10,
          marginTop: 10,
          marginLeft: 5,
          marginRight: 5,
        ),*/
          //pageFormat: format,
          build: (context) {
            return pw.SizedBox(
              width: size.width, //double.infinity,
              height: AppDimensions.getResponsiveHeight(
                navigatorKey.currentContext!,
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    "* SALES ADVICE *",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Container(
                    width: size.width,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      vertical:
                          AppDimensions.getResponsiveHeight(
                            navigatorKey.currentContext!,
                          ) *
                          0.02,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Container(
                    margin: pw.EdgeInsets.symmetric(
                      vertical:
                          AppDimensions.getResponsiveHeight(
                            navigatorKey.currentContext!,
                          ) *
                          0.03,
                    ),
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.code39(),
                      data:
                          "${widget.estimationResponseModel.data!.estimationEntry?.estnumber}",
                      // No need to add '*'
                      width: size.width * 0.9,
                      height:
                          AppDimensions.getResponsiveHeight(
                            navigatorKey.currentContext!,
                          ) *
                          0.15,
                      drawText: false, // Hides text
                    ),
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel.data!.estimationEntry?.estimateNo}",
                    "${widget.estimationResponseModel.data!.estimationEntry?.estnumber}",
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    width: size.width,
                    margin: pw.EdgeInsets.only(
                      top:
                          AppDimensions.getResponsiveHeight(
                            navigatorKey.currentContext!,
                          ) *
                          0.02,
                      bottom:
                          AppDimensions.getResponsiveHeight(
                            navigatorKey.currentContext!,
                          ) *
                          0.01,
                    ),
                    child: pw.Column(
                      children: List.generate(
                        widget
                            .estimationResponseModel
                            .data!
                            .estimateDetails!
                            .length,
                        (index) {
                          return pw.Container(
                            width: size.width,
                            margin: const pw.EdgeInsets.symmetric(vertical: 5),
                            child: _buildProductContainer(size, index),
                          );
                        },
                      ),
                    ),
                  ),
                  // pw.Spacer(),
                  pw.Text(
                    // "${widget.estimationResponseModel.data!.estimationEntry?.emplName}",
                    "${widget.estimationResponseModel.data!.estimateDetails![0].estimateProductDetails!.eMPLNAME}",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  pw.Widget _buildProductContainer(Size size, int index) {
    return pw.Column(
      children: [
        pw.Text(
          widget
              .estimationResponseModel
              .data!
              // .estimateDetails![index].estimateProductDetails!.productCode!,
              .estimateDetails![index]
              .estimateProductDetails!
              .prodCode!,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Container(
          width: size.width,
          height: 0.5,
          margin: pw.EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * 0.01,
          ),
          color: PdfColors.grey,
        ),
        pw.Text(
          widget
              .estimationResponseModel
              .data!
              .estimateDetails![index]
              .estimateProductDetails!
              .productName!,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Container(
          width: size.width,
          height: 0.5,
          margin: pw.EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * 0.02,
          ),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Pcs",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    "${widget.estimationResponseModel.data!.estimateDetails![index].estimateProductDetails!.pcs}",
                    style: const pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Nett",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    "${widget.estimationResponseModel.data!.estimateDetails![index].estimateProductDetails!.nett}",
                    style: const pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "MK Rate",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel.data!.estimateDetails![index].estimateProductDetails!.makingRate}",
                    "${widget.estimationResponseModel.data!.estimateDetails![index].estimateProductDetails!.mkrate}",
                    style: const pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Value",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    //width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel.data!.estimateDetails![index].estimateProductDetails!.lineAmount}",
                    "${widget.estimationResponseModel.data!.estimateDetails![index].estimateProductDetails!.lineamount}",
                    style: const pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.Container(
          width: size.width,
          height: 0.5,
          margin: pw.EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * 0.008,
          ),
          color: PdfColors.grey,
        ),
      ],
    );
  }
}
