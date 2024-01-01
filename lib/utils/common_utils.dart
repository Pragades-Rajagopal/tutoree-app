import 'package:flutter/material.dart';
import 'package:get/get.dart';

alterDialog(String title, String message) {
  Get.defaultDialog(
    title: title,
    middleText: message,
    textCancel: 'ok',
    radius: 4.0,
    barrierDismissible: false,
    buttonColor: Colors.white,
  );
}
