import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_status.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/local/shared_preferences_helper.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../router/app_pages.dart';
import '../../../estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../../data/product_list_form_model.dart';

class ProductEstimateFormDialog extends StatefulWidget {
  final bool? fromView;

  final String sKUNumber;
  final double? discountAmount;
  final double? discountPercentage;

  const ProductEstimateFormDialog({
    super.key,
    required this.sKUNumber,
    this.fromView = false,
    this.discountAmount = 0.00,
    this.discountPercentage = 0.00,
  });

  @override
  State<ProductEstimateFormDialog> createState() =>
      _ProductEstimateFormDialogState();
}

class _ProductEstimateFormDialogState extends State<ProductEstimateFormDialog> {
  TextEditingController productIdController = TextEditingController();
  TextEditingController pieceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController netController = TextEditingController();
  TextEditingController makingRateController = TextEditingController();
  TextEditingController makingTypeController = TextEditingController();
  TextEditingController makingValueController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController stoneValueController = TextEditingController();
  TextEditingController diamondValueController = TextEditingController();
  TextEditingController discPercentageController = TextEditingController();
  TextEditingController discAmountController = TextEditingController();
  TextEditingController taxCodeController = TextEditingController();
  TextEditingController taxAmountController = TextEditingController();
  TextEditingController taxableAmtController = TextEditingController();
  TextEditingController otherValueController = TextEditingController();
  TextEditingController calculationValue = TextEditingController();
  TextEditingController miscAmountController = TextEditingController();
  TextEditingController lineAmountController = TextEditingController();

  final discountAmountFocusNode = FocusNode();
  final discountPercentageFocusNode = FocusNode();

  bool _calculate = false;

  final ScrollController _scrollController = ScrollController();

  double taxPercentage = 0.0;
  String taxCode = "";

  int data = 0;
  double originalMakingValue = 0.00;
  double newMakingValue = 0.00;

  double originalTaxableValue = 0.00;
  double originalLineAmount = 0.00;
  double originalTaxAmount = 0.00;

  double taxableAmount = 0.00;
  double discountAmount = 0.00;
  double taxAmount = 0.00;
  double lineAmount = 0.00;

  @override
  void dispose() {
    debugPrint("---DISPOSE---");
    productIdController.dispose();
    pieceController.dispose();
    quantityController.dispose();
    netController.dispose();
    makingRateController.dispose();
    makingTypeController.dispose();
    makingValueController.dispose();
    rateController.dispose();
    stoneValueController.dispose();
    diamondValueController.dispose();
    discPercentageController.dispose();
    discAmountController.dispose();
    taxCodeController.dispose();
    taxAmountController.dispose();
    taxableAmtController.dispose();
    otherValueController.dispose();
    calculationValue.dispose();
    miscAmountController.dispose();
    lineAmountController.dispose();
    _scrollController.dispose();
    discountAmountFocusNode.dispose();
    originalMakingValue = 0.00;
    newMakingValue = 0.00;

    originalTaxableValue = 0.00;
    originalLineAmount = 0.00;
    originalTaxAmount = 0.00;

    taxableAmount = 0.00;
    discountAmount = 0.00;
    taxAmount = 0.00;
    lineAmount = 0.00;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<EstimationBloc>().add(ApiStatusChangeEvent());
    context.read<EstimationBloc>().add(FetchSkuDetailsEvent(
          fromView: widget.fromView,
          skuCode: widget.sKUNumber,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsiveWidth(context) * 0.02,
        vertical: MediaQuery.orientationOf(context) == Orientation.portrait
            ? AppDimensions.getResponsiveHeight(context) * 0.1
            : AppDimensions.getResponsiveHeight(context) * 0.01,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      child: ScaffoldMessenger(
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: BlocConsumer<EstimationBloc, EstimationState>(
                listener: (context, state) {},
                buildWhen: (previous, current) =>
                    current.apiDialogStatus != previous.apiDialogStatus,
                builder: (context, state) {
                  if (state.apiDialogStatus == ApiStatus.success) {
                    if (data <= 1) {
                      productIdController.text =
                          state.skuDetails?.sKUNumber ?? "";
                      rateController.text =
                          state.skuDetails?.rate.toString() ?? "";
                      pieceController.text =
                          state.skuDetails?.pcs.toString() ?? "";
                      quantityController.text =
                          state.skuDetails?.qty!.toStringAsFixed(3) ?? "";
                      netController.text =
                          state.skuDetails?.nett!.toStringAsFixed(3) ?? "";

                      makingRateController.text =
                          state.skuDetails?.makingRate.toString() ?? "";

                      calculationValue.text =
                          state.skuDetails?.cvalue.toString() ?? "";
                      makingValueController.text =
                          state.skuDetails?.mkValue.toString() ?? "";
                      stoneValueController.text =
                          state.skuDetails?.totalStoneQty!.toStringAsFixed(3) ??
                              "0.000";

                      diamondValueController.text = state
                              .skuDetails?.totalDiamondQty!
                              .toStringAsFixed(3) ??
                          "0.000";

                      if (state.skuDetails != null) {
                        discPercentageController.text = widget.fromView!
                            ? widget.discountPercentage!.toStringAsFixed(2)
                            : state.productListFormModel?.skuDiscount?.rate!
                                    .toStringAsFixed(2) ??
                                "0.00";

                        if (SharedPreferencesHelper.getString(
                                AppConstants.WAREHOUSE_STATE_CODE) !=
                            state.stateCode) {
                          for (int i = 0;
                              i < state.productListFormModel!.skuTax!.length;
                              i++) {
                            if (state.productListFormModel!.skuTax![i].taxCode!
                                    .toUpperCase() ==
                                "IGST") {
                              taxPercentage = state
                                  .productListFormModel!.skuTax![i].percentage!;
                              taxCode = state
                                  .productListFormModel!.skuTax![i].taxCode!;
                            }
                          }
                        } else {
                          for (int i = 0;
                              i < state.productListFormModel!.skuTax!.length;
                              i++) {
                            if (state.productListFormModel!.skuTax![i].taxCode!
                                        .toUpperCase() ==
                                    "CGST" ||
                                state.productListFormModel!.skuTax![i].taxCode!
                                        .toUpperCase() ==
                                    "SGST") {
                              taxPercentage = state.productListFormModel!
                                      .skuTax![i].percentage! *
                                  2.0;

                              taxCode = "GST";
                            }
                          }
                        }
                        discAmountController.text = "0.00";

                        /*taxableAmtController.text = calculatedTaxableAmount(
                                skuDetails: state.skuDetails!,
                                discountAmount: discAmountController.text)
                            .toStringAsFixed(2);*/

                        taxableAmount = calculatedTaxableAmount(
                            skuDetails: state.skuDetails!,
                            discountAmount: discAmountController.text);

                        debugPrint("taxableAmount--->$taxableAmount");
                        int roundedAmount = taxableAmount.ceil();
                        debugPrint("roundedAmount--->$roundedAmount");
                        if(roundedAmount % 5 == 0){
                          taxableAmtController.text =
                              AppWidgets.formatIndianNumber(roundedAmount.toDouble());
                        }else{
                          int result = (roundedAmount ~/ 5);
                          debugPrint("result--->$result");
                          int mode = (result + 1) * 5;
                          debugPrint("mode--->$mode");
                          taxableAmtController.text =
                              AppWidgets.formatIndianNumber(mode.toDouble());
                        }




                        if (state.productListFormModel!.skuDiscount!.desc!
                            .toLowerCase()
                            .contains("making")) {
                          originalMakingValue = state.skuDetails!.mkValue!;
                          // originalMakingValue = double.parse(AppWidgets.formatIndianNumber(state.skuDetails!.mkValue!));
                          newMakingValue = (state.skuDetails!.mkValue! *
                                  (100 -
                                      state.productListFormModel!.skuDiscount!
                                          .rate!)) /
                              100;

                          /*discAmountController.text = widget.fromView!
                              ? widget.discountAmount!.toStringAsFixed(2)
                              : (originalMakingValue - newMakingValue).toStringAsFixed(2);*/

                          discountAmount = widget.fromView!
                              ? double.parse(
                                  widget.discountAmount!.toStringAsFixed(2))
                              : double.parse(
                                  (originalMakingValue - newMakingValue)
                                      .toStringAsFixed(2));

                          discAmountController.text =
                              AppWidgets.formatIndianNumber(discountAmount);
                        } else if (state
                            .productListFormModel!.skuDiscount!.desc!
                            .toLowerCase()
                            .contains("line")) {
                          /*discAmountController.text = widget.fromView!
                              ? widget.discountAmount!.toStringAsFixed(2)
                              : ((double.parse(taxableAmtController.text) * (state.productListFormModel!.skuDiscount!.rate!)) / 100).toStringAsFixed(2);*/

                          discountAmount = widget.fromView!
                              ? double.parse(
                                  widget.discountAmount!.toStringAsFixed(2))
                              : (double.parse(taxableAmtController.text) *
                                      (state.productListFormModel!.skuDiscount!
                                          .rate!)) /
                                  100;
                          //.toStringAsFixed(2);

                          discAmountController.text =
                              AppWidgets.formatIndianNumber(discountAmount);
                        } else {
                          /*originalMakingValue = state.skuDetails!.mkValue!;
                          newMakingValue = (state.skuDetails!.mkValue! *
                                  (100 -
                                      state.productListFormModel!.skuDiscount!
                                          .rate!)) /
                              100;*/

                          /*discAmountController.text = widget.fromView!
                              ? widget.discountAmount!.toStringAsFixed(2)
                              : (originalMakingValue - newMakingValue).toStringAsFixed(2);*/


                          // debugPrint("LINE_AMOUNT_01==>$lineAmount");
                          debugPrint("widget.fromView--->${widget.discountAmount!}");
                          discountAmount = widget.fromView!
                              ? double.parse(AppWidgets.formatIndianNumber(
                                      double.parse(widget.discountAmount!
                                          .toStringAsFixed(2)))
                                  .replaceAll(',', ''))
                              : double.parse(AppWidgets.formatIndianNumber(
                                  (originalMakingValue - newMakingValue)));
                          // .toStringAsFixed(2);

                          discAmountController.text =
                              AppWidgets.formatIndianNumber(discountAmount);
                        }

                        /*taxableAmtController.text = calculatedTaxableAmount(
                                skuDetails: state.skuDetails!,
                                discountAmount: discAmountController.text)
                            .toStringAsFixed(2);*/

            /*taxableAmount = calculatedTaxableAmount(
                skuDetails: state.skuDetails!,
                discountAmount: discountAmount.toStringAsFixed(2));*/

                        // taxableAmtController.text =
                        //     AppWidgets.formatIndianNumber(taxableAmount);

                        //--------------------

                        taxableAmount = calculatedTaxableAmount(
                            skuDetails: state.skuDetails!,
                            discountAmount: discAmountController.text.replaceAll(",", ''));

                        debugPrint("taxableAmount--->$taxableAmount");
                        int roundedAmnt = taxableAmount.ceil();
                        debugPrint("roundedAmount--->$roundedAmnt");
                        if(roundedAmnt % 5 == 0){
                          taxableAmtController.text =
                              AppWidgets.formatIndianNumber(roundedAmnt.toDouble());
                        }else{
                          int result = (roundedAmnt ~/ 5);
                          debugPrint("result--->$result");
                          int mode = (result + 1) * 5;
                          debugPrint("mode--->$mode");
                          taxableAmtController.text =
                              AppWidgets.formatIndianNumber(mode.toDouble());
                        }

                        //-------------------

                        // taxAmountController.text = calculateTaxAmount().toStringAsFixed(2);
                        taxAmount = calculateTaxAmount();
                        taxAmountController.text =
                            AppWidgets.formatIndianNumber(taxAmount);

                        // ** NEW CHANGE **
                        // lineAmount = calculateLineAmount(0.0);
                        lineAmount = calculateLineAmount(discountAmount);

                        // lineAmountController.text = calculateLineAmount().toStringAsFixed(2);
                        lineAmountController.text =
                            AppWidgets.formatIndianNumber(lineAmount);

                        // originalLineAmount = double.parse(lineAmountController.text);
                        originalLineAmount = lineAmount;
                        // originalTaxableValue = double.parse(taxableAmtController.text);
                        originalTaxableValue =
                            taxableAmount; //double.parse(taxableAmtController.text);
                        // originalTaxAmount = double.parse(taxAmountController.text);
                        originalTaxAmount = taxAmount;
                      }
                      data++;
                    }
                  }
                  switch (state.apiDialogStatus) {
                    case ApiStatus.loading:
                      return Center(
                        child: SizedBox(
                          height: size.height * 0.03,
                          width: size.width * 0.06,
                          child: Platform.isAndroid
                              ? const CircularProgressIndicator(
                                  color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                                )
                              : const CupertinoActivityIndicator(),
                        ),
                      );
                    case ApiStatus.success:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gap(AppDimensions.getResponsiveHeight(context) *
                              0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${state.skuDetails?.prodName} ${state.skuDetails?.purity ?? ""}",
                                    style: const TextStyle(
                                      color:
                                          AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: SvgPicture.asset(
                                    "assets/images/circle_close.svg",
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                                        BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(AppDimensions.getResponsiveHeight(context) *
                              0.015),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  state.skuDetails?.imageUrl != null
                                      ? SizedBox(
                                          height: size.height * 0.2,
                                          width: size.width * 0.5,
                                          child: Image.network(
                                            state.skuDetails!.imageUrl!,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Container(),
                                  Gap(AppDimensions.getResponsiveHeight(
                                          context) *
                                      0.01),
                                  AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: productIdController,
                                    hintText: "Product Id",
                                    labelText: 'Product Id',
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          enabled: false,
                                          size,
                                          controller: pieceController,
                                          hintText: "Piece",
                                          labelText: 'Piece',
                                        ),
                                      ),
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          enabled: false,
                                          size,
                                          controller: quantityController,
                                          hintText: "Qty",
                                          labelText: 'Qty',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          enabled: false,
                                          size,
                                          controller: netController,
                                          hintText: "Net",
                                          labelText: 'Net',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          size,
                                          controller: diamondValueController,
                                          hintText: "Dia. Wt.",
                                          enabled: false,
                                          labelText: 'Dia. Wt.',
                                        ),
                                      ),
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          size,
                                          controller: stoneValueController,
                                          enabled: false,
                                          hintText: "St. Wt.",
                                          labelText: 'St. Wt.',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          size,
                                          controller: discPercentageController,
                                          hintText: "Disc Per",
                                          labelText: 'Disc Per',
                                          onTap: () {
                                            _scrollToFocusedTextField(
                                                discountPercentageFocusNode);
                                          },
                                          textInputType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*')),
                                          ],
                                          onChange: (value) {
                                            setState(() {
                                              if (value!.isEmpty) {
                                                discAmountController.text =
                                                    '0.00';

                                                int roundedAmnt = originalTaxableValue.ceil();
                                                if(roundedAmnt % 5 == 0){
                                                  taxableAmtController.text = roundedAmnt.toStringAsFixed(2);
                                                }else{
                                                  int result = (roundedAmnt ~/ 5);
                                                  debugPrint("result--->$result");
                                                  int mode = (result + 1) * 5;
                                                  debugPrint("mode--->$mode");
                                                  taxableAmtController.text = mode.toStringAsFixed(2);
                                                }


                                                /*taxAmountController.text =
                                                    originalTaxAmount
                                                        .toStringAsFixed(2);*/
                                                taxAmount = originalTaxAmount;

                                                taxAmountController.text =
                                                    AppWidgets
                                                        .formatIndianNumber(
                                                            taxAmount);
                                                /*lineAmountController.text =
                                                    originalLineAmount
                                                        .toStringAsFixed(2);*/

                                                lineAmount = originalLineAmount;
                                                lineAmountController.text =
                                                    AppWidgets
                                                        .formatIndianNumber(
                                                            lineAmount);

                                                return;
                                              }

                                              double discountPercentage =
                                                  double.tryParse(value) ?? 0.0;

                                              double originalMakingValue =
                                                  state.skuDetails?.mkValue ??
                                                      0.0;

                                              double totalValue = (state
                                                          .skuDetails
                                                          ?.mkValue ??
                                                      0.0) +
                                                  (state.skuDetails
                                                          ?.stoneValue ??
                                                      0.0) +
                                                  (state.skuDetails
                                                          ?.diamondValue ??
                                                      0.0) +
                                                  (state.skuDetails?.cvalue ??
                                                      0.0);

                                              if (state.productListFormModel
                                                      ?.skuDiscount?.desc
                                                      ?.toLowerCase()
                                                      .contains("making") ==
                                                  true) {
                                                double newMakingValue =
                                                    (originalMakingValue *
                                                            (100 -
                                                                discountPercentage)) /
                                                        100;
                                                /*discAmountController.text =
                                                    (originalMakingValue -
                                                            newMakingValue)
                                                        .toStringAsFixed(2);*/

                                                discountAmount =
                                                    (originalMakingValue -
                                                        newMakingValue);

                                                discAmountController.text =
                                                    AppWidgets
                                                        .formatIndianNumber(
                                                            discountAmount);


                                              } else if (state
                                                      .productListFormModel
                                                      ?.skuDiscount
                                                      ?.desc
                                                      ?.toLowerCase()
                                                      .contains("line") ==
                                                  true) {
                                                /*discAmountController
                                                    .text = ((totalValue *
                                                            discountPercentage) /
                                                        100)
                                                    .toStringAsFixed(2);*/
                                                discountAmount = (totalValue *
                                                        discountPercentage) /
                                                    100;


                                                // .toStringAsFixed(2));

                                                discAmountController.text =
                                                    AppWidgets
                                                        .formatIndianNumber(
                                                            discountAmount);
                                              } else {
                                                /*discAmountController
                                                    .text = ((totalValue *
                                                            discountPercentage) /
                                                        100)
                                                    .toStringAsFixed(2);*/

                                                debugPrint(
                                                    "LINE_AMOUNT==>$lineAmount");

                                                // DISCOUNT BASED ON TAXABLE AMOUNT
                                                /*discountAmount = (totalValue *
                                                        discountPercentage) /
                                                    100;*/
                                                // .toStringAsFixed(2));

                                                // DISCOUNT BASED ON LINE AMOUNT

                                                discountAmount = (totalValue * discountPercentage) / 100;




                                                // discountAmount = (double.parse(taxableAmtController.text.replaceAll(",", "")) * discountPercentage) / 100;
                                                debugPrint(
                                                    "discountAmount==>$discountAmount");

                                                discAmountController.text =
                                                    AppWidgets
                                                        .formatIndianNumber(
                                                            discountAmount);
                                                double tempTaxableAmount = (totalValue - discountAmount);

                                                int roundedAmnt = tempTaxableAmount.ceil();
                                                if(roundedAmnt % 5 == 0){
                                                  taxableAmtController.text = AppWidgets.formatIndianNumber(roundedAmnt.toDouble());
                                                }else{
                                                  int result = (roundedAmnt ~/ 5);
                                                  debugPrint("result--->$result");
                                                  int mode = (result + 1) * 5;
                                                  debugPrint("mode--->$mode");
                                                  taxableAmtController.text = AppWidgets.formatIndianNumber(mode.toDouble());
                                                }

                                                /*taxableAmtController.text = AppWidgets.formatIndianNumber(tempTaxableAmount);*/
                                                double tempTaxAmount = 0.0;
                                                for (int i = 0;
                                                i < state.productListFormModel!.skuTax!.length;
                                                i++) {
                                                  if (state.productListFormModel!.skuTax![i].taxCode!
                                                      .toUpperCase() ==
                                                      "IGST") {
                                                    // tempTaxAmount = (tempTaxableAmount * state.productListFormModel!.skuTax![i].percentage!) / 100;
                                                    tempTaxAmount = (double.parse(taxableAmtController.text.replaceAll(",", "")) * state.productListFormModel!.skuTax![i].percentage!) / 100;
                                                  }
                                                }

                                                taxAmountController.text = AppWidgets.formatIndianNumber(tempTaxAmount);

                                                // lineAmount = tempTaxableAmount + tempTaxAmount;
                                                lineAmount = double.parse(taxableAmtController.text.replaceAll(",", "")) + tempTaxAmount;

                                                lineAmountController.text =
                                                    AppWidgets.formatIndianNumber(
                                                        lineAmount);


                                              }

                                              /*taxableAmtController.text =
                                                  calculatedTaxableAmount(
                                                          skuDetails:
                                                              state.skuDetails!,
                                                          discountAmount:
                                                              discAmountController
                                                                  .text)
                                                      .toStringAsFixed(2);*/

                                              // CALCULATE BASED ON TAXABLE AMOUNT

                                              /*taxableAmount =
                                                  calculatedTaxableAmount(
                                                      skuDetails:
                                                          state.skuDetails!,
                                                      discountAmount:
                                                          discountAmount
                                                              .toStringAsFixed(
                                                                  2));

                                              taxableAmtController.text =
                                                  AppWidgets.formatIndianNumber(
                                                      taxableAmount);

                                              */
                                              /*taxAmountController.text =
                                                  calculateTaxAmount()
                                                      .toStringAsFixed(2);*/ /*
                                              taxAmount = calculateTaxAmount();
                                              taxAmountController.text =
                                                  AppWidgets.formatIndianNumber(
                                                      taxAmount);

                                              lineAmount = calculateLineAmount();
                                              */ /*lineAmountController.text =
                                                  calculateLineAmount()
                                                      .toStringAsFixed(2);*/ /*
                                              lineAmountController.text = AppWidgets.formatIndianNumber(lineAmount);*/

                                              // CALCULATE BASED ON LINE AMOUNT

                                              /*taxableAmount = calculatedTaxableAmount(
                                                  skuDetails: state.skuDetails!,
                                                  discountAmount: discountAmount.toStringAsFixed(2)) - double.parse(discountAmount.toStringAsFixed(2));

                                              taxableAmtController.text =
                                                  AppWidgets.formatIndianNumber(taxableAmount);

                                              // taxAmountController.text = calculateTaxAmount().toStringAsFixed(2);
                                              taxAmount = calculateTaxAmount();
                                              taxAmountController.text =
                                                  AppWidgets.formatIndianNumber(taxAmount);*/

                                             /* lineAmount = calculateLineAmount(
                                                  discountAmount);
                                              lineAmountController.text =
                                                  AppWidgets.formatIndianNumber(
                                                      lineAmount);*/
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          size,
                                          controller: discAmountController,
                                          hintText: "Disc Amt",
                                          focusNode: discountAmountFocusNode,
                                          onTap: () {
                                            _scrollToFocusedTextField(
                                                discountAmountFocusNode);
                                          },
                                          labelText: 'Disc Amt',
                                          textInputType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*')),
                                          ],
                                          onChange: (value) {
                                            setState(() {
                                              if (value!.isEmpty) {
                                                discPercentageController.text =
                                                    '0.00';
                                                taxableAmtController.text =
                                                    originalTaxableValue
                                                        .toStringAsFixed(2);
                                                /*taxAmountController.text =
                                                    originalTaxAmount
                                                        .toStringAsFixed(2);*/
                                                taxAmount = originalTaxAmount;
                                                taxAmountController.text =
                                                    AppWidgets
                                                        .formatIndianNumber(
                                                            taxAmount);

                                                /*lineAmountController.text =
                                                    originalLineAmount
                                                        .toStringAsFixed(2);*/

                                                lineAmount = originalLineAmount;
                                                lineAmountController.text =
                                                    AppWidgets
                                                        .formatIndianNumber(
                                                            lineAmount);

                                                return;
                                              }

                                              double discountAmount =
                                                  double.tryParse(value) ?? 0.0;
                                              double totalValue = (state
                                                          .skuDetails
                                                          ?.mkValue ??
                                                      0.0) +
                                                  (state.skuDetails
                                                          ?.stoneValue ??
                                                      0.0) +
                                                  (state.skuDetails
                                                          ?.diamondValue ??
                                                      0.0) +
                                                  (state.skuDetails?.cvalue ??
                                                      0.0);

                                              if (totalValue > 0) {
                                                discPercentageController.text =
                                                    ((discountAmount * 100) /
                                                            totalValue)
                                                        .toStringAsFixed(2);
                                              }

                                              taxableAmtController
                                                  .text = calculatedTaxableAmount(
                                                      skuDetails:
                                                          state.skuDetails!,
                                                      discountAmount:
                                                          discountAmount
                                                              .toStringAsFixed(
                                                                  2))
                                                  .toStringAsFixed(2);

                                              /*taxAmountController.text =
                                                  calculateTaxAmount()
                                                      .toStringAsFixed(2);*/
                                              taxAmount = calculateTaxAmount();
                                              taxAmountController.text =
                                                  AppWidgets.formatIndianNumber(
                                                      taxAmount);

                                              /*lineAmountController.text =
                                                  calculateLineAmount()
                                                      .toStringAsFixed(2);*/

                                              lineAmount =
                                                  calculateLineAmount(0.0);
                                              lineAmountController.text =
                                                  AppWidgets.formatIndianNumber(
                                                      lineAmount);
                                            });
                                          },
                                        ),
                                      ),
                                      /*IconButton(onPressed: () {

                                      }, icon: Icon(Icons.add_box_sharp,color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,))*/
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          size,
                                          controller: taxableAmtController,
                                          enabled: false,
                                          hintText: "Taxable Amt",
                                          labelText: 'Taxable Amt',
                                        ),
                                      ),
                                      Expanded(
                                        child: AppWidgets().buildTextFormField(
                                          size,
                                          controller: taxAmountController,
                                          enabled: false,
                                          hintText: "Tax Amt",
                                          labelText: 'Tax Amt',
                                        ),
                                      ),
                                    ],
                                  ),
                                  AppWidgets().buildTextFormField(
                                    size,
                                    controller: lineAmountController,
                                    enabled: false,
                                    hintText: "Total Value",
                                    labelText: 'Total Value',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gap(size.height * 0.01),
                          BlocConsumer<EstimationBloc, EstimationState>(
                            listener: (context, state) {
                              switch (state.apiStatus) {
                                case ApiStatus.success:
                                  Navigator.pop(context);
                                  context.go(AppPages.SEARCH_PRODUCT);
                                default:
                                  return;
                              }
                            },
                            builder: (context, state) {
                              return AppWidgets.customMobileButton(
                                size: size,
                                isLoading: state.apiStatus == ApiStatus.loading
                                    ? true
                                    : false,
                                btnName: "Submit",
                                color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                                func: () {
                                  SharedPreferencesHelper.saveString(
                                      AppConstants.DiscountAmount,
                                      discAmountController.text);
                                  context.read<EstimationBloc>().add(
                                        SkuSaveForListEvent(
                                          //double.parse(lineAmountController.text),
                                          lineAmount,
                                          // double.parse(taxAmountController.text),
                                          //taxAmount,
                                          double.parse(taxAmountController.text.replaceAll(",", '')),
                                          // double.tryParse(discAmountController.text) ?? 0.00,
                                          discountAmount,
                                          double.parse(quantityController.text),
                                          double.tryParse(
                                                  discPercentageController
                                                      .text) ??
                                              0.00,
                                        ),
                                      );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                          Gap(size.height * 0.01),
                        ],
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  double calculateTaxAmount() {
    // double taxAmount = ((double.parse(taxableAmtController.text.toString())) *
    // double taxAmount = (taxableAmount * (taxPercentage / 100));
    double taxAmount = (double.parse(taxableAmtController.text.replaceAll(",", "")) * (taxPercentage / 100));

    return taxAmount;
  }

  double calculateLineAmount(double discountAmount) {
    if (kDebugMode) {
      print("TAXABLE_AMOUNT-->$taxableAmount");
      print("TAX_AMOUNT-->$taxAmount");
      print("DISCOUNT-->$discountAmount");
    }
    // double total = double.parse(taxableAmtController.text) +
    // double total = taxableAmount + double.parse(taxAmountController.text);
    // double total = (taxableAmount + taxAmount) - discountAmount;
    double total = (double.parse(taxableAmtController.text.replaceAll(",", "")) + taxAmount) - discountAmount;

    return total;
  }

  double calculatedTaxableAmount(
      {required SkuDetails skuDetails, required String discountAmount}) {
    double discountedAmount = discountAmount.isEmpty ? 0.00 : double.parse(discountAmount);

    double total = ((skuDetails.mkValue ?? 0.0) +
            (skuDetails.stoneValue ?? 0.0) +
            (skuDetails.diamondValue ?? 0.0) +
            (skuDetails.cvalue ?? 0.0));
        // - discountedAmount;

    return total;
  }

  void _scrollToFocusedTextField(FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 550), () {
        _scrollController.animateTo(
          _scrollController.position.pixels +
              AppDimensions.getResponsiveHeight(context) * 0.3,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
        );
      });
    });
  }

  void _calculateAfterDiscount() {}
}
