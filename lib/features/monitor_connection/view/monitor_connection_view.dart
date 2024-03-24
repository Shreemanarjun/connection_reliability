import 'package:connection_example/features/monitor_connection/controller/internet_checker_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

extension NoInternet on Widget {
  Widget monitorConnection({Widget? noInternetWidget}) {
    return MonitorConnectionView(
      noInternetWidget: noInternetWidget,
      child: this,
    );
  }
}

class MonitorConnectionView extends StatelessWidget {
  final Widget child;
  final Widget? noInternetWidget;
  const MonitorConnectionView({
    super.key,
    required this.child,
    this.noInternetWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0.0,
            child: AnimatedSize(
              duration: const Duration(seconds: 2),
              child:
                  DefaultNoInternetWidget(noInternetWidget: noInternetWidget),
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultNoInternetWidget extends ConsumerStatefulWidget {
  final Widget? noInternetWidget;
  const DefaultNoInternetWidget({
    super.key,
    this.noInternetWidget,
  });

  @override
  ConsumerState<DefaultNoInternetWidget> createState() =>
      _DefaultNoInternetWidgetState();
}

class _DefaultNoInternetWidgetState
    extends ConsumerState<DefaultNoInternetWidget> {
  InternetStatus? lastResult;

  void internetListener(InternetStatus status) {
    switch (status) {
      case InternetStatus.connected:
        if (lastResult == InternetStatus.disconnected) {
          /// do any refresh work here
        }
        break;
      case InternetStatus.disconnected:
        break;
    }
    lastResult = status;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(internetCheckerPod, (previous, next) {
      if (next is AsyncData) {
        final status = next.value;
        if (status != null) {
          internetListener(status);
        }
      }
    });
    final statusAsync = ref.watch(internetCheckerPod);
    return statusAsync.when(
      data: (status) {
        return Align(
          alignment: Alignment.topCenter,
          heightFactor: status == InternetStatus.disconnected ? 1.0 : 0.0,
          child: status == InternetStatus.disconnected
              ? ((widget.noInternetWidget) ??
                  MaterialBanner(
                    content: const Text("No internet available"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            ref.invalidate(internetCheckerPod);
                          },
                          child: const Text(
                            "OK",
                          ))
                    ],
                  ))
              : const SizedBox.shrink(),
        );
      },
      error: (error, stackTrace) => MaterialBanner(
        content: Text("Unable to check internet due to $error"),
        actions: [
          ElevatedButton(
            onPressed: () {
              ref.invalidate(internetCheckerPod);
            },
            child: const Text("Retry"),
          ),
        ],
      ),
      loading: () => const LinearProgressIndicator(),
    );
  }
}
