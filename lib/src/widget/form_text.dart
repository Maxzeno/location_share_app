import 'package:flutter/material.dart';
import 'package:location_share_app/src/utils/colors.dart';

class FormText extends StatelessWidget {
  final String text;
  const FormText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: kTextBlackColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
