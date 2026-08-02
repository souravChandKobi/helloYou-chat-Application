import 'package:flutter/material.dart';

class NotificationLifeCycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() resumeCallBack;

  NotificationLifeCycleEventHandler({required this.resumeCallBack});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeCallBack();
    }
  }
}