import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';

import '/Controllers/FundsController/fundsController.dart';
import '/Controllers/OrderController/order_type_controller.dart';
import '/Controllers/ProductController/all_products_controller.dart';
import '/Pages/Tabs/Controllers/BottomNavBarController.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  void initState() {
    Get.find<OrderTypeSelectionController>().fetchOrderTypes();
    Get.find<AllProductsController>().fetchUnitList();
    Get.find<AllProductsController>().fetchAllProducts();
    Get.find<FundsController>().fetchPaymentAccountList();
    _initializePrinter();
    super.initState();
  }

  Future<void> _initializePrinter() async {
    // Request permissions
    if (await Permission.bluetooth.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.bluetoothScan.request().isGranted &&
        await Permission.location.request().isGranted) {
      // _printerPlatform = FlutterPosPrinterPlatform.instance;
      // _printerPlatform
      //     .setPrinterBluetooth(false); // Example method call, adjust as needed
      // Initialize or use the printer service here
      print('Printer platform initialized');
    } else {
      // Handle the case where permissions are not granted
      print('Required permissions are not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (BottomNavBarController _bottomNavBarCtrlObj) {
      return WillPopScope(
        onWillPop: () async {
          if (_bottomNavBarCtrlObj.selectedNavBarIndex != 0) {
            _bottomNavBarCtrlObj.selectedNavBarIndex = 0;
            return false;
          }

          /// TODO: Double back press to exit app
          return true;
        },
        child: Scaffold(
          /// if selected nav bar index is 3 which means setting selected, the app bar will hide.
          // appBar: _bottomNavBarCtrlObj.selectedNavBarIndex != (0)
          //     ? AppBar(
          //         centerTitle: true,
          //         title: FadedScaleAnimation(
          //           SizedBox(
          //             height: kBottomNavigationBarHeight,
          //             child: Image(image: AssetImage(AppImages.eMenuLogo)),
          //           ),
          //           durationInMilliseconds: 400,
          //         ),
          //         actions: [
          //           // IconButton(
          //           //   onPressed: () => Get.to(() => Notifications()),
          //           //   icon: Icon(
          //           //     Icons.notifications_active_outlined,
          //           //     color: primaryColor,
          //           //   ),
          //           // ),
          //         ],
          //       )
          //     : null,
          body: _bottomNavBarCtrlObj
              .bottomNavBarData[_bottomNavBarCtrlObj.selectedNavBarIndex].page,
          bottomNavigationBar: GNav(
            gap: 2,
            tabBackgroundColor: Colors.grey.withOpacity(0.2),
            activeColor: Theme.of(context).colorScheme.primary,
            tabMargin: const EdgeInsets.all(5),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            padding: const EdgeInsets.all(10),
            backgroundColor: Colors.white,
            selectedIndex: _bottomNavBarCtrlObj.selectedNavBarIndex,
            tabs: _bottomNavBarCtrlObj.bottomNavBarData.map(
              (_navData) {
                return GButton(
                  icon: _navData.icon,
                  text: _navData.label.tr,
                  onPressed: () {
                    _bottomNavBarCtrlObj.selectedNavBarIndex =
                        _bottomNavBarCtrlObj.bottomNavBarData.indexOf(_navData);
                    if (_navData.onTap != null) {
                      _navData.onTap!();
                    }
                  },
                );
              },
            ).toList(),
          ),
        ),
      );
    });
  }
}
