import 'package:flutter/material.dart';
import 'package:location_share_app/src/utils/colors.dart';

class Loading extends StatelessWidget {
  final Color color;

  const Loading({super.key, this.color = kMainRed});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: color);
  }
}
