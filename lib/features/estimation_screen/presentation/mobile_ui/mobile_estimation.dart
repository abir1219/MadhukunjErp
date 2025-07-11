import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crown_pro_estimation/core/constants/app_constants.dart';
import 'package:crown_pro_estimation/core/local/shared_preferences_helper.dart';
import 'package:crown_pro_estimation/features/legal_entity_screen/presentation/bloc/legal_entity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/api_status.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../router/app_pages.dart';
import '../../../product_screen/presentation/mobile_ui/estimation_info_dialog.dart';
import '../../../salesman_screen/presentation/salesman_list_dialog.dart';
import '../bloc/estimation_bloc.dart';

class MobileEstimation extends StatefulWidget {
  const MobileEstimation({super.key});

  @override
  State<MobileEstimation> createState() => _MobileEstimationState();
}

class _MobileEstimationState extends State<MobileEstimation> {
  @override
  void initState() {
    // context.read<EstimationBloc>().add(FetchStateList());
    super.initState();
            // context.read<EstimationBloc>().add(CheckRateSetEvent());
    // mobileNoFocusNode.requestFocus();
  }

  final estimateNoController = TextEditingController();
  final mobileNoController = TextEditingController();
  final mobileNoFocusNode = FocusNode();
  final _stateController = TextEditingController();

  // final _addressController = TextEditingController();
  final _salesmanController = TextEditingController();
  final _narrationController = TextEditingController();

  // final _customerIdController = TextEditingController();
  // final _customerNameController = TextEditingController();
  // final  _panController = TextEditingController();

  @override
  void dispose() {
    estimateNoController.dispose();
    mobileNoController.dispose();
    _stateController.dispose();
    _salesmanController.dispose();
    mobileNoFocusNode.dispose();
    _narrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.APP_BACKGROUND_COLOR, //PAGE_BACKGROUND_COLOR,
      body: SafeArea(
        child: BlocConsumer<EstimationBloc, EstimationState>(
          listener: (context, state) {
            /*if(state.isRateSet == false){
              AwesomeDialog(
                // autoDismiss: false,
                context: context,
                dialogType: DialogType.error,
                dismissOnTouchOutside: false,
                title: 'Rate Alert',
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
                desc:
                'Please fix the rate',
                btnOkOnPress: () => exit(0),
              ).show();
            }*/
          },
          builder: (context, state) {
            debugPrint("state.stateName===>${state.stateName}");
            _stateController.text = state.stateName ?? "";
            _salesmanController.text = state.salesmanName ?? "";
            estimateNoController.text = state.estimationNumber ?? "";
            if (estimateNoController.text.isNotEmpty) {
              debugPrint("---<<<<<<<<>>>>>>>>>>");
              Future.delayed(Duration(milliseconds: 100), () {
                mobileNoFocusNode.requestFocus();
              });
            }
            // _customerIdController.text = state.customerData?.customerCode ?? "";
            // _customerNameController.text =
            //     state.customerData?.customerName ?? "";
            // _addressController.text =
            //     "${state.customerData?.street1 ?? ""} ${state.customerData?.street2 ?? ""}"; //state.address ?? "";
            // _panController.text = state.customerData?.panNo ?? ""; //state.pan ?? "";
            return Column(
              // shrinkWrap: false,
              // physics: const AlwaysScrollableScrollPhysics(),
              // scrollDirection: Axis.vertical,
              children: [
                AppWidgets().buildTopEstimationContainer(
                  size,
                  isShown: true,
                  isLoggedIn: true,
                ),
                /*AppWidgets().buildTopContainer(
                  size,
                  isShown: true,
                  isLoggedIn: true,
                ),*/
                // Gap(AppDimensions.getResponsiveHeight(context) * .02),
                Gap(AppDimensions.getResponsiveHeight(context) * .02),
                AppWidgets().buildStepperContainer(size, pageNo: 2),
                // Gap(AppDimensions.getResponsiveHeight(context) * .02),
                Gap(AppDimensions.getResponsiveHeight(context) * .02),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        // width: AppDimensions.getResponsiveWidth(context),
                        //height: size.height,
                        margin: EdgeInsets.only(
                          right:
                              AppDimensions.getResponsiveWidth(context) * .02,
                          left: AppDimensions.getResponsiveWidth(context) * .02,
                          //top: AppDimensions.getResponsiveWidth(context) * .15,
                        ),
                        padding: EdgeInsets.only(
                          right:
                              AppDimensions.getResponsiveWidth(context) * .03,
                          //10,
                          left: AppDimensions.getResponsiveWidth(context) * .03,
                          //10,
                          // top: AppDimensions.getResponsiveHeight(context) * .09,
                          top: AppDimensions.getResponsiveHeight(context) * .02,
                          bottom:
                              AppDimensions.getResponsiveHeight(context) * .04,
                        ),
                        //75
                        // margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Gap( 75),
                              AppWidgets.buildField(
                                      size,
                                      "Estimate No",
                                      // onChange: () {
                                      //   debugPrint("---<<<<<<<<>>>>>>>>>>");
                                      //   mobileNoFocusNode.requestFocus();
                                      // },
                                      estimateNoController,
                                      enabled: false,
                                    ),
                              AppWidgets.buildField(
                                  size, "Mobile No", mobileNoController,
                                  focusNode: mobileNoFocusNode, onSubmit: () {
                                if (mobileNoController.text.toString() == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please add a mobile no.")),
                                  );
                                } else if (mobileNoController.text.length <
                                    10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please enter a valid mobile no.")),
                                  );
                                } else {
                                  mobileNoFocusNode.unfocus();
                                  SharedPreferencesHelper.saveString(AppConstants.MOBILE_NO, mobileNoController.text);
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  if (_salesmanController.text.isNotEmpty) {
                                    // context.go(
                                    //   AppPages.SEARCH_PRODUCT,
                                    // );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SalesmanListDialog(
                                          employeeList: state.employeeList,
                                          onCallback: () {
                                            debugPrint("OnCallBack");
                                            Future.delayed(
                                              Duration(milliseconds: 100),
                                              () {
                                                if (mobileNoController
                                                        .text.isNotEmpty &&
                                                    _salesmanController
                                                        .text.isNotEmpty) {
                                                  // context.go(
                                                  //   AppPages.SEARCH_PRODUCT,
                                                  // );
                                                } else {
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 100),
                                                      () {
                                                    mobileNoFocusNode
                                                        .requestFocus();
                                                  });
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                                  enabled: state.estimationNumber != null
                                      ? true
                                      : false,
                                  maxLength: 10,
                                  textInputType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ]),
                              //mobileNoController
                              /*AppWidgets.buildField(
                                size,
                                "Customer Name",
                                _customerNameController,
                                enabled: false,
                              ),
                              AppWidgets.buildField(
                                size,
                                "Customer Id",
                                _customerIdController,
                                enabled: false,
                              ),
                              AppWidgets.buildField(
                                size,
                                "Address",
                                _addressController,
                                enabled: false,
                              ),
                              AppWidgets.buildField(
                                size,
                                "PAN",
                                _panController,
                                enabled: false,
                              ),*/
                              /*AppWidgets.buildSearchableField(
                                size,
                                "POS",
                                _stateController,
                                color: state.estimationNumber != null
                                    ? AppColors.STEPPER_DONE_COLOR
                                    : AppColors.HINT_TEXT_COLOR,
                                func: () {
                                  if (state.estimationNumber != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StateListDialog(
                                          stateList: state.stateList,
                                          country: "",
                                        );
                                      },
                                    );
                                  }
                                },
                              ),*/
                              AppWidgets.buildSearchableField(
                                size,
                                "Sales Person",
                                _salesmanController,
                                color: state.estimationNumber != null
                                    ? AppColors.STEPPER_DONE_COLOR
                                    : AppColors.HINT_TEXT_COLOR,
                                func: () {
                                  if (state.estimationNumber != null) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return SalesmanListDialog(
                                          employeeList: state.employeeList,
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                              /*AppWidgets.buildField(
                                size,
                                "Narration",
                                _narrationController,
                                enabled: state.estimationNumber != null
                                    ? true
                                    : false,
                              ),*/
                            ],
                          ),
                        ),
                      ),
                      // Parent widget with Positioned Row containing tabs
                      /*Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppWidgets().buildCustomerTab(
                              size,
                              "plus_circle.svg",
                              "New Customer",
                              () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return const AddCustomerDialog();
                                  },
                                );
                              },
                            ),
                            AppWidgets().buildCustomerTab(
                              size,
                              "search.svg",
                              "Search Customer",
                              () {
                                context
                                    .read<EstimationBloc>()
                                    .add(ApiStatusChangeEvent());
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return const SearchCustomerDialog();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
                // Gap(AppDimensions.getResponsiveHeight(context) * .01),
                Gap(
                  AppDimensions.getResponsiveHeight(context) * .01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        AppDimensions.getResponsiveHeight(context) * .01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: AppWidgets.customMobileButton(
                            size: size,
                            btnName: 'Home',
                            color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                            func: () {
                              context.go(AppPages.SEARCH_PRODUCT);
                            }),
                      ),
                      Expanded(
                        child: AppWidgets.customMobileButton(
                          size: size,
                          btnName: 'Reset',
                          func: () {
                            mobileNoController.text = "";
                            if (state.estimationNumber != null) {
                              context
                                  .read<EstimationBloc>()
                                  .add(ResetDataEvent());
                            }
                          },
                          color: state.estimationNumber != null
                              ? AppColors.LOGO_BACKGROUND_BLUE_COLOR
                              : AppColors.HINT_TEXT_COLOR,
                        ),
                      ),
                      Expanded(
                        child: AppWidgets.customMobileButton(
                            size: size,
                            func: () => context
                                .read<EstimationBloc>()
                                .add(GenerateEstimationNumber()),
                            isLoading:
                            state.apiStatus == ApiStatus.loading
                                ? true
                                : false,
                            btnName: 'Add',
                            color: AppColors.LOGO_BACKGROUND_BLUE_COLOR),
                      ),
                    ],
                  ),
                ),
                // Gap(AppDimensions.getResponsiveHeight(context) * 0.02)
                //Gap(AppDimensions.getResponsiveHeight(context) * 0.02)
                Gap(size.height * 0.01),
                // Gap(size.height * .01),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal: size.width * .02,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                  ),
                  height: size.height * .08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Estimate Amount",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                Gap(size.width * 0.004),
                                InkWell(
                                  onTap: () {
                                    showGeneralDialog(
                                      context: context,
                                      // builder: (context) => const IngredientsFormDialog(),
                                      barrierDismissible: true,
                                      barrierLabel:
                                      MaterialLocalizations.of(context)
                                          .modalBarrierDismissLabel,
                                      barrierColor: Colors.black45,
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      transitionBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 1),
                                            // Start from the bottom
                                            end: const Offset(
                                                0, 0), // End at the center
                                          ).animate(CurvedAnimation(
                                            parent: animation,
                                            curve: Curves
                                                .easeInOut, // Ease-in transformation
                                          )),
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                          secondaryAnimation) =>
                                      const EstimationInfoDialog(),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.info,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            BlocConsumer<EstimationBloc, EstimationState>(
                              listener: (context, state) {},
                              builder:
                                  (BuildContext context, EstimationState state) {
                                if (state.lineAmountList!.isNotEmpty) {
                                  double totalAmount = 0.0;
                                  for (int i = 0;
                                  i < state.lineAmountList!.length;
                                  i++) {
                                    totalAmount += state.lineAmountList![i];
                                  }
                                  return Text(
                                    // "₹ ${totalAmount.toStringAsFixed(2)}",
                                    "₹ ${AppWidgets.formatIndianNumber(totalAmount)}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  );
                                } else {
                                  return const Text(
                                    "₹ 0.00",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                          child: BlocConsumer<EstimationBloc, EstimationState>(
                            listenWhen: (previous, current) =>
                            current.apiStatus == ApiStatus.success,
                            listener: (context, state) {
                              debugPrint("STATE_STATUS--->${state.apiStatus}");
                              if (state.apiStatus == ApiStatus.success) {
                                /*ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  state.message!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )));*/
                                /*Lottie.asset(
                                  'assets/animations/success_lottie.json',
                                  width: 150,
                                  height: 150,
                                  repeat: false,
                                );*/
                                _showSuccessDialog();
                                Future.delayed(
                                  const Duration(milliseconds: 2500),
                                      () {
                                    if (!mounted) return;
                                    context.go(AppPages.PDFVIEW,
                                        extra: state.estimationResponseModel);
                                  },
                                );
                              }
                            },
                            builder: (context, state) {
                              return AppWidgets.customMobileButton(
                                size: size,
                                func: () {
                                  if (state.selectedProductList!.isNotEmpty) {
                                    debugPrint(
                                        "Mobile No-->${mobileNoController.text}");
                                    SharedPreferencesHelper.saveString(
                                        AppConstants.MOBILE_NO,
                                        mobileNoController.text.toString());
                                    if (state.estimationNumber != null) {
                                      /* if (state.customerData?.customerCode == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Please select customer")),
                                  );
                                } else*/
                                      if (mobileNoController.text.toString() == "") {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content:
                                              Text("Please add a mobile no.")),
                                        );
                                      } else if (mobileNoController.text.length <
                                          10) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Please enter a valid mobile no.")),
                                        );
                                      } else if (state.salesPersonId == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Please select a sales person")),
                                        );
                                      } else {
                                        context
                                            .read<EstimationBloc>()
                                            .add(const SendEstimateData());
                                      }
                                    }

                                    /*context
                                        .read<EstimationBloc>()
                                        .add(const SendEstimateData());*/
                                    //context.go(AppPages.ESTIMATION);

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Please add product")),
                                    );
                                  }
                                },
                                btnName: "Submit",
                                isLoading: state.apiStatus == ApiStatus.loading
                                    ? true
                                    : false,
                                color: Colors.white,
                                textColor: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
                              );
                            },
                          ),
                        ),
                      ),
                      Gap(size.width * 0.01),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          top: AppDimensions.getResponsiveHeight(context) * .02,
        ),
        child: FloatingActionButton.small(
          backgroundColor: AppColors.LOGO_BACKGROUND_BLUE_COLOR,
          onPressed: () {
            context.read<EstimationBloc>().add(LogoutEvent());
            context.read<LegalEntityBloc>().add(ClearStateEvent());
            Future.delayed(Duration(milliseconds: 500),() {
              if (mounted) {
                context.go(
                  // AppPages.LOGIN,
                  AppPages.STORE_LIST,
                );
              }
            });
            /*SharedPreferencesHelper.clear().then(
              (value) {
                if (mounted) {
                  context.go(
                    // AppPages.LOGIN,
                    AppPages.STORE_LIST
                  );
                }
              },
            );*/
          },
          child: Icon(Icons.home,color: Colors.white,),//SvgPicture.asset("assets/images/logout.svg"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Future _showSuccessDialog() {
    var size = MediaQuery.sizeOf(context);
    return showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (context) {
        return Lottie.asset(
          'assets/lottie/success_lottie.json',
          width: size.width * 0.4,
          height: size.height * 0.4,
          // height: 150,
          repeat: false,
        );
      },
    );
  }
}
