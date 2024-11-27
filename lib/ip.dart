// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:http/http.dart' as http;
//
// import '../main.dart';
// import 'login.dart';
// import 'logins.dart';
//
// void main() {
//   runApp(const MainApp());
// }
//
// class MainApp extends StatelessWidget {
//   const MainApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: const Color(0xFF203F81),
//         scaffoldBackgroundColor: Colors.grey.shade100,
//         fontFamily: 'Roboto',
//       ),
//       home: IpHome(),
//     );
//   }
// }
//
// class IpHome extends StatefulWidget {
//   IpHome({Key? key}) : super(key: key);
//
//   @override
//   State<IpHome> createState() => _IpHomeState();
// }
//
// class _IpHomeState extends State<IpHome> {
//   final FocusNode _focusNode = FocusNode();
//   final TextEditingController _controllerIpAddress = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Prevent back navigation
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("IP Address Setup"),
//           backgroundColor: const Color(0xFF203F81), // Set your desired background color
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               children: <Widget>[
//                 const SizedBox(height: 80),
//                 FadeInUp(
//                   duration: const Duration(milliseconds: 1000),
//                   child: const Text(
//                     "Petzo",
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF203F81),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 FadeInUp(
//                   duration: const Duration(milliseconds: 1200),
//                   child: const Text(
//                     "Enter the IP address below",
//                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 Expanded(
//                   child: FadeInUp(
//                     duration: const Duration(milliseconds: 1500),
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(25),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 10,
//                             offset: Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             const Text(
//                               "Server IP",
//                               style: TextStyle(fontSize: 18, color: Colors.grey),
//                             ),
//                             const SizedBox(height: 10),
//                             TextFormField(
//                               controller: _controllerIpAddress,
//                               decoration: InputDecoration(
//                                 hintText: "Enter IP Address",
//                                 prefixIcon: const Icon(Icons.language, color: Colors.grey),
//                                 filled: true,
//                                 fillColor: Colors.grey.shade200,
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                   borderSide: BorderSide(color: Colors.grey.shade200),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                   borderSide: const BorderSide(color: Color(0xFF203F81)),
//                                 ),
//                               ),
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return "Please enter a valid IP address";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 40),
//                             MaterialButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   sendData();
//                                 }
//                               },
//                               height: 50,
//                               color: const Color(0xFF203F81),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "Connect",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _controllerIpAddress.dispose();
//     super.dispose();
//   }
//
//   void sendData() async {
//     String ip = _controllerIpAddress.text.toString();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('ip', ip);
//     prefs.setString('url', 'http://$ip:8000');
//     prefs.setString('imgurl', 'http://$ip:8000');
//     prefs.setString('imgurl2', 'http://$ip:8000');
//     Navigator.push(context, MaterialPageRoute(builder: (context) => IpHome()));
//   }
// }
//



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petzo/reg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'ip.dart';
import 'logins.dart';

class IpHome extends StatefulWidget {
  @override
  _IpHomeState createState() => _IpHomeState();
}

class _IpHomeState extends State<IpHome> {
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
      sendData();
    }
  }

  void sendData() async {
    String ip = _emailController.text.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ip', ip);
    prefs.setString('url', 'http://$ip:8000');
    prefs.setString('imgurl', 'http://$ip:8000');
    prefs.setString('imgurl2', 'http://$ip:8000');
    Navigator.push(context, MaterialPageRoute(builder: (context) => PetShopLogin()));
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
                      labelText: 'Ip',
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
                        return 'Please enter Ip';
                      }
                     
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Password input field with validation
             
                  // Login button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button color
                    ),
                    onPressed: _isLoading ? null : _login, // Only enable if not loading
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Ip Set',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Forgot password link
          
                  // Register link
                
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
    home: IpHome(),
    debugShowCheckedModeBanner: false,
  ));
}
