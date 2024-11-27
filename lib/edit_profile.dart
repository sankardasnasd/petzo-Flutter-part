// import 'dart:io';
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:petzo/profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart ';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() {
//   runApp(const EditPickupHome());
// }
//
// class EditPickupHome extends StatelessWidget {
//   const EditPickupHome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//
//       title: 'MySignup',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const edit_profile(title: 'Worker '),
//     );
//   }
// }
//
// class edit_profile extends StatefulWidget {
//   const edit_profile({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<edit_profile> createState() => _edit_profileState();
// }
//
// class _edit_profileState extends State<edit_profile> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     senddata();
//   }
//
//
//
//
//   // String gender = "Male";
//   TextEditingController nameController= new TextEditingController();
//   TextEditingController emailController= new TextEditingController();
//   TextEditingController contactController= new TextEditingController();
//   TextEditingController placeController= new TextEditingController();
//
//   // TextEditingController categorycontroll= new TextEditingController();
//
//   // List<int> id_ = <int>[];
//   // List<String> category_ = <String>[];
//   // String dropdownValue1 ="";
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return WillPopScope(
//       onWillPop: () async{ return true; },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           title: Text(widget.title),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//
//
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("First Name")),
//                 ),
//               ),
//
//              Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   keyboardType: TextInputType.emailAddress,
//
//                   controller: emailController,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Email")),
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   keyboardType: TextInputType.number,
//
//                   controller: contactController,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Phone")),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   keyboardType: TextInputType.name,
//
//                   controller: placeController,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Place")),
//                 ),
//               ),
//
//
//
//
//
//
//               ElevatedButton(
//                 onPressed: () {
//
//                   _send_data() ;
//
//                 },
//                 child: Text("Update"),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//   void _send_data() async{
//
//     String name=nameController.text;
//     String email=emailController.text;
//     String phone=contactController.text;
//     String place=placeController.text;
//
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/edit_profile');
//     try {
//
//
//
//       final response = await http.post(urls, body: {
//         // "image1":photo,
//         'lid':lid,
//         'name':name,
//         'email':email,
//         'phone':phone,
//         'place':place,
//
//
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//
//           Fluttertoast.showToast(msg: ' Successfull');
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => userProfile_new1(title: '',),));
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//
//   // First photo starts here
//   File? uploadimage;
//   File? _selectedImage;
//   String? _encodedImage;
//   Future<void> _chooseAndUploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
//         photo = _encodedImage.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage();
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Denied'),
//           content: const Text(
//             'Please go to app settings and grant permission to choose an image.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   String photo = '';
//   // First photo ends here
//
//
//   // Second photo starts here
//
//
//   File? uploadimage2;
//   File? _selectedImage2;
//   String? _encodedImage2;
//   Future<void> _chooseAndUploadImage2() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage2 = File(pickedImage.path);
//         _encodedImage2 = base64Encode(_selectedImage2!.readAsBytesSync());
//         // proof = _encodedImage2.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage2() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage2();
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Denied'),
//           content: const Text(
//             'Please go to app settings and grant permission to choose an image.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//   //worker profile
//   String  photo_='';
//   void senddata()async{
//
//
//     SharedPreferences sh=await SharedPreferences.getInstance();
//     String url=sh.getString('url').toString();
//     String lid=sh.getString('lid').toString();
//     final urls=Uri.parse(url+"/user_profile");
//     try{
//       final response=await http.post(urls,body:{
//         'lid':lid,
//       });
//
//
//
//
//     if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//           Fluttertoast.showToast(msg: 'Success');
//
//
//
//
//
//           setState(() {
//             emailController.text=jsonDecode(response.body)['email'].toString();
//             nameController.text=jsonDecode(response.body)['name'].toString();
//             contactController.text=jsonDecode(response.body)['phone'].toString();
//
//             placeController.text=jsonDecode(response.body)['place'].toString();
//
//
//
//           });
//
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//
//   }
//
//
// }
//


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petzo/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const EditPickupHome());
}

class EditPickupHome extends StatelessWidget {
  const EditPickupHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Profile',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url') ?? '';
    String lid = prefs.getString('lid') ?? '';

    try {
      final response = await http.post(
        Uri.parse('$url/user_profile'),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            nameController.text = data['name'] ?? '';
            emailController.text = data['email'] ?? '';
            contactController.text = data['phone'] ?? '';
            placeController.text = data['place'] ?? '';
          });
        } else {
          Fluttertoast.showToast(msg: 'Profile not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url') ?? '';
    String lid = prefs.getString('lid') ?? '';

    try {
      final response = await http.post(
        Uri.parse('$url/edit_profile'),
        body: {
          'lid': lid,
          'name': nameController.text,
          'email': emailController.text,
          'phone': contactController.text,
          'place': placeController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => userProfile_new1(title: '',),));
          Fluttertoast.showToast(msg: 'Profile updated successfully');
        } else {
          Fluttertoast.showToast(msg: 'Update failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // GestureDetector(
            //   onTap: selectImage,
            //   child: CircleAvatar(
            //     radius: 60,
            //     backgroundColor: Colors.grey[300],
            //     backgroundImage: selectedImage != null
            //         ? FileImage(selectedImage!)
            //         : const AssetImage('assets/placeholder.png') as ImageProvider,
            //     child: selectedImage == null
            //         ? const Icon(
            //       Icons.camera_alt,
            //       size: 40,
            //       color: Colors.grey,
            //     )
            //         : null,
            //   ),
            // ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: placeController,
              decoration: const InputDecoration(
                labelText: 'Place',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Update Profile',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
