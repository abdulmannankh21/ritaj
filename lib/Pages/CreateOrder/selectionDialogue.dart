import 'package:flutter/material.dart';
import 'package:foodies/Services/storage_services.dart';
import 'package:get/get.dart';

import '../../Controllers/AllSalesController/allSalesController.dart';
import '../../const/dimensions.dart';
import '../PrintDesign/invoice_print_screen.dart';
import '/Pages/Tabs/View/TabsPage.dart';
import '/Theme/colors.dart';
import '/Theme/style.dart';
import '../../Components/custom_circular_button.dart';
import '../../Config/utils.dart';
import '../../Controllers/ProductController/all_products_controller.dart';

class SelectionDialogue extends StatefulWidget {
  final Function()? callback;
  const SelectionDialogue({this.callback, Key? key}) : super(key: key);

  @override
  State<SelectionDialogue> createState() => _SelectionDialogueState();
}

class _SelectionDialogueState extends State<SelectionDialogue> {
  final AllProductsController allProdCtrlObj =
      Get.find<AllProductsController>();
  @override
  Widget build(BuildContext context) {
    print('Receipt Payment: ${allProdCtrlObj.receiptPayment}');
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.17,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'choose_options'.tr,
            style: appBarHeaderStyle,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                onTap: () async {
                  bool isActionCompleted = false;
                  showProgress(dismissible: false);
                  allProdCtrlObj.update();
                  if (allProdCtrlObj.receiptPayment) {
                    print('inside add receipt method call');
                    allProdCtrlObj.isPDFView = true;
                    // allProdCtrlObj.update();
                    isActionCompleted = await allProdCtrlObj.addReceipt();
                  } else if (allProdCtrlObj.isUpdate) {
                    print('->> for Update Order');
                    allProdCtrlObj.isPDFView = true;
                    allProdCtrlObj.addSelectedItemsInList();
                    allProdCtrlObj.updateOrder();
                  } else {
                    allProdCtrlObj.isPDFView = true;
                    allProdCtrlObj.addSelectedItemsInList();
                    print('->> for Create Order');
                    allProdCtrlObj.orderCreate();
                  }

                  if (isActionCompleted) {
                    Get.back(result: true);
                    if (widget.callback != null) {
                      widget.callback!();
                    }
                  }
                },
                title: Text(
                  'save'.tr,
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
              CustomButton(
                onTap: () async {
                  bool isActionCompleted = false;
                  showProgress(dismissible: false);
                  allProdCtrlObj.update();
                  if (allProdCtrlObj.receiptPayment) {
                    print('inside add receipt method call');
                    allProdCtrlObj.isPDFView = false;
                    allProdCtrlObj.receiptPayment = true;
                    isActionCompleted = await allProdCtrlObj.addReceipt();
                  } else if (allProdCtrlObj.isUpdate) {
                    print('->> for Update Order');
                    allProdCtrlObj.isPDFView = false;
                    allProdCtrlObj.addSelectedItemsInList();
                    allProdCtrlObj.updateOrder();
                  } else {
                    allProdCtrlObj.isPDFView = false;
                    allProdCtrlObj.addSelectedItemsInList();
                    print('->> for Create Order');
                    allProdCtrlObj.orderCreate();
                  }

                  if (isActionCompleted) {
                    Get.back(result: true);
                    if (widget.callback != null) {
                      widget.callback!();
                    }
                  }
                },
                title: Text(
                  'saveAndPrint'.tr,
                  style: TextStyle(color: kWhiteColor),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomerCopyDialogue extends StatefulWidget {
  final Function()? callback;
  const CustomerCopyDialogue({this.callback, Key? key}) : super(key: key);

  @override
  State<CustomerCopyDialogue> createState() => _CustomerCopyDialogueState();
}

class _CustomerCopyDialogueState extends State<CustomerCopyDialogue> {
  final AllProductsController allProdCtrlObj =
      Get.find<AllProductsController>();
  AllSalesController allSalesCtrl = Get.find<AllSalesController>();

  @override
  Widget build(BuildContext context) {
    print('Receipt Payment: ${allProdCtrlObj.receiptPayment}');
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.17,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'choose_options'.tr,
            style: appBarHeaderStyle,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                onTap: () async {
                  // bool isActionCompleted = false;
                  // showProgress(dismissible: false);
                  // allProdCtrlObj.update();
                  // if (allProdCtrlObj.receiptPayment) {
                  //   print('inside add receipt method call');
                  //   allProdCtrlObj.isPDFView = true;
                  //   // allProdCtrlObj.update();
                  //   isActionCompleted = await allProdCtrlObj.addReceipt();
                  // } else if (allProdCtrlObj.isUpdate) {
                  //   print('->> for Update Order');
                  //   allProdCtrlObj.isPDFView = true;
                  //   allProdCtrlObj.addSelectedItemsInList();
                  //   allProdCtrlObj.updateOrder();
                  // } else {
                  //   allProdCtrlObj.isPDFView = true;
                  //   allProdCtrlObj.addSelectedItemsInList();
                  //   print('->> for Create Order');
                  //   allProdCtrlObj.orderCreate();
                  // }
                  //
                  // if (isActionCompleted) {
                  //   Get.back(result: true);
                  //   if (widget.callback != null) {
                  //     widget.callback!();
                  //   }
                  // }
                  Get.offAll(() => TabsPage());
                },
                title: Text(
                  'Cancel',
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
              CustomButton(
                onTap: () async {
                  // AppStorage.setCutomerCopy(true);
                  await Get.dialog(Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(Dimensions.radiusSmall)),
                    insetPadding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: InVoicePrintScreen(isPrintCustomer: true,),
                  ));

                  // Get.offAll(() => TabsPage());
                  // Get.back();
                  // bool isActionCompleted = false;
                  // showProgress(dismissible: false);
                  // allProdCtrlObj.update();
                  // if (allProdCtrlObj.receiptPayment) {
                  //   print('inside add receipt method call');
                  //   allProdCtrlObj.isPDFView = false;
                  //   allProdCtrlObj.receiptPayment = true;
                  //   isActionCompleted = await allProdCtrlObj.addReceipt();
                  // }
                  // else
                  //   if (allProdCtrlObj.isUpdate) {
                  //   print('->> for Update Order');
                  //   allProdCtrlObj.isPDFView = false;
                  //   // allProdCtrlObj.addSelectedItemsInList();
                  //   allProdCtrlObj.updateOrder();
                  // } else {
                  //   allProdCtrlObj.isPDFView = false;
                  //   // allProdCtrlObj.addSelectedItemsInList();
                  //   print('->> for Create Order');
                  //   allProdCtrlObj.orderCreate();
                  // }
                  // Get.find<AllProductsController>().salesOrderModel =
                  //     allSalesCtrl.allSaleOrders?.saleOrdersData.first;
                  // print(allSalesCtrl.allSaleOrders?.saleOrdersData.last);
                  // Get.dialog(Dialog(
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //       BorderRadius.circular(Dimensions.radiusSmall)),
                  //   insetPadding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  //   child: InVoicePrintScreen(),
                  // ));

                  // Get.back();
                  // if (isActionCompleted) {
                  //   Get.back(result: true);
                  //   if (widget.callback != null) {
                  //     widget.callback!();
                  //   }
                  // }
                },
                title: Text(
                  'Print Customer Copy',
                  style: TextStyle(color: kWhiteColor),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
