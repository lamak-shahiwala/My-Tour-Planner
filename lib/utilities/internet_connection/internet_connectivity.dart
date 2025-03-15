import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';

Color iconColor = Color(0xFF0097B2);
Icon connectionTrueIcon = Icon(
  Icons.wifi,
  color: iconColor,
);
Icon connectionFalseIcon = Icon(
  Icons.wifi_off,
  color: iconColor,
);

class InternetConnectivity extends StatefulWidget {
  const InternetConnectivity({super.key});

  @override
  State<InternetConnectivity> createState() =>
      _InternetConnectivityState();
}

class _InternetConnectivityState extends State<InternetConnectivity> {
  InternetStatus? _connectionStatus;
  late final StreamSubscription<InternetStatus> _subscription;

  @override
  void initState() {
    super.initState();

    InternetConnection().hasInternetAccess.then((hasInternet) {
      setState(() {
        _connectionStatus = hasInternet
            ? InternetStatus.connected
            : InternetStatus.disconnected;
      });
    });

    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (mounted) {
        setState(() {
          _connectionStatus = status;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectivityIcon(_connectionStatus);
  }

  Widget InternetConnectivityIcon(connectionStatus) {
    if (connectionStatus == null) {
      return SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            iconColor,
          ),
          strokeWidth: 2,
        ),
      );
    }
    return connectionStatus == InternetStatus.connected
        ? connectionTrueIcon
        : connectionFalseIcon;
  }
}

Future<bool> getInternetStatus() async {
  bool result = await InternetConnection().hasInternetAccess;
  return result;
}