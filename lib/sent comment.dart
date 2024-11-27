import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:petzo/home.dart';


import 'package:shared_preferences/shared_preferences.dart';




void main() {
  runApp(const com());
}

class com extends StatelessWidget {
  const com({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Sent commentaint',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const comment(title: 'View Reply'),
    );
  }
}

class comment extends StatefulWidget {
  const comment({super.key, required this.title});



  final String title;

  @override
  State<comment> createState() => _commentState();
}

class _commentState extends State<comment> {
  TextEditingController commentaintcontroller = new TextEditingController();
  final _formkey=GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PetShopHomePage(),));

        return false;
      },
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.blue,
          title: Text(' Comment'),
        ),
        body: Form(
          key: _formkey,

          child: Center(

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                const SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(


                    controller: commentaintcontroller,

                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Comment",
                      prefixIcon: const Icon(Icons.report),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter .";
                      }

                      return null;
                    },
                  ),
                ),

                ElevatedButton(onPressed: () {
                  if (_formkey.currentState!.validate()){
                    sendcommentiant();
                  }



                }, child: Text('Send'), style: ElevatedButton.styleFrom(
                )
                )


              ],
            ),
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void sendcommentiant() async {
    String commentiant = commentaintcontroller.text.toString();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String pid = sh.getString('pid').toString();
    final urls = Uri.parse(url + "/user_send_comment");
    try {
      final response = await http.post(urls, body: {
        'comment': commentiant,
        'lid': lid,
        'pid': pid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Comment');


          Navigator.push(context, MaterialPageRoute(
            builder: (context) => PetShopHomePage(),)

          );
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  String? validatecommentaint(String value) {
    if (value.isEmpty) {
      return 'Please enter a commentaint';
    }
    return null;
  }
}
