import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/local/shared_preferences_helper.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../router/app_pages.dart';
import '../../splash_screen/data/model/store_model.dart';
import '../../splash_screen/presentation/bloc/store_bloc.dart';

class StoreScreen extends StatefulWidget {
  // final List<WarehouseList> warehouseList;
  const StoreScreen({
    super.key,
    /*required this.warehouseList*/
  });

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  WarehouseList? _selectedWarehouseValue;

  @override
  void initState() {
    super.initState();
    context.read<StoreBloc>().add(FetchStoreEvent());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: AppColors.APP_BACKGROUND_COLOR,
          height: size.height,
          child: Stack(
            children: [
              AppWidgets().buildTopContainer(size),
              Positioned(
                top: AppDimensions.getResponsiveHeight(context) * 0.32,
                //300,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        AppDimensions.getResponsiveWidth(context) * 0.05,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          AppDimensions.getResponsiveHeight(context) * 0.05,
                      horizontal:
                          AppDimensions.getResponsiveWidth(context) * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          offset: const Offset(0.5, 0.5),
                          blurRadius: 1.3,
                          spreadRadius: 1.2,
                        ),
                      ],
                    ),
                    child: BlocConsumer<StoreBloc, StoreState>(
                      listenWhen: (previous, current) => current is StoreLoaded,
                      listener: (context, state) {
                        if (state is StoreLoaded) {
                          final storeModel = state.storeModel!.warehouse;
                          context.go(AppPages.STORE_LIST, extra: storeModel);
                        }
                      },
                      builder: (context, state) {
                        if (state is StoreLoading) {
                          return Center(
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
                          );
                        } else if (state is StoreLoaded) {
                          return Column(
                            spacing:
                                AppDimensions.getResponsiveHeight(context) *
                                    0.02,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.getResponsiveWidth(
                                          context) *
                                      0.05,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.5),
                                      width: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<WarehouseList>(
                                    hint: const Text(
                                      'Select Warehouse',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    value: _selectedWarehouseValue,
                                    items: state.storeModel!.warehouse!
                                        .map((warehouse) {
                                      return DropdownMenuItem<WarehouseList>(
                                        value: warehouse,
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            warehouse.whCode!,
                                            // Assuming userName is a property of WarehouseList
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (WarehouseList? newValue) {
                                      if (newValue != null) {
                                        SharedPreferencesHelper.saveString(
                                            AppConstants.USER_NAME,
                                            newValue.username!);
                                        SharedPreferencesHelper.saveString(
                                            AppConstants.WAREHOUSE,
                                            newValue.whCode!);
                                        SharedPreferencesHelper.saveString(
                                            AppConstants.LEGAL_ENTITY,
                                            newValue.leCode!);
                                        setState(() {
                                          _selectedWarehouseValue = newValue;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.getResponsiveWidth(
                                          context) *
                                      0.15,
                                ),
                                child: AppWidgets.customMobileButton(
                                  size: size,
                                  btnName: 'Go',
                                  func: () => _selectedWarehouseValue!=null?context.go(
                                    AppPages.SEARCH_PRODUCT,
                                  ):ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a store'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
