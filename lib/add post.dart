// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'Home.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Add Skills and Talents',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
//         useMaterial3: true,
//       ),
//       home: const AddPost(title: 'Add Skills'),
//     );
//   }
// }
//
// class AddPost extends StatefulWidget {
//   const AddPost({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<AddPost> createState() => _AddPostState();
// }
//
// class _AddPostState extends State<AddPost> {
//   final TextEditingController detailsController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   File? _image;
//   final _formKey = GlobalKey<FormState>();
//
//   // Method to pick an image from the gallery or camera
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => PetShopHomePage()));
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white,
//           elevation: 0.0,
//           leadingWidth: 0.0,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.grey.shade300,
//                 radius: 20.0,
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => PetShopHomePage()));
//                   },
//                   splashRadius: 1.0,
//                   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.green, size: 24.0),
//                 ),
//               ),
//               Text('Post'),
//               const SizedBox(width: 40.0),
//             ],
//           ),
//         ),
//         body: Form(
//           key: _formKey,
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   TextFormField(
//                     controller: nameController,
//                     decoration: InputDecoration(
//                       labelText: "Post Name",
//                       prefixIcon: const Icon(Icons.description),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a post name.";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: detailsController,
//                     decoration: InputDecoration(
//                       labelText: "Details",
//                       prefixIcon: const Icon(Icons.work),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter details.";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Image picker button
//                   ElevatedButton.icon(
//                     onPressed: _pickImage,
//                     icon: const Icon(Icons.camera_alt),
//                     label: Text(_image == null ? 'Pick an Image' : 'Image Selected'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.lightGreen,
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate() && _image != null) {
//                         _addPost();
//                       } else {
//                         Fluttertoast.showToast(msg: 'Please fill in all fields and select an image');
//                       }
//                     },
//                     child: const Text('Add Post'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.lightGreen,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Method to send data to the backend
//   void _addPost() async {
//     String details = detailsController.text.trim();
//     String name = nameController.text.trim();
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//
//     if (url == null || lid == null) {
//       Fluttertoast.showToast(msg: 'Invalid configuration. Please try again.');
//       return;
//     }
//
//     final Uri apiUrl = Uri.parse(url + "/add_post");
//
//     try {
//       // Prepare the request to send the data and the file
//       var request = http.MultipartRequest('POST', apiUrl)
//         ..fields['details'] = details
//         ..fields['name'] = name
//         ..fields['lid'] = lid;
//
//       // Attach the image file if it's selected
//       if (_image != null) {
//         var file = await http.MultipartFile.fromPath('files', _image!.path);
//         request.files.add(file);
//       }
//
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.bytesToString();
//         var data = jsonDecode(responseData);
//
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Post Added Successfully');
//           nameController.clear();
//           detailsController.clear();
//           setState(() {
//             _image = null;
//           });
//           Navigator.pop(context); // Returns to the previous screen
//         } else {
//           Fluttertoast.showToast(msg: 'Error: Post not added.');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Server Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  File? _file; // File object for either image or video
  String? _fileType; // Tracks whether it's an image or a video
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
                    _fileType = 'image';
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Choose Video'),
              onTap: () async {
                final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _file = File(pickedFile.path);
                    _fileType = 'video';
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
        title: const Text('Add Post'),
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
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Post Name",
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a post name.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    labelText: "Details",
                    prefixIcon: const Icon(Icons.work),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter details.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.file_upload),
                  label: Text(_file == null ? 'Choose File' : 'File Selected (${_fileType ?? ''})'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _file != null) {
                      _addPost();
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
  void _addPost() async {
    String details = detailsController.text.trim();
    String name = nameController.text.trim();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    if (url == null || lid == null) {
      Fluttertoast.showToast(msg: 'Invalid configuration. Please try again.');
      return;
    }

    final Uri apiUrl = Uri.parse('$url/add_post');

    try {
      var request = http.MultipartRequest('POST', apiUrl)
        ..fields['details'] = details
        ..fields['name'] = name
        ..fields['lid'] = lid;

      if (_file != null) {
        final fileField = await http.MultipartFile.fromPath('files', _file!.path);
        request.files.add(fileField);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Post Added Successfully');
          nameController.clear();
          detailsController.clear();
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
