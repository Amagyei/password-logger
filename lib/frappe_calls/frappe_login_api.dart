import 'dart:convert';
import 'package:http/http.dart' as http;

class FrappeAPI {
  // Variable to store session cookie after login
  String? _sessionId;

  // Function to verify login and store session cookie
  Future<Map<String, dynamic>> verifyLogin(String email, String password) async {
    const String apiUrl = 'http://erpxpand.com/api/method/login';

    try {
      // print('Sending request to API...');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'usr': email,
          'pwd': password,
        },
      );



      if (response.statusCode == 200) {
        // Extract session cookies if login is successful
        _sessionId = response.headers['set-cookie'];

        // Parse the JSON response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'status': 'success',
          'message': 'Login successful',
          'data': responseData,
        };
      } else {
        // Handle login failure
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        return {
          'status': 'error',
          'message': errorResponse['message'] ?? 'Login failed',
        };
      }
    } catch (error) {
      // Handle network or parsing errors
      return {
        'status': 'error',
        'message': 'Error connecting to the server',
      };
    }
  }

  // Function to get the session cookie for authenticated requests
  String? getSessionId() {
    return _sessionId;
  }
}