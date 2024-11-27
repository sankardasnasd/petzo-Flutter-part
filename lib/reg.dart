import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'login.dart';
import 'logins.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(32, 63, 129, 1.0),
        ),
      ),
      home: const RegMain(),
    );
  }
}

class RegMain extends StatefulWidget {
  const RegMain({Key? key}) : super(key: key);

  @override
  State<RegMain> createState() => _RegMainState();
}


class _RegMainState extends State<RegMain> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  File? _selectedImage;
  String? _encodedImage;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        backgroundColor: Colors.blue, // Set AppBar background color to blue
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildTextField(nameController, 'Name', Icons.person_outline),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'Email', Icons.email, TextInputType.emailAddress),
              const SizedBox(height: 10),
              _buildTextField(phoneController, 'Phone', Icons.phone, TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(placeController, 'Place', Icons.place),

              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendData();
                  }
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTextField(TextEditingController controller, String label, [IconData? icon, TextInputType inputType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label.';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.length < 8) return 'Please enter a password of at least 8 characters.';
        return null;
      },
    );
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseImage();
    } else {
      _showPermissionDialog();
    }
  }

  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Please grant permission to choose an image.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  Future<void> _sendData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? url = prefs.getString('url');
    if (url != null) {
      final Uri apiUri = Uri.parse('$url/user_reg');
      try {
        final response = await http.post(apiUri, body: {
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'place': placeController.text,
          'password': passwordController.text,
        });

        if (response.statusCode == 200) {
          final String status = jsonDecode(response.body)['status'];
          if (status == 'ok') {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => PetShopLogin(),)

            );
            Fluttertoast.showToast(msg: 'Registration Successful');

          } else {
            Fluttertoast.showToast(msg: 'Username Already taken');
          }
        } else {
          Fluttertoast.showToast(msg: 'Network Error');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: $e');
      }
    }
  }
}
