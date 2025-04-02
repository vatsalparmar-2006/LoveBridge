import 'package:flutter/material.dart';
import 'DashBoard/splashScreen.dart';

void main() {
  runApp(const LoveBridge());
}

class LoveBridge extends StatelessWidget {
  const LoveBridge({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoveBridge ❤️',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        // useMaterial3: true,
      ),
      //
      home: SplashScreen(),
    );
  }
}