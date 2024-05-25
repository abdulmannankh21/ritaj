import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/Components/custom_circular_button.dart';
import '/Components/p4Headings.dart';
import '/Components/textfield.dart';
import '/Config/utils.dart';
import '/Controllers/ContactController/ContactController.dart';
import '/Controllers/ProductController/all_products_controller.dart';
import '/Controllers/Tax Controller/TaxController.dart';
import '/Models/order_type_model/SaleOrderModel.dart';
import '/Pages/CreateOrder/selectionDialogue.dart';
import '/Pages/checkout/check_out.dart';
import '/Services/storage_services.dart';
import '/Theme/colors.dart';
import '/Theme/style.dart';
import '/const/dimensions.dart';
import '../../Config/app_format.dart';
import '../../Controllers/ProductController/PaymentController.dart';
import '../SalesView/discount.dart';

class CreateOrderPage extends StatefulWidget {
  final SaleOrderDataModel? salesOrderData;
  final bool isUpdate;
  CreateOrderPage({Key? key, this.salesOrderData, this.isUpdate = false})
      : super(key: key);

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  ContactController contactCtrlObjj = Get.find<ContactController>();
  final TaxController taxCtrlObj = Get.find<TaxController>();

  bool cannotSupply = false;
  AllProductsController allProdCtrlObj = Get.find<AllProductsController>();

  @override
  void initState() {
    allProdCtrlObj.finalTotal = 0.00;
    if (!widget.isUpdate) {
      allProdCtrlObj
        ..nestedist.clear()
        ..productQuantityCtrl.clear()
        ..selectedProducts.clear()
        ..selectedUnitsList.clear()
        ..unitListStatusIds.clear()
        ..unitListStatus.clear()
        ..selectedUnitsNames.clear()
        ..fetchAllProducts();
      Get.find<PaymentController>().paymentWidgetList.clear();
    }
    if (widget.isUpdate)
      allProdCtrlObj.finalTotal =
          double.parse('${widget.salesOrderData?.finalTotal ?? '0.00'}');

    allProdCtrlObj.addOrderedItemsQty(salesOrderData: widget.salesOrderData);
    taxCtrlObj.fetchListTax();

    super.initState();
  }

  void dispose() {
    allProdCtrlObj
      ..finalTotal = 0.00
      ..productsAmount.clear()
      ..selectedQuantityList.clear()
      ..selectedUnitsList.clear()
      ..selectedProducts.clear()
      ..productQuantityCtrl.clear()
      ..listProductsModel = null;
    super.dispose();
  }

  String? unitStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create_order'.tr),
        leading: AppStyles.backButton(
          onTap: () => Get.back(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('customer_name'.tr + ':'),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      '${contactCtrlObjj.nameCtrl.text} (${contactCtrlObjj.contactId})',
                      overflow: TextOverflow.ellipsis,
                      style: appBarHeaderStyle,
                    ),
                    // Expanded(
                    //   child: CheckboxListTile(
                    //       value: cannotSupply,
                    //       onChanged: (bool? value) {
                    //         setState(() {
                    //           cannotSupply = value!;
                    //           //customerVisitsCtrlObj.update();
                    //         });
                    //       },
                    //       controlAffinity: ListTileControlAffinity.leading,
                    //       title: Text(
                    //         'Cannot Supply',
                    //         style: TextStyle(color: blackColor),
                    //       )),
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                Product4Headings(
                  txt1: 'product_name'.tr,
                  txt2: 'unit'.tr,
                  txt3: 'stock'.tr,
                  txt4: 'qty'.tr,
                ),
                // SearchProducts(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.67,
                  child: GetBuilder<AllProductsController>(
                      builder: (AllProductsController allProdCtrlObj) {
                    if (allProdCtrlObj.listProductsModel == null) {
                      return progressIndicator();
                    }
                    return ListView.builder(
                        padding: EdgeInsetsDirectional.only(
                            top: 5, bottom: 5, start: 10, end: 10),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: allProdCtrlObj.productModelObjs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: 5,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            color: index.isEven
                                ? kWhiteColor
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //name
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${allProdCtrlObj.productModelObjs[index].name} ',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),

                                    // Unit
                                    if (allProdCtrlObj.nestedist.isNotEmpty)
                                      unitSelectionWidget(index),

                                    // Stock
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          allProdCtrlObj.calculatingStock(
                                              index: index),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),

                                    //Quantity
                                    if (allProdCtrlObj
                                        .productQuantityCtrl.isNotEmpty)
                                      Expanded(
                                        flex: 1,
                                        child: AppFormField(
                                            controller: allProdCtrlObj
                                                .productQuantityCtrl[index],
                                            padding: EdgeInsets.all(0),
                                            isOutlineBorder: false,
                                            isColor: index.isEven
                                                ? kWhiteColor
                                                : Colors.transparent,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true,
                                                    signed: false),
                                            inputFormatterList: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+(?:\.\d+)?$')),
                                            ],
                                            // onEditingComp: (){
                                            //
                                            // },
                                            onChanged: (value) {
                                              calculateAmountOnChangeQuantity(
                                                  index);

                                              // if (double.parse(
                                              //       '${allProdCtrlObj.productModelObjs[index].productVariationsDetails?.qtyAvailable ?? 0.00}',
                                              //     ) <=
                                              //     0.00) {
                                              //   if (AppStorage
                                              //               .getBusinessDetailsData()
                                              //           ?.businessData
                                              //           ?.posSettings
                                              //           ?.allowOverselling ==
                                              //       1) {
                                              //     print('in 1st allow if');
                                              //     allProdCtrlObj.finalTotal =
                                              //         0.00;
                                              //     allProdCtrlObj.productsAmount[
                                              //             index] =
                                              //         // created function to calculate the value Qty * (price * unit)
                                              //         allProdCtrlObj
                                              //             .calculatingProductAmountForUnit(
                                              //                 index: index);
                                              //     allProdCtrlObj
                                              //         .calculateFinalAmount();
                                              //     debugPrint(
                                              //         'Product Amount After all Calculation --->> ${allProdCtrlObj.productsAmount[index]}');
                                              //   } else {
                                              //     allProdCtrlObj
                                              //         .productQuantityCtrl[
                                              //             index]
                                              //         .clear();
                                              //
                                              //     showToast(
                                              //         'Stock not available');
                                              //   }
                                              // } else if (double.parse(allProdCtrlObj
                                              //             .productModelObjs[
                                              //                 index]
                                              //             .productVariationsDetails
                                              //             ?.qtyAvailable ??
                                              //         '0.00') >
                                              //     0.00) {
                                              //   print('in third if');
                                              //   allProdCtrlObj.finalTotal =
                                              //       0.00;
                                              //   allProdCtrlObj
                                              //           .productsAmount[index] =
                                              //       // created function to calculate the value Qty * (price * unit)
                                              //       allProdCtrlObj
                                              //           .calculatingProductAmountForUnit(
                                              //               index: index);
                                              //
                                              //   debugPrint(
                                              //       'Product Amount After all Calculation --->> ${allProdCtrlObj.productsAmount[index]}');
                                              //   allProdCtrlObj
                                              //       .calculateFinalAmount();
                                              // }
                                              // allProdCtrlObj.update();
                                            }),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  }),
                ),

                Center(
                  child: Text(
                    '${'total'.tr} (AED) = ${AppFormat.doubleToStringUpTo2("${double.parse(allProdCtrlObj.getPayableFinalTotalAmount()) + orderTaxAmount}")}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      title: Text(
                        'discount'.tr,
                        style: TextStyle(color: kWhiteColor),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            //title: title != null ? Text(title) : null,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 0),
                            content: Discount(),
                          ),
                        );
                      },
                    ),
                    CustomButton(
                        onTap: _isProductQuantityAdded
                            ? () {
                                allProdCtrlObj.isDirectCheckout = true;
                                allProdCtrlObj.update();
                                Get.dialog(Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall)),
                                  insetPadding: EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  child: SelectionDialogue(),
                                ));
                              }
                            : null,
                        title: Text(
                          'credit'.tr,
                          style: TextStyle(color: kWhiteColor),
                        ),
                        bgColor: Theme.of(context).colorScheme.primary),
                    CustomButton(
                        onTap: _isProductQuantityAdded
                            ? () async {
                                //showProgress();
                                allProdCtrlObj.isDirectCheckout = false;
                                allProdCtrlObj.update();
                                // Get.find<PaymentController>()
                                //     .paymentWidgetList[0]
                                //     .amountCtrl
                                //     .clear();
                                // Get.find<PaymentController>()
                                //         .paymentWidgetList[0]
                                //         .amountCtrl
                                //         .text =
                                //     '${AppFormat.doubleToStringUpTo2('${allProdCtrlObj.finalTotal}')}';
                                // Get.find<PaymentController>().update();
                                bool? isDone = await Get.to(() => CheckOutPage(
                                      isReceipt: false,
                                      Amount: "${orderTaxAmount}",
                                    ));

                                if (isDone != null && isDone) {
                                  Get.back(result: true);
                                }

                                // allProdCtrlObj.orderCreate();
                              }
                            : null,
                        title: Text(
                          'pay'.tr,
                          style: TextStyle(color: kWhiteColor),
                        ),
                        bgColor: Theme.of(context).colorScheme.primary)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget unitSelectionWidget(int index) {
    try {
      // return SizedBox();
      return Container(
        // height:
        //     MediaQuery.of(context).size.height *
        //         0.06,
        //width: MediaQuery.of(context).size.width,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Select',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                )),
            items: allProdCtrlObj.nestedist[index] //unitStatusList()
                .map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    items,
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              );
            }).toList(),
            value: allProdCtrlObj.unitListStatus[index],
            dropdownWidth: MediaQuery.of(context).size.width * 0.2,
            dropdownDecoration:
                BoxDecoration(borderRadius: BorderRadius.circular(5)),
            dropdownMaxHeight: MediaQuery.of(context).size.height * 0.7,
            dropdownPadding: EdgeInsets.only(left: 5),
            buttonPadding: EdgeInsets.only(left: 10, right: 10),
            onChanged: (String? value) {
              setState(() {
                allProdCtrlObj.unitListStatus[index] = value!;

                allProdCtrlObj.unitListStatusIds[index] =
                    allProdCtrlObj.checkSelectedUnitsIds(unitName: value);

                allProdCtrlObj.productsAmount[index] = double.parse(
                    allProdCtrlObj.calculatingProductAmountForUnit(
                        index: index));

                // debugPrint(allProdCtrlObj
                //     .totalAmount[index]);
                // debugPrint(allProdCtrlObj
                //     .unitListStatus[index]);

                allProdCtrlObj.calculateFinalAmount();
                allProdCtrlObj.update();
              });
            },
            // buttonHeight: 40,
            buttonWidth: MediaQuery.of(context).size.width * 0.27,
            // buttonDecoration: BoxDecoration(
            //     color: kWhiteColor,
            //     border: Border.all(
            //         width: 1,
            //         color: Theme.of(context)
            //             .colorScheme
            //             .primary),
            //     borderRadius:
            //         BorderRadius.circular(15)),
            // itemHeight: 40,
            //icon: SizedBox(),
            itemPadding: EdgeInsets.zero,
            itemHighlightColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Unit Change Dropdown Error => $e');
      return SizedBox();
    }
  }

  double get orderTaxAmount {
    double itemsTax = 0.0;
    try {
      itemsTax += double.parse(allProdCtrlObj.getPayableFinalTotalAmount()) /
          100 *
          double.parse(
              taxCtrlObj.listTaxModel?.data?[0].amount.toString() ?? '0');

      print('Order tax ;;;;${itemsTax}');
    } catch (e) {
      logger.e('Error to calculate total tax amount => $e');
    }
    return double.parse(AppFormat.doubleToStringUpTo2('${itemsTax}')!);
  }

  calculateAmountOnChangeQuantity(int index) {
    if (double.parse(
          '${allProdCtrlObj.productModelObjs[index].productVariationsDetails?.qtyAvailable ?? 0.00}',
        ) <=
        0.00) {
      if (AppStorage.getBusinessDetailsData()
              ?.businessData
              ?.posSettings
              ?.allowOverselling ==
          1) {
        print('in 1st allow if');
        allProdCtrlObj.finalTotal = 0.00;
        allProdCtrlObj.productsAmount[index] =
            // created function to calculate the value Qty * (price * unit)
            double.parse(
                allProdCtrlObj.calculatingProductAmountForUnit(index: index));
        allProdCtrlObj.calculateFinalAmount();
        debugPrint(
            'Product Amount After all Calculation --->> ${allProdCtrlObj.productsAmount[index]}');
      } else {
        allProdCtrlObj.productQuantityCtrl[index].clear();

        showToast('Stock not available');
      }
    } else if (double.parse(allProdCtrlObj.productModelObjs[index]
                .productVariationsDetails?.qtyAvailable ??
            '0.00') >
        0.00) {
      print('in third if');
      allProdCtrlObj.finalTotal = 0.00;
      allProdCtrlObj.productsAmount[index] =
          // created function to calculate the value Qty * (price * unit)
          double.parse(
              allProdCtrlObj.calculatingProductAmountForUnit(index: index));

      debugPrint(
          'Product Amount After all Calculation --->> ${allProdCtrlObj.productsAmount[index]}');
      allProdCtrlObj.calculateFinalAmount();
    }
    allProdCtrlObj.update();
  }

  bool get _isProductQuantityAdded =>
      (allProdCtrlObj.productQuantityCtrl.any((element) {
        return element.text != '' && element.text != '0';
      }));
}
