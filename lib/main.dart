import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '/Config/const.dart';
import '/Controllers/AllKitchenController/allKitchenController.dart';
import '/Controllers/AllSalesController/quotationController.dart';
import '/Controllers/AppController/appController.dart';
import '/Controllers/AuthController/auth_controller.dart';
import '/Controllers/ContactController/ContactController.dart';
import '/Controllers/CustomerVisits/CustomerVisitsController.dart';
import '/Controllers/DashboardController/dashboardController.dart';
import '/Controllers/FundsController/fundsController.dart';
import '/Controllers/ProductController/PaymentController.dart';
import '/Controllers/ProductController/all_products_controller.dart';
import '/Controllers/ProductController/product_cart_controller.dart';
import '/Controllers/ReceiptsController/receiptsController.dart';
import '/Controllers/SalesReturnController/saleReturnController.dart';
import '/Controllers/StockTransferController/stockTransferController.dart';
import '/Controllers/exception_controller.dart';
import '/Controllers/register/RegisterController.dart';
import 'Controllers/AllPrinterController/allPrinterController.dart';
import 'Controllers/AllSalesController/allSalesController.dart';
import 'Controllers/Booking Controller/BookingController.dart';
import 'Controllers/ListUserController/ListUserController.dart';
import 'Controllers/Notifications/NotificationsController.dart';
import 'Controllers/OrderController/order_type_controller.dart';
import 'Controllers/ProductsRetailController/productsRetailsController.dart';
import 'Controllers/ServiceStaffController/ServiceStaffController.dart';
import 'Controllers/Tax Controller/TaxController.dart';
import 'Controllers/ThemeController/themeController.dart';
import 'Controllers/Upload Controller/uploadController.dart';
import 'Locale/Languages/translation.dart';
import 'Locale/language_cubit.dart';
import 'Pages/Orders/Controller/OrderController.dart';
import 'Pages/Tabs/Controllers/BottomNavBarController.dart';
import 'Routes/routes.dart';
import 'Theme/style.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String currLang = sharedPreferences.getString("localeLanguage") ?? 'en';
  String currCountryCode =
      sharedPreferences.getString("localeCountryCode") ?? 'US';

  await GetStorage.init();
  initializeControllers();
  Get.find<AuthController>().currentColor =
      sharedPreferences.getString("themeColor") ?? 'FF800000';
  // NotificationServices.initialize();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgoundHandler);
  // try {
  //   socketService = SocketService();
  // } catch (_e) {
  //   debugPrint('Error: main -> socket => $_e');
  // }

  // RemoteMessage? initialMessage =
  //     await FirebaseMessaging.instance.getInitialMessage();
  // if (initialMessage != null) {
  //   print(initialMessage);
  //   PushNotification notification = PushNotification(
  //     title: initialMessage.notification?.title,
  //     body: initialMessage.notification?.body,
  //     dataTitle: initialMessage.data['title'],
  //     dataBody: initialMessage.data['body'],
  //   );
  // }

  runApp(
    UpgradeAlert(
      upgrader: MyUpgrader(),
      child: Phoenix(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LanguageCubit>(
              create: (context) => LanguageCubit(),
            ),
          ],
          child: BizModoEMenu(
            currLang,
            currCountryCode,
          ),
        ),
      ),
    ),
  );
}

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgoundHandler(RemoteMessage message) async {
//   //await Firebase.initializeApp();
//   print("Handling a background message : ${message.messageId}");
// }

void initializeControllers() {
  Get.put(AppController());
  Get.put(ExceptionController());
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(DashboardController());
  Get.put(NotificationsController());
  Get.put(AllPrinterController());
  Get.put(OrderTypeSelectionController());
  Get.put(ContactController());
  Get.put(OrderController());
  Get.put(TaxController());
  Get.put(RegisterController());
  Get.put(PaymentController());
  Get.put(ProductCartController());
  Get.put(AllProductsController());

  Get.put(BottomNavBarController());
  Get.put(BookingController());
  Get.put(ServiceStaffController());
  Get.put(ListUserController());
  Get.put(StockTransferController());
  Get.put(CustomerVisitsController());
  Get.put(AllSalesController());
  Get.put(ProductsRetailController());
  Get.put(SaleReturnController());
  Get.put(AllKitchenController());
  Get.put(ReceiptsController());
  Get.put(QuotationController());
  Get.put(UploadController());
  Get.put(FundsController());
}

class BizModoEMenu extends StatefulWidget {
  final String currLang;
  final String currCountryCode;
  BizModoEMenu(
    this.currLang,
    this.currCountryCode,
  );

  @override
  State<BizModoEMenu> createState() => _BizModoEMenuState();
}

class _BizModoEMenuState extends State<BizModoEMenu> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: Translation(), // your translations
            locale: Locale(
                widget.currLang,
                widget
                    .currCountryCode), // translations will be displayed in that locale
            fallbackLocale: Locale(widget.currLang, widget.currCountryCode),
            theme: appTheme,
            // darkTheme: appDarkTheme,
            home: SplashPage(),
            routes: PageRoutes().routes(),
          );
        },
      ),
    );
  }
}

/// This class extends / subclasses Upgrader.
class MyUpgrader extends Upgrader {
  MyUpgrader()
      : super(
          debugLogging: true,
          canDismissDialog: false,
          showIgnore: false,
          showLater: false,
          onLater: () => false,
          onIgnore: () => false,
          // debugDisplayAlways: true,
          shouldPopScope: () {
            exit(0);
          },
          durationUntilAlertAgain: const Duration(seconds: 20),
        );

  /// This method overrides super class method.
  @override
  void popNavigator(BuildContext context) {
    debugPrint('this method overrides popNavigator');
    super.popNavigator(context);
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Get.find<AuthController>().initialDataCheck();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: 200, width: 200, child: Image.asset(AppImages.royalIcon)),
      ),
    );
  }
}
