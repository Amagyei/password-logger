import 'package:flutter/material.dart';
import 'package:in_house/components/my_button.dart';
import 'package:in_house/components/my_textfield.dart';
import 'package:in_house/frappe_calls/frappe_login_api.dart';
import 'package:in_house/pages/homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginClass createState() => LoginClass();
}

class LoginClass extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    print('Login button pressed');
    try {
      final response = await FrappeAPI().verifyLogin(
        usernameController.text, 
        passwordController.text,
      );


      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (response['status'] == 'success') {
        // Navigate to the next screen if the login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(), 
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 50),
              const Text(
                "Welcome back",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 10),
              MyTextfield(
                controller: usernameController,
                obscureText: false,
                hintText: "Username",
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: passwordController,
                obscureText: true,
                hintText: "Password",
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                textcontent: 'Login',
                onTap: _isLoading ? null : _login,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 0.5,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or continue with'),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}