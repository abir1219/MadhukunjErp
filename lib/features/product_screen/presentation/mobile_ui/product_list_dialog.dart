import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../features/product_screen/presentation/mobile_ui/product_estimate_form_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/api_status.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../estimation_screen/presentation/bloc/estimation_bloc.dart';

class ProductListDialog extends StatefulWidget {
  final bool isDialog;

  const ProductListDialog({super.key, this.isDialog = false});

  @override
  State<ProductListDialog> createState() => _ProductListDialogState();
}

class _ProductListDialogState extends State<ProductListDialog> {
  final _searchTextController = TextEditingController();
  bool _dialogShown = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<EstimationBloc>().add(ApiStatusChangeEvent());
    context.read<EstimationBloc>().add(CheckRateSetEvent());
    context.read<EstimationBloc>().add(const FetchProductListEvent(search: ""));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    // return
    Widget content = ScaffoldMessenger(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              children: [
                Gap(size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product search",
                      style: TextStyle(
                          color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
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
                Gap(size.height * 0.02),
                BlocConsumer<EstimationBloc, EstimationState>(
                  listener: (context, state) {
                    if (state.isRateSet == false && !_dialogShown) {
                      _dialogShown = true;
                      AwesomeDialog(
                        // autoDismiss: false,
                        context: context,
                        dialogType: DialogType.error,
                        dismissOnTouchOutside: false,
                        title: 'Rate Alert',
                        titleTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                        desc: 'Please fix the rate',
                        btnOkOnPress: () => exit(0),
                      ).show();
                    }
                  },
                  builder: (context, state) {
                    switch (state.apiDialogStatus) {
                      case ApiStatus.loading:
                        return Expanded(
                          child: Center(
                            child: SizedBox(
                              height: size.height * 0.03,
                              width: size.width * 0.06,
                              child: Platform.isAndroid
                                  ? const CircularProgressIndicator(
                                      color:
                                          AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                                    )
                                  : const CupertinoActivityIndicator(),
                            ),
                          ),
                        );
                      case ApiStatus.success:
                        return Expanded(
                          child: Column(
                            children: [
                              AppWidgets.buildSearchableField(
                                  size,
                                  change: (text) {
                                    /*context.read<EstimationBloc>().add(
                                      FetchProductListEvent(
                                        search: _searchTextController
                                            .text
                                            .trim(),
                                      ),
                                    );*/
                                  },
                                  "Sku id",
                                  func: () {
                                    context.read<EstimationBloc>().add(
                                          FetchProductListEvent(
                                            search: _searchTextController.text
                                                .trim(),
                                          ),
                                        );
                                  },
                                  _searchTextController,
                                  isEnabled: true),
                              Gap(size.height * 0.05),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return _buildProductContainer(
                                        index, size, state, () {
                                      if (widget.isDialog) {
                                        Navigator.pop(context);
                                      }
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return ProductEstimateFormDialog(
                                            sKUNumber: state
                                                .productList![index].sKUNumber!,
                                          );
                                        },
                                      );
                                    });
                                  },
                                  itemCount: state.productList!.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      case ApiStatus.error:
                        return Expanded(
                          child: Center(
                            child: Text(state.message!),
                          ),
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.isDialog) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        insetPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.02, vertical: size.height * 0.1),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        child: content,
      );
    } else {
      return content;
    }
  }

  Widget _buildProductContainer(
      int index, Size size, EstimationState state, void Function() func) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        /*margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: size.height * 0.02),*/
        margin: EdgeInsets.symmetric(vertical: size.height * .005),
        // padding: const EdgeInsets.symmetric(horizontal: 6), //,vertical: 2
        // padding: const EdgeInsets.only(left: 6), //,vertical: 2
        height: size.height * 0.08,
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? AppColors.CONTAINER_BACKGROUND_COLOR_01
              : AppColors.CONTAINER_BACKGROUND_COLOR_02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Container
            Container(
              margin: EdgeInsets.only(top: 2, bottom: 2, left: 2),
              height: AppDimensions.getResponsiveHeight(context) * 0.2,
              width: AppDimensions.getResponsiveWidth(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // color: Colors.red,
                image: state.productList![index].imageUrl != null
                    ? DecorationImage(
                        image:
                            NetworkImage(state.productList![index].imageUrl!),
                        fit: BoxFit.fill,
                      )
                    : null, // No image if URL is null
              ),
              child: state.productList![index].imageUrl == null
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: AppDimensions.getResponsiveWidth(context) * 0.03),
            // Space between image and details
            // Product Details and Arrow
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Details Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SKU Number Container
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * .005,
                          horizontal: size.width * .01,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * .006,
                          vertical: size.height * .002,
                        ),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? AppColors.STEPPER_DONE_COLOR
                              : AppColors.CONTAINER_BACKGROUND_COLOR_03,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "${state.productList![index].sKUNumber}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      // Product Name, Purity, and Pieces
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * .005,
                          horizontal: size.width * .01,
                        ),
                        child: Text(
                          "${state.productList![index].prodName}, "
                          "${state.productList![index].purity ?? '0'}, "
                          "${state.productList![index].pcs}Pc.",
                          style: const TextStyle(
                            color: AppColors.STEPPER_DONE_COLOR,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Arrow Icon
                  Container(
                    margin: EdgeInsets.only(left: size.width * 0.02),
                    child: SvgPicture.asset(
                        "assets/images/arrow_right_circle.svg"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
