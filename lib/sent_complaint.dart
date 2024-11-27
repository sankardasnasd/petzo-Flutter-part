import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:petzo/home.dart';
import 'package:petzo/viewcomplaint.dart';


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

      title: 'Sent Complaint',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const compl(title: 'View Reply'),
    );
  }
}

class compl extends StatefulWidget {
  const compl({super.key, required this.title});



  final String title;

  @override
  State<compl> createState() => _complState();
}

class _complState extends State<compl> {
  TextEditingController complaintcontroller = new TextEditingController();
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
          title: Text(' Complaints'),
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

                    maxLines: 4,

                    controller: complaintcontroller,

                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Complaint",
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
                        return "Please enter Complaint.";
                      }

                      return null;
                    },
                  ),
                ),

                ElevatedButton(onPressed: () {
                  if (_formkey.currentState!.validate()){
                    sendcompliant();
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

  void sendcompliant() async {
    String compliant = complaintcontroller.text.toString();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    final urls = Uri.parse(url + "/send_complaint");
    try {
      final response = await http.post(urls, body: {
        'complaint': compliant,
        'lid': lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Complaint Sent');


          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ViewComplaints(title: "Home"),));
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

  String? validatecomplaint(String value) {
    if (value.isEmpty) {
      return 'Please enter a complaint';
    }
    return null;
  }
}
