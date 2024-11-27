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

      title: 'Sent Requestaint',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const Request(title: 'View Reply'),
    );
  }
}

class Request extends StatefulWidget {
  const Request({super.key, required this.title});



  final String title;

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  TextEditingController Requestaintcontroller = new TextEditingController();
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
          title: Text(' Requests'),
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

                    controller: Requestaintcontroller,

                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Request",
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
                    sendRequestiant();
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

  void sendRequestiant() async {
    String Requestiant = Requestaintcontroller.text.toString();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String vid = sh.getString('vid').toString();
    final urls = Uri.parse(url + "/sent_v_request");
    try {
      final response = await http.post(urls, body: {
        'request': Requestiant,
        'lid': lid,
        'vid': vid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Request Sent');


          Navigator.push(context, MaterialPageRoute(
            builder: (context) => PetShopHomePage(),));
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

  String? validateRequestaint(String value) {
    if (value.isEmpty) {
      return 'Please enter a Requestaint';
    }
    return null;
  }
}
