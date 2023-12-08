import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../Controllers/ProductController/all_products_controller.dart';
import '../Pages/ProductsPage/ViewProductsPage.dart';
import '/Config/app_format.dart';
import '/Config/utils.dart';
import '/Controllers/DashboardController/dashboardController.dart';
import '/Pages/Notifications/notifications.dart';
import '/Pages/Profile_View/profile_view.dart';
import '/Services/storage_services.dart';
import '/Theme/colors.dart';

class CurvedContainer extends StatefulWidget {
  @override
  State<CurvedContainer> createState() => _CurvedContainerState();
}

class _CurvedContainerState extends State<CurvedContainer> {
  DashboardController dashBoardCtrl = Get.find<DashboardController>();
  TextEditingController controller = TextEditingController();
  AllProductsController allProdCtrlObj = Get.find<AllProductsController>();
  bool isContainerVisible = false;

  ///Date time range picker
  Future<void> _showDateRangePicker() async {
    await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      type: OmniDateTimePickerType.dateAndTime,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    ).then((List<DateTime>? dateTimeList) {
      if (dateTimeList == null) return;
      dashBoardCtrl.startDateCtrl.text =
          AppFormat.dateYYYYMMDDHHMM24(dateTimeList[0]);
      dashBoardCtrl.startDate = dateTimeList[0];
      dashBoardCtrl.endDateCtrl.text =
          AppFormat.dateYYYYMMDDHHMM24(dateTimeList[1]);
      dashBoardCtrl.endDate = dateTimeList[1];
      showProgress();
      dashBoardCtrl.fetchDashboardData();
      dashBoardCtrl.update();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    allProdCtrlObj.fetchAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: _MyClipper(),
      child: Stack(
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          //height: 150,
                          width: MediaQuery.of(context).size.width * 0.75,
                          // width: isPortrait ? 200 : 300,
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'searchItem'.tr,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.background,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onChanged: (value) {
                              allProdCtrlObj.searchedProducts = allProdCtrlObj
                                  .productModelObjs
                                  .where((element) =>
                                      element.sku!.contains(value) ||
                                      element.name!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                              setState(() {
                                isContainerVisible = !isContainerVisible;
                              });
                            },
                          )),
                      GestureDetector(
                        onTap: () {
                          _showDateRangePicker();
                        },
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: kWhiteColor,
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => Notifications());
                        },
                        child: Icon(
                          Icons.notification_add_outlined,
                          color: kWhiteColor,
                        ),
                      ),
                      SizedBox(width: 5)
                      // Icon(
                      //   Icons.add,
                      //   color: kWhiteColor,
                      // )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ProfileView());
                    },
                    child: Row(
                      children: [
                        // ClipRect(
                        //   child: CircleAvatar(
                        //     backgroundColor: kWhiteColor,
                        //     radius: 32,
                        //   ),
                        // ),

                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              AppStorage.getLoggedUserData()
                                      ?.staffUser
                                      .media
                                      ?.displayUrl ??
                                  ''),
                          // child: Image.network(
                          //   AppStorage.getLoggedUserData()
                          //           ?.staffUser
                          //           .media
                          //           ?.displayUrl ??
                          //       "",
                          //   // height: 100,
                          //   // width: 100,
                          // ),
                        ),
                        // Container(
                        //   height: 35,
                        //   width: 100,
                        //   decoration: BoxDecoration(shape: BoxShape.circle),
                        //   child: ClipOval(
                        //     child: FadedScaleAnimation(
                        //       CachedNetworkImage(
                        //         imageUrl:
                        //             '${AppStorage.getLoggedUserData()?.staffUser.media?.displayUrl ?? ''}',
                        //       ),
                        //       durationInMilliseconds: 400,
                        //     ),
                        //     // CachedNetworkImage(
                        //     //   imageUrl: AppStorage.getLoggedUserData()
                        //     //           ?.staffUser
                        //     //           .media
                        //     //           ?.fileName ??
                        //     //       "",
                        //     //   imageBuilder: (context, imageProvider) => Container(
                        //     //     height: MediaQuery.of(context).size.height * 0.3,
                        //     //     width: MediaQuery.of(context).size.width * 0.3,
                        //     //     decoration: BoxDecoration(
                        //     //       image: DecorationImage(
                        //     //         image: imageProvider,
                        //     //         fit: BoxFit.cover,
                        //     //       ),
                        //     //     ),
                        //     //   ),
                        //     //   placeholder: (context, url) =>
                        //     //       progressIndicator(width: 100, height: 100),
                        //     //   errorWidget: (context, url, error) => Icon(Icons.error),
                        //     // ),
                        //   ),
                        // ),
                        SizedBox(width: 15),
                        Text(
                          '${AppStorage.getLoggedUserData()?.staffUser.firstName ?? ''} ${AppStorage.getLoggedUserData()?.staffUser.lastName ?? ''}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: kWhiteColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          isContainerVisible
              ? Positioned(
                  top: size.height * 0.11,
                  left: size.width * 0.05,
                  child: Container(
                    width: size.width * 0.7,
                    height: size.height * 0.15,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Expanded(
                      child: GetBuilder(
                        builder: (AllProductsController allProdCtrlObj) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              await allProdCtrlObj.fetchAllProducts();
                            },
                            child: (allProdCtrlObj.listProductsModel == null)
                                ? progressIndicator()
                                : ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 100),
                                    itemCount:
                                        allProdCtrlObj.searchedProducts.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => ViewProductsPage(
                                              isView: true,
                                              productModelObjs: allProdCtrlObj
                                                  .searchedProducts[index],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // SKU
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        '${allProdCtrlObj.searchedProducts[index].sku}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),

                                                    // Product Name
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        '${allProdCtrlObj.searchedProducts[index].name}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: 10),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                      ),
                                                    ),

                                                    // Price
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        double.parse(
                                                              '${allProdCtrlObj.searchedProducts[index].productVariations?.first.variations?.first.sellPriceIncTax ?? '0.00'}',
                                                            ).toStringAsFixed(
                                                                2) +
                                                            ' /-',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),

                                                    // Stock
                                                    Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                        child: Text(
                                                          AppFormat
                                                                  .doubleToStringUpTo2(
                                                                '${double.parse(allProdCtrlObj.checkProductStockLocationBased(locationId: AppStorage.getBusinessDetailsData()?.businessData?.locations.first.id, index: index) ?? '0.00') / double.parse(allProdCtrlObj.checkUnitsActualBaseMultiplier(unitName: allProdCtrlObj.unitListStatus[index]))}',
                                                              ) ??
                                                              '0.00',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),

                                                    // Unit
                                                    Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                        child: Text(
                                                          '${allProdCtrlObj.checkUnitsShortName(unitId: allProdCtrlObj.searchedProducts[index].unitId) ?? ''}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(thickness: 2, height: 10),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class _MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
