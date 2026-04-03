import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static TextStyle heading1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!;
  }

  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!;
  }
}
