import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
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
  StreamSubscription? _sub;
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    _appLinks = AppLinks();

    // Handle incoming links while the app is running
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleIncomingLink(uri.toString());
      }
    }, onError: (Object err) {});
  }

  void _handleIncomingLink(String link) {
    final uri = Uri.parse(link);
    final utmSource = uri.queryParameters['utm_source'];
    final utmMedium = uri.queryParameters['utm_medium'];
    final utmCampaign = uri.queryParameters['utm_campaign'];

    FirebaseAnalytics.instance.logEvent(
      name: 'campaign_install',
      parameters: {
        'utm_source': utmSource!,
        'utm_medium': utmMedium!,
        'utm_campaign': utmCampaign!,
      },
    );

    // Handle the campaign data as needed
    print('UTM Source: $utmSource');
    print('UTM Medium: $utmMedium');
    print('UTM Campaign: $utmCampaign');
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom URL Handling')),
      body: const Center(child: Text('Hello World!')),
    );
  }
}
