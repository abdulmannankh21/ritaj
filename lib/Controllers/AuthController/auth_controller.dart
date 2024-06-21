import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/Config/app_config.dart';
import '/Config/utils.dart';
import '/Models/business_n_register/BusinessModel.dart';
import '/Pages/Tabs/View/TabsPage.dart';
import '/Pages/login.dart';
import '/Services/api_services.dart';
import '/Services/api_urls.dart';
import '/Services/socket_handlers.dart';
import '/Services/storage_services.dart';
import '../exception_controller.dart';

class AuthController extends GetxController {
  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  String token = '';
  String currentColor = 'FF800000';
  String version = "";

  initialDataCheck() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    await Future.delayed(Duration(seconds: 2));
    if (!AppStorage.isStorageHasUserToken()) {
      return Get.off(() => LoginPage());
    }
    if (!AppStorage.isStorageHasLoggedUserData()) {
      await Get.find<AuthController>().getLoginUserDetail();
    }

    if (!AppStorage.isStorageHasBusinessDetails()) {
      await Get.find<AuthController>().getBusinessSetting();
    }

    if (AppStorage
            .isStorageHasUserToken() /* &&
        Get.find<RegisterController>().openedRegisterStatus != null*/
        ) Get.offAll(() => TabsPage());
  }

  Future<bool> getToken() async {
    Map<String, String> fields = {
      'client_id': AppConfig.clientId,
      'client_secret': AppConfig.clientSecret,
      'grant_type': AppConfig.grantType,
      'scope': AppConfig.scope,
      'username': userNameCtrl.text,
      'password': passwordCtrl.text,
    };
    String? response = await ApiServices.postMethod(
        feedUrl: ApiUrls.oauthToken, fields: fields);
    if (response == null) return false;
    // oAuthData = oauthModelFromJson(response);
    await AppStorage.setUserToken(response);
    // disposeControllers();
    return true;
  }

  Future<bool> getLoginUserDetail() async {
    String? response =
        await ApiServices.getMethod(feedUrl: ApiUrls.getLoggedInUserDetail);

    if (response == null) return false;

    await AppStorage.setLoggedUserData(response);
    // print('Color Code');
    // print(AppStorage.getLoggedUserData()?.staffUser.appSetting?.themeSelection);
    showToast("logged in");
    // disposeControllers();
    return true;
  }

  void disposeControllers() {
    userNameCtrl.clear();
    passwordCtrl.clear();
  }

  /// Business Information
  Future<bool> getBusinessSetting() async {
    return await ApiServices.getMethod(feedUrl: ApiUrls.businessDetails)
        .then((_res) async {
      if (_res == null) return false;
      await AppStorage.setBusinessDetails(_res);

      // await Get.find<RegisterController>().fetchRegisterStatus();

      return true;
    }).onError((error, stackTrace) async {
      debugPrint('Error => $error');
      logger.e('StackTrace => $stackTrace');
      await ExceptionController().exceptionAlert(
        errorMsg: '$error',
        exceptionFormat: ApiServices.methodExceptionFormat(
            'POST', ApiUrls.businessDetails, error, stackTrace),
      );
      return false;
    });
  }

  String businessLocationAddress() {
    try {
      BusinessLocationModel? businessLoc =
          AppStorage.getBusinessDetailsData()?.businessData?.locations.first;

      String address = '';
      if (businessLoc?.landmark != null)
        address += '${businessLoc?.landmark ?? ''},';
      if (businessLoc?.city != null) address += ' ${businessLoc?.city ?? ''}';
      if (businessLoc?.country != null)
        address += '\n${businessLoc?.country ?? ''}';

      return address;
    } catch (_e) {
      return '';
    }
  }

  bool isInlineTaxEnabled() {
    return AppStorage.getBusinessDetailsData()?.businessData?.enableInlineTax ==
        1;
  }

  bool isOrderTaxEnabled() {
    return AppStorage.getBusinessDetailsData()
            ?.businessData
            ?.posSettings
            ?.disableOrderTax ==
        0;
  }

  ///change Password function

  /// logout function
  void logout() async {
    await AppStorage.box.erase();
    SocketService.dispose();
    // RegisterController().clear();
    Get.offAll(() => LoginPage());
  }

  Future<bool?> sendTokenToServer() async {
    Map<String, String> _field = {
      "device_token": '${token}',
    };

    return await ApiServices.postMethod(
            feedUrl: ApiUrls.userFirebaseTokenApi, fields: _field)
        .then((_res) {
      if (_res == null) return null;

      print('Token APi Calling');
      print(_res);
      return true;
    }).onError((error, stackTrace) async {
      debugPrint('Error => $error');
      logger.e('StackTrace => $stackTrace');
      await ExceptionController().exceptionAlert(
        errorMsg: '$error',
        exceptionFormat: ApiServices.methodExceptionFormat(
            'POST', ApiUrls.userFirebaseTokenApi, error, stackTrace),
      );
      throw '$error';
    });
  }
}
