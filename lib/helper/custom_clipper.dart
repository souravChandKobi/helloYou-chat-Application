import 'dart:ui';

import 'package:flutter/cupertino.dart' show CustomClipper;

class BottomEdgesConvexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0); // top-left
    path.lineTo(0, size.height); // bottom-left start

    // Left edge convex curve
    path.quadraticBezierTo(
      0, size.height - 30,    // control point above bottom
      30, size.height          // end of left curve
    );

    // Straight line across bottom middle
    path.lineTo(size.width - 30, size.height);

    // Right edge convex curve
    path.quadraticBezierTo(
      size.width, size.height - 30, // control point above bottom
      size.width, size.height        // end bottom-right
    );

    path.lineTo(size.width, 0); // top-right
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
