import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petzo/home.dart';
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
      home: const PetCareRequest(),
    );
  }
}

class PetCareRequest extends StatefulWidget {
  const PetCareRequest({Key? key}) : super(key: key);

  @override
  State<PetCareRequest> createState() => _PetCareRequestState();
}

class _PetCareRequestState extends State<PetCareRequest> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController pettypeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  File? _selectedImage;
  String? _encodedImage;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetCare Request'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildTextField(pettypeController, 'Pet Type', Icons.person_outline),
              const SizedBox(height: 10),
              _buildTextField(ageController, 'Age', Icons.view_agenda, TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(detailsController, 'Details', Icons.details, TextInputType.text),
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
                child: const Text("Send"),
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




  Future<void> _sendData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? url = prefs.getString('url');
    final String? pid = prefs.getString('pid');
    final String? lid = prefs.getString('lid');

    if (url == null || pid == null || lid == null) {
      Fluttertoast.showToast(msg: 'Missing required data. Please check your settings.');
      return;
    }

    final Uri apiUri = Uri.parse('$url/user_send_petcare_request');
    try {
      final response = await http.post(apiUri, body: {
        'pid': pid,
        'lid': lid,
        'pettype': pettypeController.text,
        'age': ageController.text,
        'details': detailsController.text,
      });

      if (response.statusCode == 200) {
        final String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PetShopHomePage()),
          );
          Fluttertoast.showToast(msg: 'Request Successful');
        } else {
          Fluttertoast.showToast(msg: 'Error');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}
