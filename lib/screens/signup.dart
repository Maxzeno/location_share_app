import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:location_share_app/screens/signin.dart';
import 'package:location_share_app/src/utils/colors.dart';
import 'package:location_share_app/src/utils/spacing.dart';
import 'package:location_share_app/src/widget/button.dart';
import 'package:location_share_app/src/widget/form_text.dart';
import 'package:location_share_app/src/widget/textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //=========================== INITIAL STATE AND DISPOSE ====================================\\
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameEC.dispose();
    _userEmailEC.dispose();
    _userPasswordEC.dispose();
    _userNameFN.dispose();
    _userEmailFN.dispose();
    _userPasswordFN.dispose();
    super.dispose();
  }

  //=========================== ALL VARIABBLES ====================================\\
  bool hidePassword = true;

  //=========================== CONTROLLER ====================================\\
  final TextEditingController _userNameEC = TextEditingController();
  final TextEditingController _userEmailEC = TextEditingController();
  final TextEditingController _userPasswordEC = TextEditingController();

  //=========================== KEYS ====================================\\
  final _formKey = GlobalKey<FormState>();

  //=========================== FOCUS NODES ====================================\\
  final FocusNode _userNameFN = FocusNode();
  final FocusNode _userEmailFN = FocusNode();
  final FocusNode _userPasswordFN = FocusNode();

  //=========================== FUNCTIONS ====================================\\

  void setHidePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void _toLoginPage() => Get.off(
    () => const SigninScreen(),
    routeName: 'SigninScreen',
    duration: const Duration(milliseconds: 300),
    fullscreenDialog: true,
    curve: Curves.easeIn,
    popGesture: true,
    transition: Transition.rightToLeft,
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),

      child: Scaffold(
        backgroundColor: kWhiteColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            height: media.height,
            width: media.width,
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: kDefaultPadding * 2),
                  alignment: Alignment.center,
                  height: 200,
                  child: const CircleAvatar(
                    radius: 200 / 2,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.lock,
                        color: kSecondaryColor,
                        size: 80,
                        semanticLabel: "lock_icon",
                      ),
                    ),
                  ),
                ),
                kSizedBox,
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      kSizedBox,
                      Text(
                        'Please sign up to get started',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                kSizedBox,
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kSizedBox,
                      const FormText(text: 'Username'),
                      kHalfSizedBox,
                      MyTextFormField(
                        controller: _userNameEC,
                        validator: (value) {
                          RegExp userNamePattern = RegExp(
                            r'^.{3,}$', //Min. of 3 characters
                          );
                          if (value == null || value!.isEmpty) {
                            _userNameFN.requestFocus();
                            return "Enter your username";
                          } else if (!userNamePattern.hasMatch(value)) {
                            _userNameFN.requestFocus();
                            return "Name must be at least 3 characters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userNameEC.text = value;
                        },
                        textInputAction: TextInputAction.next,
                        nameFocusNode: _userNameFN,
                        hintText: "Enter username",
                      ),
                      kSizedBox,
                      const FormText(text: 'Email'),
                      kHalfSizedBox,
                      MyTextFormField(
                        controller: _userEmailEC,
                        nameFocusNode: _userEmailFN,
                        validator: (value) {
                          RegExp emailPattern = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                          );
                          if (value == null || value!.isEmpty) {
                            _userEmailFN.requestFocus();
                            return "Enter your email address";
                          } else if (!emailPattern.hasMatch(value)) {
                            _userEmailFN.requestFocus();
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userEmailEC.text = value;
                        },
                        textInputAction: TextInputAction.next,
                        hintText: "Enter email",
                      ),
                      kSizedBox,

                      const FormText(text: 'Password'),
                      kHalfSizedBox,
                      MyTextFormField(
                        hintText: "****************",
                        controller: _userPasswordEC,
                        nameFocusNode: _userPasswordFN,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: hidePassword,
                        textInputAction: TextInputAction.go,
                        validator: (value) {
                          RegExp passwordPattern = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
                          );
                          if (value == null || value!.isEmpty) {
                            _userPasswordFN.requestFocus();
                            return "Enter your password";
                          } else if (!passwordPattern.hasMatch(value)) {
                            _userPasswordFN.requestFocus();
                            return "Password needs to match format below.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userPasswordEC.text = value;
                        },
                        suffixIcon: IconButton(
                          onPressed: setHidePassword,
                          icon:
                              !hidePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(
                                    Icons.visibility_off_rounded,
                                    color: kSecondaryColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                kHalfSizedBox,
                FlutterPwValidator(
                  uppercaseCharCount: 1,
                  lowercaseCharCount: 1,
                  numericCharCount: 1,
                  controller: _userPasswordEC,
                  width: 400,
                  height: 150,
                  minLength: 8,
                  onSuccess: () {},
                  onFail: () {},
                ),
                kSizedBox,
                MyElevatedButton(title: "SIGN UP", onPressed: () async {}),
                kHalfSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Color(0xFF646982)),
                    ),
                    TextButton(
                      onPressed: _toLoginPage,
                      child: const Text(
                        "Log in",
                        style: TextStyle(color: kMainRed),
                      ),
                    ),
                  ],
                ),
                kHalfSizedBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
