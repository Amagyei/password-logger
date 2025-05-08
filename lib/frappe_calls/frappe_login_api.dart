import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class FrappeAPI {
  // Variable to store session cookie after login
  String? _sessionId;

  Future<Map<String, dynamic>> verifyLogin(String email, String password) async {
    const String apiUrl = 'https://erpxpand.com/api/method/login';

    // Encode credentials as base64 (username:password format)
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('303236ac9deb887:9b1bebb58a59e08'));

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          // 'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'usr': email,
          'pwd': password,
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw SocketException('The request timed out.');
      });
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');



      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          return {
            'status': 'success',
            'message': 'Login successful',
            'data': responseData,
          };
        } catch (e) {
          return {
            'status': 'error',
            'message': 'Invalid JSON response from server',
            'errorDetails': e.toString(),
          };
        }
      } else {
        // Handle login failure
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        return {
          'status': 'error',
          'message': errorResponse['message'] ?? 'Login failed',
        };
      }
    } catch (error) {
      String errorMessage;
      if (error is http.ClientException) {
        errorMessage = 'Client exception: ${error.message}';
      } else if (error is SocketException) {
        errorMessage = 'Network error: Unable to connect to the server';
      } else if (error is FormatException) {
        errorMessage = 'Format error: Invalid response format';
      } else {
        errorMessage = 'Unexpected error: $error';
      }

      // Return detailed error response
      return {
        'status': 'error',
        'message': errorMessage,
        'errorDetails': error.toString(), // Additional error details
      };
    }
  }

  String? getSessionId() {
    return _sessionId;
  }
}