import 'package:connection_example/features/monitor_connection/controller/internet_checker_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetStatusNotifier extends AutoDisposeStreamNotifier<InternetStatus> {
  @override
  Stream<InternetStatus> build() {
    final enabled = ref.watch(enableInternetCheckerPod);
    if (enabled) {
      final statusChange =
          ref.watch(internetConnectionCheckerPod).onStatusChange;
      return statusChange.distinct();
    } else {
      return Stream.value(InternetStatus.connected);
    }
  }

  @visibleForTesting
  void change({required InternetStatus status}) {
    state = AsyncData(status);
  }
}
