import 'dart:async';

import 'package:app_links/app_links.dart';

class UniService {
  // Define a stream controller to handle deep links
  final StreamController<String> _deepLinkController =
      StreamController.broadcast();

  // Getter for the deep link stream
  Stream<String> get deepLinkStream => _deepLinkController.stream;

  // Initialize UniLinks and handle incoming deep links
  Future<void> initUniLinks() async {
    // Initialize the UniLinks
    final appLinks = AppLinks();

    // Listen for incoming deep links
    appLinks.uriLinkStream.listen((Uri? deepLink) {
      if (deepLink != null) {
        _deepLinkController.add(deepLink.toString());
      }
    });

    // Get the initial deep link when the app is launched
    final initialLink = await appLinks.getInitialAppLink();
    if (initialLink != null) {
      _deepLinkController.add(initialLink.toString());
    }
  }

  // Dispose the stream controller when it's no longer needed
  void dispose() {
    _deepLinkController.close();
  }
}
