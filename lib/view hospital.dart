import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:petzo/sent_complaint.dart';
import 'package:petzo/sent_feedback.dart';
import 'package:readmore/readmore.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'hs_chat.dart';

void main() {
  runApp(const ViewReply());
}

class ViewReply extends StatelessWidget {
  const ViewReply({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'View Reply',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Hospital(title: 'View Reply'),
    );
  }
}

class Hospital extends StatefulWidget {
  const Hospital({super.key, required this.title});

  final String title;

  @override
  State<Hospital> createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  List<int> id_ = [];
  List<String> name_ = [];
  List<String> place_ = [];
  List<String> district_ = [];
  List<String> email_ = [];
  List<String> LOGIN_ = [];

  // For search functionality
  List<int> filteredId = [];
  List<String> filteredName = [];
  List<String> filteredPlace = [];
  List<String> filteredDistrict = [];
  List<String> filteredEmail = [];
  List<String> filteredLOGIN = [];
  TextEditingController searchController = TextEditingController();

  void hospital() async {
    List<int> id = <int>[];
    List<String> name = <String>[];
    List<String> place = <String>[];
    List<String> district = <String>[];
    List<String> email = <String>[];
    List<String> LOGIN = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? ''; // Ensure non-null URL
      String url = '$urls/user_view_hospital';
      var data = await http.post(Uri.parse(url), body: {});
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        name.add(arr[i]['name'].toString());
        place.add(arr[i]['place']);
        district.add(arr[i]['district']);
        email.add(arr[i]['email']);
        LOGIN.add(arr[i]['LOGIN']);
      }

      setState(() {
        id_ = id;
        name_ = name;
        place_ = place;
        district_ = district;
        email_ = email;
        LOGIN_ = LOGIN;
        // Initialize filtered lists with full data
        filteredId = id_;
        filteredName = name_;
        filteredPlace = place_;
        filteredDistrict = district_;
        filteredEmail = email_;
        filteredLOGIN = LOGIN_;
      });
    } catch (e) {
      print("Error: " + e.toString());
      Fluttertoast.showToast(msg: "Failed to load hospital data.");
    }
  }

  void filterHospitals(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredId = id_;
        filteredName = name_;
        filteredPlace = place_;
        filteredDistrict = district_;
        filteredEmail = email_;
        filteredLOGIN = LOGIN_;
      });
    } else {
      setState(() {
        filteredId = [];
        filteredName = [];
        filteredPlace = [];
        filteredDistrict = [];
        filteredEmail = [];
        filteredLOGIN = [];
        for (int i = 0; i < name_.length; i++) {
          if (name_[i].toLowerCase().contains(query.toLowerCase())) {
            filteredId.add(id_[i]);
            filteredName.add(name_[i]);
            filteredPlace.add(place_[i]);
            filteredDistrict.add(district_[i]);
            filteredEmail.add(email_[i]);
            filteredLOGIN.add(LOGIN_[i]);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    hospital();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('View Hospitals'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Hospital by Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  filterHospitals(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredId.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: " + filteredName[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Place: " + filteredPlace[index],
                                style: TextStyle(),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "District: " + filteredDistrict[index],
                                style: TextStyle(),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Email: " + filteredEmail[index],
                                style: TextStyle(fontSize: 14),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Check if id_ is valid and not empty
                                      if (id_ != null && id_.isNotEmpty && index < id_.length) {
                                        // Store the selected id in SharedPreferences
                                        SharedPreferences sh = await SharedPreferences.getInstance();
                                        sh.setString('hid', id_[index].toString());

                                        // Navigate to the User_Feedback screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserFeedback(title: 'Your Title'),
                                          ),
                                        );
                                      } else {
                                        // Handle error: id_ is null, empty or invalid index
                                        print("Error: Invalid id_ list or index");
                                        Fluttertoast.showToast(msg: "Error: Invalid hospital data.");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                    ),
                                    child: Text('Rating', style: TextStyle(color: Colors.white)),
                                  ),


                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sh = await SharedPreferences.getInstance();
                                      sh.setString('clid', LOGIN_[index].toString());

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HsMyChatPage(title: '',)),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green, // Set the background color to green
                                    ),
                                    child: Icon(Icons.chat),
                                  ),

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
