import 'package:flutter/material.dart';
import 'root/theme.dart';
import 'ui/splash.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Quiz Flutter",
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    ),
  );
}