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
