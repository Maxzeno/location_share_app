import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:location_share_app/screens/signup.dart';
import 'package:location_share_app/src/controllers/signin.dart';
import 'package:location_share_app/src/utils/colors.dart';
import 'package:location_share_app/src/utils/spacing.dart';
import 'package:location_share_app/src/widget/button.dart';
import 'package:location_share_app/src/widget/form_text.dart';
import 'package:location_share_app/src/widget/textfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  static const routeName = '/signin';

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  //=========================== INITIAL STATE AND DISPOSE ====================================\\
  @override
  void initState() {
    Get.put(SigninController());
    super.initState();
  }

  @override
  void dispose() {
    _userEmailEC.dispose();
    _userPasswordEC.dispose();
    _userEmailFN.dispose();
    _userPasswordFN.dispose();
    super.dispose();
  }

  //=========================== CONTROLLER ====================================\\
  final TextEditingController _userEmailEC = TextEditingController();
  final TextEditingController _userPasswordEC = TextEditingController();

  //=========================== KEYS ====================================\\
  final _formKey = GlobalKey<FormState>();

  //=========================== FOCUS NODES ====================================\\
  final FocusNode _userEmailFN = FocusNode();
  final FocusNode _userPasswordFN = FocusNode();

  //=========================== FUNCTIONS ====================================\\

  void _toSignupScreen() {
    Get.offNamed(SignupScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),

      child: GetBuilder<SigninController>(
        builder: (signinController) {
          return Scaffold(
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
                          const FormText(text: 'Email'),
                          kHalfSizedBox,
                          MyTextFormField(
                            controller: _userEmailEC,
                            validator: (value) {
                              if (value == null || value!.isEmpty) {
                                _userEmailFN.requestFocus();
                                return "Enter your email";
                              }
                              return null;
                            },

                            textInputAction: TextInputAction.next,
                            nameFocusNode: _userEmailFN,
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
                            obscureText: signinController.hidePassword.value,
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
                              onPressed: signinController.setHidePassword,
                              icon:
                                  !signinController.hidePassword.value
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
                    MyElevatedButton(
                      title: "LOG IN",
                      isLoading: signinController.isLoading.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signinController.signin(
                            email: _userEmailEC.text,
                            password: _userPasswordEC.text,
                          );
                        }
                      },
                    ),
                    kHalfSizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Dont't have an account? ",
                          style: TextStyle(color: Color(0xFF646982)),
                        ),
                        TextButton(
                          onPressed: _toSignupScreen,
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
          );
        },
      ),
    );
  }
}
