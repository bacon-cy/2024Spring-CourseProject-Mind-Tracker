import 'package:flutter/material.dart';

Color? getColor(int moodLevel) {
  switch (moodLevel) {
    case 1:
      return Colors.yellow.shade100;
    case 2:
      return Colors.yellow.shade100;
    case 3:
      return Colors.yellow.shade200;
    case 4:
      return Colors.yellow.shade300;
    case 5:
      return Colors.yellow.shade400;
    case 6:
      return Colors.yellow.shade500;
    case 7:
      return Colors.lime.shade200;
    case 8:
      return Colors.lime.shade300;
    case 9:
      return Colors.lime.shade400;
    case 10:
      return Colors.lime.shade500;
    case 11:
      return Colors.lime.shade700;
    case 12:
      return Colors.lime.shade800;
    case 13:
      return Colors.lime.shade900;
    default:
      return Colors.grey[200];
  }
  return null;
}
