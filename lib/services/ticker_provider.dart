import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits the current DateTime every minute so time-dependent UI auto-refreshes
final timeTickerProvider = StreamProvider<DateTime>((ref) {
  final controller = StreamController<DateTime>();

  // Send initial time immediately
  controller.add(DateTime.now());

  // Align with periodic timer every 10 seconds so UI stays responsive
  final timer = Timer.periodic(const Duration(seconds: 10), (_) {
    if (!controller.isClosed) {
      controller.add(DateTime.now());
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
