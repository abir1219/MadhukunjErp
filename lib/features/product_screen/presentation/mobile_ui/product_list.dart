import 'package:crown_pro_estimation/features/product_screen/presentation/mobile_ui/product_estimate_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../../../ingredient_screen/presentation/ingredients_form_dialog.dart';
import '../../../miscellenous_screen/presentation/miscellaneous_product_list.dart';

class ProductList extends StatefulWidget {
  const ProductList({
    super.key,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // double _rotationAngle = 360.0;

  final pieceController = TextEditingController();
  final quantityController = TextEditingController();
  final nettController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pieceController.dispose();
    quantityController.dispose();
    nettController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return ScaffoldMessenger(
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<EstimationBloc, EstimationState>(
            // listenWhen: (previous, current) => current.apiStatus == ApiStatus.success,
            listener: (context, state) {
              /*debugPrint("STATE_STATUS--->${state.apiStatus}");
              if(state.apiStatus == ApiStatus.success){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!,style: const TextStyle(color: Colors.white,fontSize: 16),)));
                // context.go(
                //   AppPages.ESTIMATION,
                // );
              }*/
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: state.selectedProductList!.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          debugPrint("Index--->$index");
                          pieceController.text = state
                              .selectedProductList![index].skuDetails!.pcs
                              .toString();
                          quantityController.text = state
                              .selectedProductList![index].skuDetails!.qty
                              .toString();
                          nettController.text = state
                              .selectedProductList![index].skuDetails!.nett
                              .toString();

                          amountController.text =
                              state.lineAmountList![index].toString();
                          debugPrint("Amount--->${amountController.text}");

                          // amountController.text = state.selectedProductList![index].line.toString();
                          return Column(
                            children: [
                              _buildProductContainer(index, size, () {
                                context
                                    .read<EstimationBloc>()
                                    .add(ChangeAngle(index));
                                debugPrint(
                                    "rotationAngle===>${state.rotationAngle![index]}");
                                /*setState(() {
                              debugPrint("kjk==$_rotationAngle");
                              _rotationAngle = _rotationAngle == 180.0 ? 360.0 : 180.0;
                              // _rotationAngle = 360.0;
                            });*/
                              }, state),
                              state.rotationAngle![index] == 180.0
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.02),
                                      decoration: const BoxDecoration(
                                        color: AppColors.ICON_BACKGROUND_COLOR,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    AppWidgets().buildTextField(
                                                  size,
                                                  //controller: pieceController,
                                                  hintText: "Piece(s)",
                                                  labelText: 'Piece(s)',
                                                  text: state
                                                      .selectedProductList![
                                                          index]
                                                      .skuDetails!
                                                      .pcs
                                                      .toString(),
                                                ),
                                              ),
                                              Expanded(
                                                child:
                                                    AppWidgets().buildTextField(
                                                  text: state
                                                      .selectedProductList![
                                                          index]
                                                      .skuDetails!
                                                      .qty
                                                      .toString(),
                                                  size,
                                                  // controller:
                                                  //     quantityController,
                                                  hintText: "Qty",
                                                  labelText: 'Qty',
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    AppWidgets().buildTextField(
                                                  text: state
                                                      .selectedProductList![
                                                          index]
                                                      .skuDetails!
                                                      .nett
                                                      .toString(),
                                                  size,
                                                  //controller: nettController,
                                                  hintText: "Net",
                                                  labelText: 'Net',
                                                ),
                                              ),
                                              Expanded(
                                                child:
                                                    AppWidgets().buildTextField(
                                                  text: state
                                                      .lineAmountList![index]
                                                      .toString(),
                                                  size,
                                                  // controller: amountController,
                                                  hintText: "Amount",
                                                  labelText: 'Amount',
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: AppWidgets
                                                    .buildSearchableField(
                                                  size,
                                                  "Ing. Details",
                                                  null,
                                                  icons: "assets/images/i.svg",
                                                  func: () {
                                                    showGeneralDialog(
                                                      context: context,
                                                      // builder: (context) => const IngredientsFormDialog(),
                                                      barrierDismissible: true,
                                                      barrierLabel:
                                                          MaterialLocalizations
                                                                  .of(context)
                                                              .modalBarrierDismissLabel,
                                                      barrierColor:
                                                          Colors.black45,
                                                      transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  300),
                                                      transitionBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        return SlideTransition(
                                                          position: Tween<
                                                              Offset>(
                                                            begin: const Offset(
                                                                0, 1),
                                                            // Start from the bottom
                                                            end: const Offset(0,
                                                                0), // End at the center
                                                          ).animate(
                                                              CurvedAnimation(
                                                            parent: animation,
                                                            curve: Curves
                                                                .easeInOut, // Ease-in transformation
                                                          )),
                                                          child: child,
                                                        );
                                                      },
                                                      pageBuilder: (BuildContext
                                                                  context,
                                                              Animation<double>
                                                                  animation,
                                                              Animation<double>
                                                                  secondaryAnimation) =>
                                                          IngredientsFormDialog(
                                                        index: index,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              state.selectedProductList![index]
                                                          .skuMisc !=
                                                      null
                                                  ? Expanded(
                                                      child: AppWidgets
                                                          .buildSearchableField(
                                                        size,
                                                        "Misc. Charge",
                                                        null,
                                                        icons:
                                                            "assets/images/mc.svg",
                                                        func: () {
                                                          showGeneralDialog(
                                                            context: context,
                                                            // builder: (context) => const IngredientsFormDialog(),
                                                            barrierDismissible:
                                                                true,
                                                            barrierLabel:
                                                                MaterialLocalizations.of(
                                                                        context)
                                                                    .modalBarrierDismissLabel,
                                                            barrierColor:
                                                                Colors.black45,
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            transitionBuilder:
                                                                (context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child) {
                                                              return SlideTransition(
                                                                position: Tween<
                                                                    Offset>(
                                                                  begin:
                                                                      const Offset(
                                                                          0, 1),
                                                                  // Start from the bottom
                                                                  end: const Offset(
                                                                      0,
                                                                      0), // End at the center
                                                                ).animate(
                                                                    CurvedAnimation(
                                                                  parent:
                                                                      animation,
                                                                  curve: Curves
                                                                      .easeInOut, // Ease-in transformation
                                                                )),
                                                                child: child,
                                                              );
                                                            },
                                                            pageBuilder: (BuildContext context,
                                                                    Animation<
                                                                            double>
                                                                        animation,
                                                                    Animation<
                                                                            double>
                                                                        secondaryAnimation) =>
                                                                MiscellaneousProductList(
                                                              index: index,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()
                            ],
                          );
                        },
                        itemCount: state.selectedProductList!.length,
                      )
                    : const Center(
                        child: Text("No Products Found"),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductContainer(
      int index, Size size, void Function() func, EstimationState state) {
    return GestureDetector(
      //onTap: () => func(),
      child: Container(
        /*margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: size.height * 0.02),*/
        margin: EdgeInsets.symmetric(vertical: size.height * .005),
        // padding: const EdgeInsets.symmetric(horizontal: 6), //,vertical: 2
        padding: const EdgeInsets.only(bottom: 1),
        //,vertical: 2
        height: size.height * 0.085,
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? AppColors.CONTAINER_BACKGROUND_COLOR_01
              : AppColors.CONTAINER_BACKGROUND_COLOR_02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2, bottom: 2, left: 2),
              height: AppDimensions.getResponsiveHeight(context) * 0.2,
              width: AppDimensions.getResponsiveWidth(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // color: Colors.red,
                image: state.selectedProductList![index].skuDetails!.imageUrl !=
                        null
                    ? DecorationImage(
                        image: NetworkImage(state
                            .selectedProductList![index].skuDetails!.imageUrl!),
                        fit: BoxFit.fill,
                      )
                    : null, // No image if URL is null
              ),
              child:
                  state.selectedProductList![index].skuDetails!.imageUrl == null
                      ? Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                          ),
                        )
                      : null,
            ),
            SizedBox(width: AppDimensions.getResponsiveWidth(context) * 0.03),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // height: size.height * 0.02,
                        margin: EdgeInsets.symmetric(
                            vertical: size.height * .005,
                            horizontal: size.width * .01),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * .006,
                            vertical: size.height * .002),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? AppColors.STEPPER_DONE_COLOR
                              : AppColors.CONTAINER_BACKGROUND_COLOR_03,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            state.selectedProductList![index].skuDetails!
                                .sKUNumber!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * .005,
                          horizontal: size.width * .01,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * .002,
                          vertical: size.height * .002,
                        ),
                        child: Text(
                          // "${state.selectedProductList![index].skuDetails!.prodName}, ${state.selectedProductList![index].skuDetails!.purity != null ? state.selectedProductList![index].skuDetails!.purity! : 0}, ${state.selectedProductList![index].skuDetails!.pcs}Pc.",
                          // "${state.selectedProductList![index].skuDetails!.prodName}, ₹${state.selectedProductList![index].skuDetails!.totalAmount!.toStringAsFixed(2)}",
                          "${state.selectedProductList![index].skuDetails!.prodName}, ₹${AppWidgets.formatIndianNumber(state.selectedProductList![index].skuDetails!.totalAmount!)}",
                          style: const TextStyle(
                            color: AppColors.STEPPER_DONE_COLOR,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ProductEstimateFormDialog(
                                  sKUNumber: state.selectedProductList![index]
                                      .skuDetails!.sKUNumber!,
                                  fromView: true,
                                  discountAmount:
                                      state.discountAmountList![index],
                                  discountPercentage:
                                      state.discountPercentageList![index]);
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.02,
                          ),
                          child: Transform.rotate(
                            angle: state.rotationAngle![index] *
                                3.141592653589793 /
                                180,
                            child: SvgPicture.asset(
                              "assets/images/eye.svg",
                              colorFilter: const ColorFilter.mode(
                                  AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                                  BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                      /*Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                        ),
                        child: Transform.rotate(
                          angle:
                              state.rotationAngle![index] * 3.141592653589793 / 180,
                          child: SvgPicture.asset(
                            "assets/images/arrow-down-circle.svg",
                          ),
                        ),
                      ),*/
                      GestureDetector(
                        onTap: () {
                          context
                              .read<EstimationBloc>()
                              .add(DeleteFromSelectedProduct(index));
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent),
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
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
