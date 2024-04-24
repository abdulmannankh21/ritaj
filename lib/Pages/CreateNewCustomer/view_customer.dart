import 'package:flutter/material.dart';
import 'package:foodies/Pages/CreateNewCustomer/showCustomerDetails.dart';
import 'package:get/get.dart';

import '../../Components/custom_circular_button.dart';
import '../../Config/utils.dart';
import '../../Controllers/AllSalesController/allSalesController.dart';
import '../../Controllers/ContactController/ContactController.dart';
import '../../Theme/colors.dart';
import '../CreateOrder/createOrderPage.dart';
import '../Receipts/reciepts_individual.dart';
import '../Return/saleReturn.dart';
import '../SalesView/SalesViewDetails/SalesViewTile.dart';
import '../SalesView/SalesViewDetails/ViewSalesPage.dart';
import '../SalesView/SalesViewDetails/individual_sale_view.dart';

class ViewCustomer extends StatefulWidget {
  final String id;
  final String? customerName;
  final String? businessSupplyName;
  final bool isSalesReturn;

  const ViewCustomer({
    super.key,
    required this.id,
    required this.customerName,
    required this.businessSupplyName,
    this.isSalesReturn = false,
  });

  @override
  State<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  ContactController contactCtrlObj = Get.find<ContactController>();

  AllSalesController allSalesCtrl = Get.find<AllSalesController>();
  ScrollController? _pastOrdersScrollCtrl;

  @override
  void initState() {
    // Get.find<AllProductsController>().fetchAllProducts();
    allSalesCtrl.callFirstOrderPage();
    scrollControllerLis();
    super.initState();
  }

  void dispose() {
    contactCtrlObj.clearAllContactCtrl();
    contactCtrlObj.getSpecificContactModel = null;
    _pastOrdersScrollCtrl?.removeListener(scrollControllerLis);
    super.dispose();
  }

  scrollControllerLis() {
    _pastOrdersScrollCtrl = ScrollController();
    if (_pastOrdersScrollCtrl != null) {
      _pastOrdersScrollCtrl?.addListener(() {
        double maxScroll = _pastOrdersScrollCtrl!.position.maxScrollExtent;
        double currentScroll = _pastOrdersScrollCtrl!.position.pixels;
        double delta = MediaQuery.of(context).size.height * 0.75;

        if ((maxScroll - currentScroll) <= delta) {
          // if (maxScroll == currentScroll) {
          Get.find<AllSalesController>().loadMoreSaleOrders();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${widget.businessSupplyName ?? contactCtrlObj.businessNameCtrl.text}',
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // GetBuilder<ContactController>(
              //     builder: (ContactController contactCtrl) {
              //       return CustomButton(
              //         onTap: () {
              //             // if (contactCtrl.isForEdit == true) {
              //             //   contactCtrl.isForEdit = false;
              //             //   contactCtrl.update();
              //             // } else if (contactCtrl.isForEdit == false) {
              //             //   contactCtrl.isForEdit = true;
              //             //   contactCtrl.update();
              //             // }
              //         },
              //         title: Text(
              //           'Sales',
              //           style: TextStyle(color: kWhiteColor),
              //         ),
              //       );
              //     }),
              GetBuilder<ContactController>(
                  builder: (ContactController contactCtrl) {
                return CustomButton(
                  onTap: () {
                    Get.to(() => individualReceipts());
                    contactCtrlObj.update();
                  },
                  title: Text(
                    'Receipt',
                    style: TextStyle(color: kWhiteColor),
                  ),
                );
              }),
              GetBuilder<ContactController>(
                  builder: (ContactController contactCtrl) {
                return CustomButton(
                  onTap: () {
                    Get.to(() => CreateOrderPage());
                  },
                  title: Text(
                    'Order',
                    style: TextStyle(color: kWhiteColor),
                  ),
                );
              }),
              GetBuilder<ContactController>(
                  builder: (ContactController contactCtrl) {
                return CustomButton(
                  onTap: () {
                    Get.to(() => ShowCustomerDetails(contactApi: widget.id));
                  },
                  title: Text(
                    'profile'.tr,
                    style: TextStyle(color: kWhiteColor),
                  ),
                );
              }),
              GetBuilder<ContactController>(
                  builder: (ContactController contactCtrl) {
                return CustomButton(
                  onTap: () {
                    Get.to(() => IndividualSalesView(isSalesReturn: true));
                    // Get.to(ShowCustomerDetails(contactApi: widget.id));
                  },
                  title: Text(
                    'return'.tr,
                    style: TextStyle(color: kWhiteColor),
                  ),
                );
              }),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: GetX(
                    builder: (AllSalesController allSalesCtrlObj) {
                      return allSalesCtrlObj.isFirstLoadRunning.isTrue
                          ? progressIndicator()
                          : SizedBox();
                    },
                  ),
                ),
                GetBuilder(
                  builder: (AllSalesController allSalesCtrlObj) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await allSalesCtrlObj.callFirstOrderPage();
                      },
                      child: Scrollbar(
                        controller: _pastOrdersScrollCtrl,
                        child: ListView.builder(
                          controller: _pastOrdersScrollCtrl,
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: allSalesCtrlObj
                                  .allSaleOrders?.saleOrdersData.length ??
                              0,
                          itemBuilder: (context, index) {
                            final saleOrder = allSalesCtrlObj
                                .allSaleOrders!.saleOrdersData[index];
                            if (saleOrder.contact?.name ==
                                widget.customerName) {
                              return IntrinsicHeight(
                                child: GestureDetector(
                                    onTap: () {
                                      if (widget.isSalesReturn) {
                                        Get.to(SalesReturn(
                                          id: '${allSalesCtrlObj.allSaleOrders!.saleOrdersData[index].id}',
                                        ));
                                      } else {
                                        Get.to(
                                          () => SalesViewDetailsPage(
                                            salesOrderData: allSalesCtrlObj
                                                .allSaleOrders!
                                                .saleOrdersData[index],
                                          ),
                                        );
                                      }
                                    },
                                    child:
                                    SalesViewTile(
                                      pastOrder: allSalesCtrlObj
                                          .allSaleOrders!.saleOrdersData[index],
                                    )),
                              );
                            } else {
                              print(contactCtrlObj.nameCtrl.text);
                              print(widget.customerName);
                              print(saleOrder.contact!.name);
                              return SizedBox();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: GetX(builder: (AllSalesController orderCtrlObj) {
                    return orderCtrlObj.isLoadMoreRunning.isTrue
                        ? progressIndicator()
                        : SizedBox();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
