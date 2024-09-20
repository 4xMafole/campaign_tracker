import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

// Step 1: Integrate the DynamicLinkHandler class
import 'dynamic_link_handler.dart';

/// Provides methods to manage dynamic links.
final class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();
  final _analytics = FirebaseAnalytics.instance;

  /// Initializes the [DynamicLinkHandler].
  Future<void> initialize() async {
    // Listen to the dynamic links and manage navigation.
    _appLinks.uriLinkStream.listen(_handleLinkData).onError((error) {
      log('$error', name: 'Dynamic Link Handler');
    });
    _checkInitialLink();
  }

  /// Handle navigation if initial link is found on app start.
  Future<void> _checkInitialLink() async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLinkData(initialLink);
    }
  }

  /// Handles the link navigation Dynamic Links with UTM parameters.
  void _handleLinkData(Uri data) {
    final queryParams = data.queryParameters;
    log(data.toString(), name: 'Dynamic Link Handler');
    if (queryParams.isNotEmpty) {
      // Perform navigation as needed.
      // Get required data by [queryParams]
      _handleUTMParameters(queryParams);
    }
  }

  /// Handles UTM parameters for Firebase Analytics
  void _handleUTMParameters(Map<String, String> queryParams) {
    final utmSource = queryParams['utm_source'];
    final utmMedium = queryParams['utm_medium'];
    final utmCampaign = queryParams['utm_campaign'];


    if (utmSource != null && utmMedium != null && utmCampaign != null) {
      // _analytics.logCampaignDetails(
      //   source: utmSource,
      //   medium: utmMedium,
      //   campaign: utmCampaign,
      // );

      _analytics.logEvent(
        name: 'campaign',
        parameters: {
          'utm_source': utmSource,
          'utm_medium': utmMedium,
          'utm_campaign': utmCampaign,
        },
      );

    } else {
      log("No UTM parameters found in the link", name: 'Dynamic Link Handler');
    }
  }

  /// Provides the short url for your dynamic link.
  Future<String> createProductLink({
    required int id,
    required String title,
  }) async {
    // Call Rest API if link needs to be generated from backend.
    return 'https://example.com/products?id=$id&title=$title';
  }
}