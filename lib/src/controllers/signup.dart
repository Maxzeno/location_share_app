import 'dart:async';

import 'package:get/get.dart';
import 'package:location_share_app/src/services/auth.dart';
import 'package:location_share_app/src/utils/snackbar.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find<SignupController>();

  var isLoading = false.obs;
  var hidePassword = true.obs;

  void setHidePassword() {
    hidePassword.value = !hidePassword.value;
    update();
  }

  Future signup({required String email, required String password}) async {
    isLoading.value = true;
    update();

    final res = await AuthService().signUp(email, password);

    isLoading.value = false;
    update();

    if (res != null) {
      failedSnackbar(res);
      return;
    }
  }
}
