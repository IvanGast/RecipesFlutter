import 'package:flutter/material.dart';

class SnackBars {
  static SnackBar info(String message, {int sec = 5}) {
    return SnackBar(
      duration: Duration(seconds: sec),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  static SnackBar success(String message, {int sec = 5}) {
    return SnackBar(
      duration: Duration(seconds: sec),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.green,
        ),
      ),
    );
  }

  static SnackBar error(String message, {int sec = 5}) {
    return SnackBar(
      duration: Duration(seconds: sec),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}