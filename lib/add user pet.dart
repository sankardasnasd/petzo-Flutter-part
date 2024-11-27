

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddUserPet extends StatefulWidget {
  const AddUserPet({Key? key}) : super(key: key);

  @override
  State<AddUserPet> createState() => _AddUserPetState();
}

class _AddUserPetState extends State<AddUserPet> {
  final TextEditingController petnameController = TextEditingController();
  final TextEditingController pet_typeControler = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _file; // File object for either image or video
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image or video
  Future<void> _pickFile() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose Image'),
              onTap: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _file = File(pickedFile.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: petnameController,
                  decoration: InputDecoration(
                    labelText: "Pet Name",
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a Pet name.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: pet_typeControler,
                  decoration: InputDecoration(
                    labelText: "Type",
                    prefixIcon: const Icon(Icons.work),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Type.";
                    }
                    return null;
                  },
                ),


                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Price",
                    prefixIcon: const Icon(Icons.work),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a price.";
                    }
                    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                      return "Price must be a valid number.";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    prefixIcon: const Icon(Icons.work),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an age.";
                    }
                    if (!RegExp(r'^\d{1,2}$').hasMatch(value)) {
                      return "Age must be 1-2 digits.";
                    }
                    return null;
                  },
                ),


                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.file_upload),
                  label: Text(_file == null ? 'Choose File' : 'File Selected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _file != null) {
                      _AddUserPet();
                    } else {
                      Fluttertoast.showToast(msg: 'Please fill in all fields and select a file');
                    }
                  },
                  child: const Text('Add Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to send data to the backend
  void _AddUserPet() async {
    String petname = petnameController.text.trim();
    String pet_type = pet_typeControler.text.trim();
    String price = priceController.text.trim();
    String age = ageController.text.trim();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    if (url == null || lid == null) {
      Fluttertoast.showToast(msg: 'Invalid configuration. Please try again.');
      return;
    }

    final Uri apiUrl = Uri.parse('$url/user_add_pet');

    try {
      var request = http.MultipartRequest('POST', apiUrl)
        ..fields['petname'] = petname
        ..fields['pet_type'] = pet_type
        ..fields['price'] = price
        ..fields['age'] = age
        ..fields['lid'] = lid;

      if (_file != null) {
        final fileField = await http.MultipartFile.fromPath('image', _file!.path);
        request.files.add(fileField);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Post Added Successfully');
          petnameController.clear();
          pet_typeControler.clear();
          priceController.clear();
          ageController.clear();
          setState(() {
            _file = null;
          });
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: 'Error: Post not added.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server Error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
    }
  }
}
