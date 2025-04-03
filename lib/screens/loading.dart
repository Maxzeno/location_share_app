import 'package:flutter/material.dart';
import 'package:location_share_app/src/widget/loading.dart';

class LoadingScreen extends StatelessWidget {
  static final routeName = '/loading';
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loading(), // Temporary loading state
    );
  }
}
