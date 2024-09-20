
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';  // Import this to use logging

// Step 1: Integrate the DynamicLinkHandler class
import 'dynamic_link_handler.dart';  // Assuming you saved the handler in a file named dynamic_link_handler.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Step 2: Initialize the DynamicLinkHandler
  await DynamicLinkHandler.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Custom URL Handling',
      home: HelloWorldPage(),
    );
  }
}

class HelloWorldPage extends StatefulWidget {
  const HelloWorldPage({super.key});

  @override
  _HelloWorldPageState createState() => _HelloWorldPageState();
}

class _HelloWorldPageState extends State<HelloWorldPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // The DynamicLinkHandler is a singleton, so no need to manage its lifecycle here.
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom URL Handling')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World!'),
          ],
        ),
      ),
    );
  }
}
