import 'package:flutter/material.dart';
import 'package:get/get.dart';

alterDialogFunc(String title, String message) {
  Get.defaultDialog(
    title: title,
    middleText: message,
    textCancel: 'ok',
    radius: 12.0,
    barrierDismissible: false,
    buttonColor: Colors.white,
  );
}

successSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    icon: const Icon(
      Icons.check_circle_outlined,
      color: Colors.green,
    ),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
    backgroundColor: const Color(0xFFEEFFEE),
    maxWidth: 350.0,
  );
}

errorSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    icon: const Icon(
      Icons.cancel_outlined,
      color: Colors.red,
    ),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
    backgroundColor: const Color(0xFFFFDAD7),
    maxWidth: 350.0,
  );
}
