import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/Components/OptionSelectionView.dart';
import '/Config/utils.dart';
import '/Controllers/Booking Controller/BookingController.dart';
import '/Controllers/ContactController/ContactController.dart';

class CustomerListView extends StatefulWidget {
  final ContactController contactCtrlObj;
  CustomerListView({Key? key, required this.contactCtrlObj}) : super(key: key);

  @override
  State<CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView> {
  final BookingController bookingCtrl = Get.find<BookingController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactController>(
        builder: (ContactController customerCtrlObj) {
      if (customerCtrlObj.customerContacts == null) return progressIndicator();

      return RefreshIndicator(
        onRefresh: () async {
          await customerCtrlObj.fetchCustomerInfo(1);
        },
        child: OptionSelectionView(
          itemCount:
              widget.contactCtrlObj.customerContacts?.contactDataList.length,
          itemBuilder: (context, index) {
            // ExpenseCategoriesListModel? _data1 =
            //     expCtrlObj.expenseCategoriesListModel.expenseCategories[index];
            // ExpenseCategoryDataModel? _data =
            //     expCtrlObj.expenseCategoryInfo?.expenseCategoriesData[index];
            // print(_data1);
            return OptionSelectionTile(
              onTap: () {
                customerCtrlObj.customerNameCtrl.text =
                    '${widget.contactCtrlObj.customerContacts?.contactDataList[index].name ?? ''} ${widget.contactCtrlObj.customerContacts?.contactDataList[index].contactId ?? ''}';
                print(
                    '${widget.contactCtrlObj.customerContacts?.contactDataList[index].name}');
                customerCtrlObj.contactId = widget.contactCtrlObj
                        .customerContacts?.contactDataList[index].contactId ??
                    '';
                customerCtrlObj.searchCustomerCtrl.text =
                    '${widget.contactCtrlObj.customerContacts?.contactDataList[index].name} ${widget.contactCtrlObj.customerContacts?.contactDataList[index].contactId}';
                customerCtrlObj.nameCtrl.text = widget.contactCtrlObj
                        .customerContacts?.contactDataList[index].name ??
                    '';
                customerCtrlObj.mobileNumberCtrl.text = widget.contactCtrlObj
                        .customerContacts?.contactDataList[index].mobile ??
                    '';
                bookingCtrl.contactIdCtrl.text =
                    '${widget.contactCtrlObj.customerContacts?.contactDataList[index].id}';
                print(
                    '${widget.contactCtrlObj.customerContacts?.contactDataList[index].id}');
              }, //=> expCtrlObj.selectedExpenseCategoryCtrl.text = '',
              tileTitle:
                  '${widget.contactCtrlObj.customerContacts?.contactDataList[index].name ?? ''} ${widget.contactCtrlObj.customerContacts?.contactDataList[index].contactId ?? ''} ' ??
                      '',
              itemCount: widget
                  .contactCtrlObj.customerContacts!.contactDataList.length,
            );
          },
        ),
      );
    });
  }
}
