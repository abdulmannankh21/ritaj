import 'package:get/get.dart';

import '/Controllers/ProductController/all_products_controller.dart';
import '../../Models/order_type_model/SaleOrderModel.dart';
import '../../Pages/Orders/Controller/OrderController.dart';

class ReceiptsController extends GetxController {
  String totalAmount = '0';
  SaleOrderModel? order;

  void markUnMarkOrder(SaleOrderDataModel orderSellLine) {
    // --------------------- is item cooked or not condition with popup
    // if (!isItCooked(index: index)) {
    //   showToast('Item is not Cooked yet!');
    //   return;
    // }

    orderSellLine.isSelected = !orderSellLine.isSelected;

    if (orderSellLine.isSelected) {
      totalAmount =
          '${double.parse(totalAmount) + Get.find<OrderController>().calculateRemainingAmountToPay(orderSellLine)}';
      listSaleOrderDataModel.add(orderSellLine);
    } else if (!orderSellLine.isSelected) {
      totalAmount =
          '${double.parse(totalAmount) - Get.find<OrderController>().calculateRemainingAmountToPay(orderSellLine)}';
      listSaleOrderDataModel.remove(orderSellLine);
    }

    print('List Sale Order Data Model => $listSaleOrderDataModel');
    print('Is Receipt Selected => ${orderSellLine.isSelected}');
    print('Total Amount base on selection => $totalAmount');

    Get.find<AllProductsController>().receiptsFinalPayment = totalAmount;
    update();
  }

  SaleOrderDataModel? singleOrderData;
  List<SaleOrderDataModel> listSaleOrderDataModel = [];

  markUnMarkAllOrder() {
    // listSaleOrderDataModel
    //     ?.forEach((element) => element.isSelected = !element.isSelected);
    if (listSaleOrderDataModel.isNotEmpty) {
      for (int i = 0; i < listSaleOrderDataModel.length; i++) {
        listSaleOrderDataModel[i].isSelected =
            !listSaleOrderDataModel[i].isSelected;
        totalAmount =
            '${double.parse(totalAmount) + double.parse(listSaleOrderDataModel[i].finalTotal ?? '0')}';
        print(totalAmount);
      }
    }

    print(totalAmount);
    update();
  }
}
