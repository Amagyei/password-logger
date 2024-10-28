// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:password_logger/components/site_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> clientSites = [];

  Future<void> fetchClientSites() async {
    try {
      final url = Uri.parse('http://10.0.2.2:8002/api/v2/method/in_house.api.get_all_client_sites');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          setState(() {
            clientSites = List<Map<String, String>>.from(data['data'].map((site) => {
                  'name': site['name'] as String,
                  'customPassword': site['custom_password'] as String,
                }));
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load client sites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching client sites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client sites')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchClientSites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Sites'),
      ),
      body: clientSites.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clientSites.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  title: clientSites[index]['name']!,
                  customPassword: clientSites[index]['customPassword']!,
                );
              },
            ),
    );
  }
}