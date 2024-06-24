import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    // Define a custom path to create a stylish clipped shape
    var path = Path();
    // path.lineTo(0, h*0.65);
    // path.quadraticBezierTo(w*0.5, (h*0.65)-100, w, h*0.65);
    // path.lineTo(w, h);
    // path.lineTo(w, 0);

    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.2, 0);
    path.lineTo(w * 0.8, 0);
    path.lineTo(w, h * 0.5);
    path.lineTo(w * 0.7, h);
    path.lineTo(w * 0.3, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}