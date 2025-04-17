import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Color.fromRGBO(0, 157, 192, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Privacy at My Tour Planner (MTP)'),
            _sectionBody(
              'At My Tour Planner (MTP), we value your privacy and are committed to protecting your personal data. This Privacy Policy outlines how we collect, use, and safeguard your information.',
            ),
            const Divider(thickness: 3),
            /*
            _sectionTitle('Information We Collect'),
            _sectionBody(
              '• Personal details like name, email, and travel preferences\n'
                  '• Booking details (destinations, dates, etc.)\n'
                  '• Device and usage information\n'
                  '• Securely processed payment data',
            ),
            const Divider(thickness: 3),

            _sectionTitle('How We Use Your Information'),
            _sectionBody(
              'We use your information to provide and improve services, personalize your experience, process bookings, send updates and promotions, and comply with legal requirements.',
            ),
            const Divider(thickness: 3),

            _sectionTitle('Data Sharing'),
            _sectionBody(
              'We do not sell your data. Information may be shared with trusted partners like hotels or payment providers, and legal authorities if necessary.',
            ),
            const Divider(thickness: 3),

            _sectionTitle('Security'),
            _sectionBody(
              'We take measures to secure your data, though no system is completely secure.',
            ),
            const Divider(thickness: 3),

            _sectionTitle('Your Rights'),
            _sectionBody(
              'You can request to access, update, or delete your data at any time by contacting us.',
            ),
            const Divider(thickness: 3),

            _sectionTitle('Changes to This Policy'),
            _sectionBody(
              'We may update this policy and will notify you of significant changes.',
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontFamily: "Sofia_Sans"),
      ),
    );
  }

  Widget _sectionBody(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 14, fontFamily: "Sofia_Sans"),
    );
  }
}
