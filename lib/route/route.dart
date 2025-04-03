import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_share_app/screens/loading.dart';
import 'package:location_share_app/screens/location_share.dart';
import 'package:location_share_app/screens/signin.dart';
import 'package:location_share_app/screens/signup.dart';

GetPage getPageFunc(String name, Widget widget) {
  return GetPage(
    name: name,
    page: () => widget,
    transitionDuration: const Duration(milliseconds: 300),
    fullscreenDialog: true,
    curve: Curves.easeIn,
    popGesture: true,
    transition: Transition.rightToLeft,
  );
}

final getPages = [
  getPageFunc(SigninScreen.routeName, const SigninScreen()),
  getPageFunc(SignupScreen.routeName, const SignupScreen()),
  getPageFunc(LocationShareScreen.routeName, const LocationShareScreen()),
  getPageFunc(LoadingScreen.routeName, const LoadingScreen()),
];
