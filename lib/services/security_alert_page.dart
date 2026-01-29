
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecurityAlertPage extends StatelessWidget {
  final List<String> breaches;

  const SecurityAlertPage({Key? key, required this.breaches}) : super(key: key);

  // Map to hold breach details: icon, title, and resolution steps
  static final Map<String, Map<String, dynamic>> _breachDetails = {
    'Device is Rooted / Jailbroken': {
      'icon': Icons.security,
      'title': 'Device Not Secure',
      'resolution': 'Your device appears to be rooted or jailbroken. For your data\'s safety, Swift HRM cannot run on modified operating systems. Please use a device with a standard OS.'
    },
    'Developer Options Enabled': {
      'icon': Icons.developer_mode,
      'title': 'Developer Options Active',
      'resolution': 'Developer Options are currently enabled. To proceed, please go to your device Settings, find "Developer Options", and turn them off.'
    },
    'Mock Location Detected': {
      'icon': Icons.location_disabled,
      'title': 'Mock Location Active',
      'resolution': 'A mock location or GPS spoofing app is active. Please disable it from your device settings or uninstall the application to continue.'
    },
    'GPS Accuracy Too Low': {
      'icon': Icons.gps_not_fixed,
      'title': 'Poor GPS Signal',
      'resolution': 'Your GPS accuracy is too low. Please ensure you are in an open area with a clear view of the sky for a stronger satellite signal.'
    },
    'Could not verify location': {
        'icon': Icons.location_off,
        'title': 'Location Unavailable',
        'resolution': 'Could not access your device\'s location. Please ensure that location services are enabled for Swift HRM in your device settings and that you have granted the necessary permissions.'
    },
    // A default for any other errors
    'default': {
      'icon': Icons.error_outline,
      'title': 'Security Issue Detected',
      'resolution': 'An unknown security issue was found. Please ensure your device and app are up to date. If the issue persists, contact support.'
    }
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        backgroundColor: const Color(0xff1a1a2e),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.gpp_bad,
                  color: Color(0xffe94560),
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Security Alert',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'For your security, we need to resolve the following issues before you can proceed:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    itemCount: breaches.length,
                    itemBuilder: (context, index) {
                      final breachKey = breaches[index];
                      final details = _breachDetails.entries.firstWhere(
                        (entry) => breachKey.startsWith(entry.key),
                        orElse: () => MapEntry('default', _breachDetails['default']!),
                      ).value;
                      
                      return Card(
                        color: const Color(0xff16213e),
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(details['icon'], color: const Color(0xffe94560), size: 28),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      details['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                details['resolution'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffe94560),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => SystemNavigator.pop(), // Close the app
                  child: const Text(
                    'CLOSE APP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
