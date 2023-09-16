import 'package:connection_example/features/counter/view/counter_page.dart';
import 'package:connection_example/features/monitor_connection/view/monitor_connection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CounterPage().monitorConnection(),
    );
  }
}
