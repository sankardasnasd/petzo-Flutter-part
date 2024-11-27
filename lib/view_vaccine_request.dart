

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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
      home: const ViewVaccineRequest(title: 'View Reply'),
    );
  }
}

class ViewVaccineRequest extends StatefulWidget {
  const ViewVaccineRequest({super.key, required this.title});

  final String title;

  @override
  State<ViewVaccineRequest> createState() => _ViewVaccineRequestState();
}

class _ViewVaccineRequestState extends State<ViewVaccineRequest> {
  List<int> id_ = [];
  List<String> VACCINE_ = [];
  List<String> HOSPITAL_ = [];
  List<String> status_ = [];
  List<String> request_ = [];
  List<String> date_ = [];

  // For search functionality
  List<int> filteredId = [];
  List<String> filteredVACCINE = [];
  List<String> filteredHOSPITAL = [];
  List<String> filteredStatus = [];
  List<String> filteredRequest = [];
  List<String> filteredDate = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewVaccineRequest();
  }

  Future<void> viewVaccineRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? urlBase = prefs.getString('url');
      String? lid = prefs.getString('lid'); // Retrieve `lid` from SharedPreferences

      if (urlBase != null && lid != null) {
        String url = '$urlBase/user_view_vaccine_status';
        var response = await http.post(
          Uri.parse(url),
          body: {'lid': lid}, // Sending `lid` in the POST request
        );

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          var data = jsonData['data'] as List;

          setState(() {
            id_ = data.map<int>((item) => int.parse(item['id'].toString())).toList();
            VACCINE_ = data.map<String>((item) => item['VACCINE'].toString()).toList();
            HOSPITAL_ = data.map<String>((item) => item['HOSPITAL'].toString()).toList();
            status_ = data.map<String>((item) => item['status'].toString()).toList();
            request_ = data.map<String>((item) => item['request'].toString()).toList();
            date_ = data.map<String>((item) => item['date'].toString()).toList();

            // Initialize filtered lists with full data
            filteredId = id_;
            filteredVACCINE = VACCINE_;
            filteredHOSPITAL = HOSPITAL_;
            filteredStatus = status_;
            filteredRequest = request_;
            filteredDate = date_;
          });
        } else {
          print("Failed to load data. Status code: ${response.statusCode}");
        }
      } else {
        print("URL or lid not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void filterVaccineRequests(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredId = id_;
        filteredVACCINE = VACCINE_;
        filteredHOSPITAL = HOSPITAL_;
        filteredStatus = status_;
        filteredRequest = request_;
        filteredDate = date_;
      });
    } else {
      setState(() {
        filteredId = [];
        filteredVACCINE = [];
        filteredHOSPITAL = [];
        filteredStatus = [];
        filteredRequest = [];
        filteredDate = [];

        for (int i = 0; i < VACCINE_.length; i++) {
          if (VACCINE_[i].toLowerCase().contains(query.toLowerCase())) {
            filteredId.add(id_[i]);
            filteredVACCINE.add(VACCINE_[i]);
            filteredHOSPITAL.add(HOSPITAL_[i]);
            filteredStatus.add(status_[i]);
            filteredRequest.add(request_[i]);
            filteredDate.add(date_[i]);
          }
        }
      });
    }
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
          title: const Text('View Vaccine Requests'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Vaccine Request by Name',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  filterVaccineRequests(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredId.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: ${filteredDate[index]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Vaccine Name: ${filteredVACCINE[index]}"),
                            const SizedBox(height: 10),
                            Text("Hospital: ${filteredHOSPITAL[index]}"),
                            const SizedBox(height: 10),
                            Text("Request: ${filteredRequest[index]}"),
                            const SizedBox(height: 8),
                            Text("Status: ${filteredStatus[index]}",
                                style: const TextStyle(fontSize: 14)),

                          ],
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
