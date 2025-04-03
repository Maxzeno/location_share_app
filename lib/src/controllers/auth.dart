import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:location_share_app/screens/location_share.dart';
import 'package:location_share_app/screens/signin.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user != null) {
      Get.offNamed(LocationShareScreen.routeName);
    } else {
      Get.offNamed(SigninScreen.routeName);
    }
  }
}
