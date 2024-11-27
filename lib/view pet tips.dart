

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:petzo/sent_complaint.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const ViewTips(title: 'View Reply'),
    );
  }
}

class ViewTips extends StatefulWidget {
  const ViewTips({super.key, required this.title});

  final String title;

  @override
  State<ViewTips> createState() => _ViewTipsState();
}




class _ViewTipsState extends State<ViewTips> {
  List<int> id_ = [];
  List<String> HOSPITAL_ = [];
  List<String> date_ = [];
  List<String> tips_ = [];
  List<String> details_ = [];
  List<String> pet_type_ = [];
  List<String> age_ = [];

  // Backup lists for filtering
  List<int> filteredId = [];
  List<String> filteredHOSPITAL = [];
  List<String> filteredDate = [];
  List<String> filteredtips = [];
  List<String> filtereddetails = [];
  List<String> filteredpet_type = [];
  List<String> filteredage = [];

  TextEditingController searchController = TextEditingController();

  void ViewTips() async {
    List<int> id = <int>[];
    List<String> date = <String>[];
    List<String> HOSPITAL = <String>[];
    List<String> tips = <String>[];
    List<String> details = <String>[];
    List<String> pet_type = <String>[];
    List<String> age = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_tips';
      // String lid = sh.getString("lid").toString();
      var data = await http.post(Uri.parse(url), body: {
        // "lid": lid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        date.add(arr[i]['date'].toString());
HOSPITAL.add(arr[i]['HOSPITAL']);
tips.add(arr[i]['tips']);
details.add(arr[i]['details']);
pet_type.add(arr[i]['pet_type']);
        age.add(arr[i]['age']);
      }

      setState(() {
        id_ = id;
        date_ = date;
        HOSPITAL_ = HOSPITAL;
tips_ = tips;
details_ = details;
pet_type_ = pet_type;
        age_ = age;

        // Initialize filtered lists
        filteredId = id_;
        filteredDate = date_;
        filteredHOSPITAL = HOSPITAL_;
        filteredtips = tips_;
        filtereddetails = details_;
        filteredpet_type = pet_type_;
        filteredage = age_;
      });
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  void filterComplaints(String query) {
    if (query.isEmpty) {
      // If the search query is empty, reset to original data
      setState(() {
        filteredId = id_;
        filteredDate = date_;
        filteredHOSPITAL = HOSPITAL_;
        filteredtips = tips_;
        filtereddetails = details_;
        filteredpet_type = pet_type_;
        filteredage = age_;
      });
    } else {
      // Filter the lists based on the date
      setState(() {
        filteredId = [];
        filteredDate = [];
        filteredHOSPITAL = [];
        filteredtips = [];
        filtereddetails = [];
        filteredpet_type = [];
        filteredage = [];
        for (int i = 0; i < date_.length; i++) {
          if (date_[i].toLowerCase().contains(query.toLowerCase())) {
            filteredId.add(id_[i]);
            filteredDate.add(date_[i]);
            filteredHOSPITAL.add(HOSPITAL_[i]);
            filteredtips.add(tips_[i]);
            filtereddetails.add(details_[i]);
            filteredpet_type.add(pet_type_[i]);
            filteredage.add(age_[i]);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ViewTips();
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
          title: Text('View Tips'),
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search by Date eg: 2024-11-23  ",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (query) {
                  filterComplaints(query);
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
                                "Date: " + filteredDate[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),

                              Text(
                                "Hospital: " + filteredHOSPITAL[index],

                                ),
                              SizedBox(height: 8),

                              Text(
                                "Pet Type: " + filteredpet_type[index],

                                ),
                              SizedBox(height: 8),
                              Text(
                                "Pet Age: " + age_[index],

                                ),

                              SizedBox(height: 8),
                              Text(
                                "Tips: " + filteredtips[index],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Details: " + filtereddetails[index],
                                style: TextStyle(fontSize: 14),
                              ),
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
