

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petzo/reg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'ip.dart';

class PetShopLogin extends StatefulWidget {
  @override
  _PetShopLoginState createState() => _PetShopLoginState();
}

class _PetShopLoginState extends State<PetShopLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // To indicate loading state
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading state
      });

      // Call the senddata function if the form is valid
      senddata();
    }
  }

  void senddata() async {
    String username = _emailController.text;
    String password = _passwordController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    final urls = Uri.parse(url + "/flutter_login");

    try {
      final response = await http.post(urls, body: {
        'username': username,
        'psw': password,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Success');
          String type = jsonDecode(response.body)['type'];
          String lid = jsonDecode(response.body)['lid'].toString();
          sh.setString("lid", lid);

          // Navigate based on user type
          if (type == 'user') {
            // Navigate to user home page if the user type is 'user'
            Navigator.push(context, MaterialPageRoute(builder: (context) => PetShopHomePage()));


          }
        } else {
          Fluttertoast.showToast(msg: 'Invalid username or password');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => IpHome()));
        return false;

      },
      child: Scaffold(
        backgroundColor: Colors.lightGreen[50],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Assign form key to validate inputs
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  // Pet-themed logo
                  Center(
                    child: Image.asset(
                      'assets/bg.jpg', // Add your pet shop logo here
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 20),
                  // App title
                  Text(
                    'Welcome to PetShop',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your pet\'s favorite store!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 40),
                  // Email input field with validation
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Password input field with validation
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Login button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button color
                    ),
                    onPressed: _isLoading ? null : _login, // Only enable if not loading
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Forgot password link

                  SizedBox(height: 20),
                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegMain()));


                          // Navigate to Register page
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PetShopLogin(),
    debugShowCheckedModeBanner: false,
  ));
}
