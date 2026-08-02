import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideFromRightPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Duration reverseDuration;

  SlideFromRightPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
    this.reverseDuration = const Duration(milliseconds: 300),
  }) : super(
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Slide + fade
            final slide = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              ),
            );

            final fade = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            );

            return SlideTransition(
              position: slide,
              child: FadeTransition(
                opacity: fade,
                child: child,
              ),
            );
          },
        );
}
