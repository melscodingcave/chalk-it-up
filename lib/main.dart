import 'package:flutter/material.dart';

import 'screens/setup_screen.dart';

void main() {
  runApp(const ChalkItUpApp());
}

class ChalkItUpApp extends StatelessWidget {
  const ChalkItUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chalk It Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blue.shade300,
        ),
      ),
      home: const SetupScreen(),
    );
  }
}
