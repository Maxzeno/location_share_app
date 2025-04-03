import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:location_share_app/screens/signup.dart';
import 'package:location_share_app/src/utils/colors.dart';
import 'package:location_share_app/src/utils/spacing.dart';
import 'package:location_share_app/src/widget/button.dart';
import 'package:location_share_app/src/widget/form_text.dart';
import 'package:location_share_app/src/widget/textfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  //=========================== INITIAL STATE AND DISPOSE ====================================\\
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameEC.dispose();
    _userPasswordEC.dispose();
    _userNameFN.dispose();
    _userPasswordFN.dispose();
    super.dispose();
  }

  //=========================== ALL VARIABBLES ====================================\\
  bool hidePassword = true;

  //=========================== CONTROLLER ====================================\\
  final TextEditingController _userNameEC = TextEditingController();
  final TextEditingController _userPasswordEC = TextEditingController();

  //=========================== KEYS ====================================\\
  final _formKey = GlobalKey<FormState>();

  //=========================== FOCUS NODES ====================================\\
  final FocusNode _userNameFN = FocusNode();
  final FocusNode _userPasswordFN = FocusNode();

  //=========================== FUNCTIONS ====================================\\

  void setHidePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void _toSignupPage() => Get.off(
    () => const SignupScreen(),
    routeName: 'SignupScreen',
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
                        FontAwesomeIcons.unlockKeyhole,
                        color: kSecondaryColor,
                        size: 80,
                        semanticLabel: "login__success_icon",
                      ),
                    ),
                  ),
                ),
                kSizedBox,
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      kSizedBox,
                      Text(
                        'Please log in to your account',
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
                          if (value == null || value!.isEmpty) {
                            _userNameFN.requestFocus();
                            return "Enter your username";
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
                          if (value == null || value!.isEmpty) {
                            _userPasswordFN.requestFocus();
                            return "Enter your password";
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
                kSizedBox,
                kSizedBox,
                MyElevatedButton(title: "LOG IN", onPressed: () async {}),
                kHalfSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Dont't have an account? ",
                      style: TextStyle(color: Color(0xFF646982)),
                    ),
                    TextButton(
                      onPressed: _toSignupPage,
                      child: const Text(
                        "Sign up",
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
