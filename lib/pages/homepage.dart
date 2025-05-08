import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_house/components/site_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> clientSites = [];
  List<Map<String, String>> filteredSites = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  Future<void> fetchClientSites() async {
    try {
      final url = Uri.parse('https://erpxpand.com/api/v2/method/in_house.api.get_all_client_sites');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          final sites = List<Map<String, String>>.from(data['data'].map((site) => {
            'name': (site['name'] ?? 'Unnamed Site').toString(),
            'customPassword': (site['password'] ?? 'No Password').toString(),
          }));

          setState(() {
            clientSites = sites;
            filteredSites = sites;
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

  void _filterSites(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredSites = clientSites.where((site) {
        return site['name']!.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchClientSites();
    _searchController.addListener(() {
      _filterSites(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Sites'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search client sites...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: filteredSites.isEmpty
          ? const Center(child: Text('No sites found'))
          : ListView.builder(
              itemCount: filteredSites.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  title: filteredSites[index]['name']!,
                  customPassword: filteredSites[index]['customPassword']!,
                );
              },
            ),
    );
  }
}