import 'package:flutter/material.dart';

class SitePage extends StatelessWidget {
  final String siteTitle;
  final String customPassword;

  const SitePage({super.key, required this.siteTitle, required this.customPassword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(siteTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Site Title: $siteTitle',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Custom Password: $customPassword',
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}