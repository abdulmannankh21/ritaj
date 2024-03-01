import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Config/utils.dart';
import '../../../Controllers/StockTransferController/stockTransferController.dart';
import '../../../Pages/Stocks/ViewStockAdjustment/viewStockAdjustmentTile.dart';
import 'createStockAdjustment.dart';

class ViewStockAdjustment extends StatelessWidget {
  const ViewStockAdjustment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        onPressed: () {
          Get.to(() => CreateStockAdjustment());
        },
      ),
      body: GetBuilder<StockTransferController>(
        initState: (_) {
          Get.find<StockTransferController>().fetchStockAdjustmentList();
        },
        builder: (StockTransferController stockAdjustmentCtrlObj) {
          if (stockAdjustmentCtrlObj.viewStockAdjustmentModel != null) {
            return RefreshIndicator(
              onRefresh: () async {
                await stockAdjustmentCtrlObj.fetchStockAdjustmentList();
              },
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: stockAdjustmentCtrlObj
                          .viewStockAdjustmentModel?.data.length ??
                      0,
                  itemBuilder: (context, index) {
                    return IntrinsicHeight(
                      child: ViwStockAdjustmentTile(
                        index: index,
                        stockAdjustmentCtrlObj: stockAdjustmentCtrlObj,
                      ),
                    );
                  }),
            );
          } else
            return progressIndicator();
        },
      ),
    );
  }
}
