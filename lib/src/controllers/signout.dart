import 'dart:async';

import 'package:get/get.dart';
import 'package:location_share_app/src/services/auth.dart';
import 'package:location_share_app/src/utils/snackbar.dart';

class SignoutController extends GetxController {
  static SignoutController get instance => Get.find<SignoutController>();

  var isLoading = false.obs;

  Future signiout() async {
    isLoading.value = true;
    update();

    final res = await AuthService().signOut();
    isLoading.value = false;
    update();

    if (res != null) {
      failedSnackbar(res);
      return;
    }
  }
}
