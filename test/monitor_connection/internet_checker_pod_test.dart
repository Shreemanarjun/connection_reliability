import 'package:connection_example/features/monitor_connection/controller/internet_checker_pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Internet checker test", () {
    test(
        "if internet check is disabled then by default internet status should be connected",
        () async {
      final container = ProviderContainer(
        overrides: [
          enableInternetCheckerPod.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);
      final status = await container.read(internetCheckerPod.future);
      expect(status, InternetStatus.connected);
    });
    test(
        'if internet checker is disabled then by internet status should be connected ',
        () async {
      final container = ProviderContainer(overrides: [
        enableInternetCheckerPod.overrideWithValue(false),
      ]);
      addTearDown(container.dispose);
      final status = await container.read(internetCheckerPod.future);
      expectLater(
          await (container.read(internetConnectionCheckerPod))
              .hasInternetAccess,
          equals(false));
      container
          .read(internetConnectionCheckerPod)
          .onStatusChange
          .listen((event) {});
      expect(status, InternetStatus.connected);
      expect(container.read(internetConnectionCheckerPod).checkInterval,
          equals(const Duration(seconds: 5)));
      container
          .read(internetCheckerPod.notifier)
          .change(status: InternetStatus.disconnected);
      expect(container.read(internetCheckerPod).requireValue,
          equals(InternetStatus.disconnected));
    });
  });

  test(
      'if internetchecker is enabled then by default internet status should be connected',
      () async {
    final container = ProviderContainer(overrides: []);
    addTearDown(container.dispose);

    final status = await container.read(internetCheckerPod.future);
    expectLater(
        await container.read(internetConnectionCheckerPod).hasInternetAccess,
        equals(false));
    container
        .read(internetConnectionCheckerPod)
        .onStatusChange
        .listen((event) {});

    expect(status, InternetStatus.disconnected);
    container
        .read(internetCheckerPod.notifier)
        .change(status: InternetStatus.disconnected);
    expect(container.read(internetCheckerPod).requireValue,
        equals(InternetStatus.disconnected));
  });
}
