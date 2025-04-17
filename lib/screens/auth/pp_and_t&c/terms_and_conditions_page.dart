import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Color.fromRGBO(0, 157, 192, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Welcome to My Tour Planner (MTP)'),
            _sectionBody(
              'By using MTP, you agree to our terms of use, service conditions, and privacy practices.',
            ),
            const Divider(thickness: 3),
            /*
            _sectionTitle('Use of Service'),
            _sectionBody(
              'You must be 18 or older or have parental consent. You agree to provide accurate information.',
            ),

            const Divider(thickness: 3),

            _sectionTitle('User Conduct'),
            _sectionBody(
              'Do not misuse the app or attempt to interfere with its functionality. Uploading false information is prohibited.',
            ),
            const Divider(thickness: 3),

            _sectionTitle('Intellectual Property'),
            _sectionBody(
              'All MTP content is owned by us or our partners. Do not reuse without permission.',
            ),
            const Divider(thickness: 3),

            _sectionTitle('Limitation of Liability'),
            _sectionBody(
              'MTP is not responsible for issues with third-party services like hotels or airlines. We’re not liable for indirect damages.',
            ),
            const Divider(thickness: 3),

            _sectionTitle('Changes to Terms'),
            _sectionBody(
              'We may revise these terms at any time. Continued use indicates your acceptance.',
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