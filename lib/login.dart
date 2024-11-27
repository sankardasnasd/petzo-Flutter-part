import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'ip.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF203F81),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => IpHome()));
        return false;
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade800,
                          Colors.blue.shade600,
                          Colors.blue.shade400,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 60),
                          FadeInDown(
                            duration: const Duration(milliseconds: 1000),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              child: Icon(Icons.person, size: 50, color: Colors.blue.shade800),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInDown(
                            duration: const Duration(milliseconds: 1000),
                            child: const Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeInDown(
                            duration: const Duration(milliseconds: 1200),
                            child: const Text(
                              "Login to your account",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      "Username",
                                      style: TextStyle(fontSize: 18, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _controllerUsername,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person, color: Colors.grey),
                                        hintText: "Enter your username",
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: const BorderSide(color: Color(0xFF203F81)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your username";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Password",
                                      style: TextStyle(fontSize: 18, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _controllerPassword,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                                        hintText: "Enter your password",
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: const BorderSide(color: Color(0xFF203F81)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your password";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            senddata();
                                            // Handle login logic here
                                          }
                                        },
                                        height: 50,
                                        color: const Color(0xFF203F81),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Center(
                                    //   child: FadeInUp(
                                    //     duration: const Duration(milliseconds: 1500),
                                    //     child: TextButton(
                                    //       onPressed: () {
                                    //         // Handle forgot password logic here
                                    //       },
                                    //       child: const Text(
                                    //         "Forgot your password?",
                                    //         style: TextStyle(
                                    //           color: Colors.blueAccent,
                                    //           fontSize: 16,
                                    //           decoration: TextDecoration.underline,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.facebook, color: Colors.blue),
                                            onPressed: () {
                                              // Handle Facebook login logic here
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          IconButton(
                                            icon: const Icon(Icons.email, color: Colors.red),
                                            onPressed: () {
                                              // Handle Google login logic here
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text(
                                          "Don't have an account?",
                                          style: TextStyle(color: Colors.grey, fontSize: 16),
                                        ),
                                        TextButton(
                                          onPressed: () {

                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => RegMain()
                                            // )
                                            // );

                                            // Handle sign-up navigation here
                                          },
                                          child: const Text(
                                            "Sign Up",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 16,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  void senddata()async{
    String username=_controllerUsername.text;
    String password=_controllerPassword.text;

    SharedPreferences sh=await SharedPreferences.getInstance();
    String url=sh.getString('url').toString();
    final urls=Uri.parse(url+"/flutter_login");
    try{
      final response=await http.post(urls,body:{
        'username':username,
        'psw':password,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          Fluttertoast.showToast(msg: 'Success');
          String type = jsonDecode(response.body)['type'];

          String lid=jsonDecode(response.body)['lid'].toString();
          sh.setString("lid", lid);
          if (type=='user') {

            // String photo=sh.getString("imgurl").toString()+jsonDecode(response.body)['photo'];
            // String name=jsonDecode(response.body)['name'];
            // sh.setString("photo", photo);
            // sh.setString("name", name);
            // sh.setString("type", type);
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) => user_home(title: "Home"),)
            //
            // );
          }
          // else if(type=='police'){
          //   Navigator.push(context, MaterialPageRoute(
          //     builder: (context) => police_home(title: "Home"),));
          //
          // }


        }else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }

  }

}
