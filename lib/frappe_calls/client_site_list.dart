// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ClientSiteService {
  final String _baseUrl = 'http://erpxpand.com/api/v2/method/in_house.api.get_all_client_sites';
  
  Future<List<Map<String, String>>> fetchClientSiteDetails() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
  
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
  
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
  
        // Ensure 'data' key exists and is a List
        if (data.containsKey('data') && data['data'] is List) {
          return List<Map<String, String>>.from(data['data'].map((site) => {
                'name': site['name'],
                'custom_password': site['custom_password'],
              }));
        } else {
          throw Exception('Unexpected data format: Missing "data" key or data is not a List');
        }
      } else {
        throw Exception('Failed to load client sites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching client sites: $e');
      throw Exception('Failed to fetch client sites');
    }
  }
}