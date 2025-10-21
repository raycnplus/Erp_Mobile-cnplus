import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Enum to represent the banner's state more clearly
enum BannerState { hidden, disconnected, reconnected }

class ConnectivityBanner extends StatefulWidget {
  final Widget child;
  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  BannerState _bannerState = BannerState.hidden;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasInternet = context.watch<bool>();

    // New logic to prevent the animation bug
    // This logic determines the banner state (hidden, disconnected, or reconnected)
    // and ensures a smooth transition without overlaps.

    if (!hasInternet) {
      // If there is no internet, the state is always 'disconnected'.
      _bannerState = BannerState.disconnected;
    } else { // If there is internet...
      if (_bannerState == BannerState.disconnected) {
        // If the previous state was 'disconnected', it means we just reconnected.
        // Change the state to 'reconnected' and start a timer to hide it.
        _bannerState = BannerState.reconnected;
        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 3), () {
          if (mounted && _bannerState == BannerState.reconnected) {
            setState(() {
              // After 3 seconds, hide the banner.
              _bannerState = BannerState.hidden;
            });
          }
        });
      }
      // If the previous state wasn't 'disconnected' (e.g., 'hidden' or 'reconnected'),
      // leave it as is (it will be handled by the timer).
    }

    final bool isBannerVisible = _bannerState != BannerState.hidden;
    final bool useReconnectStyle = _bannerState == BannerState.reconnected;

    final Color bannerColor = useReconnectStyle ? Colors.green : Colors.black87;
    final IconData bannerIcon = useReconnectStyle ? Icons.wifi : Icons.wifi_off;
    final String bannerText = useReconnectStyle
        ? 'Back Online'
        : 'No Internet Connection';

    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          bottom: isBannerVisible ? 0 : -60,
          left: 0,
          right: 0,
          child: ConnectionStatusBanner(
            color: bannerColor,
            icon: bannerIcon,
            text: bannerText,
          ),
        ),
      ],
    );
  }
}

// Helper widget to avoid code duplication
class ConnectionStatusBanner extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const ConnectionStatusBanner({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}