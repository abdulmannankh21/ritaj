import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/Controllers/ProductController/all_products_controller.dart';
import '../../../Config/utils.dart';
import '../../../Controllers/StockTransferController/stockTransferController.dart';
import '../../../Pages/Stocks/ViewStockTransfer/viewStockTransferTile.dart';
import '../../../Services/storage_services.dart';
import 'createStockTransfer.dart';

class ViewStockTransfer extends StatelessWidget {
  const ViewStockTransfer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        onPressed: () {
          Get.to(() => CreateStockTransfer());
        },
      ),
      body: GetBuilder<StockTransferController>(
        initState: (_) {
          Get.find<StockTransferController>()
            ..fetchStatusList()
            ..fetchStockTransfersList();
          if (Get.find<AllProductsController>().unitListModel == null)
            Get.find<AllProductsController>().fetchUnitList();
        },
        builder: (StockTransferController stockTransferCtrlObj) {
          if (stockTransferCtrlObj.viewStockTransferMoodel != null) {
            return RefreshIndicator(
              onRefresh: () async {
                await stockTransferCtrlObj.fetchStockTransfersList();
              },
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: stockTransferCtrlObj
                          .viewStockTransferMoodel?.data.length ??
                      0,
                  itemBuilder: (context, index) {
                    return (stockTransferCtrlObj.viewStockTransferMoodel
                                    ?.data[index].locationTo ==
                                AppStorage.getBusinessDetailsData()
                                    ?.businessData
                                    ?.locations
                                    .first
                                    .name ||
                            stockTransferCtrlObj.viewStockTransferMoodel
                                    ?.data[index].locationFrom ==
                                AppStorage.getBusinessDetailsData()
                                    ?.businessData
                                    ?.locations
                                    .first
                                    .name)
                        ? IntrinsicHeight(
                            child: ViwStockTile(
                              stockTransferData: stockTransferCtrlObj
                                  .viewStockTransferMoodel?.data[index],
                            ),
                          )
                        : SizedBox();
                  }),
            );
          } else
            return progressIndicator();
        },
      ),
    );
  }
}
