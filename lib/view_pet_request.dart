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
      home: const ViewPetRequest(title: 'View Reply'),
    );
  }
}

class ViewPetRequest extends StatefulWidget {
  const ViewPetRequest({super.key, required this.title});

  final String title;

  @override
  State<ViewPetRequest> createState() => _ViewPetRequestState();
}

class _ViewPetRequestState extends State<ViewPetRequest> {
  List<int> id_ = [];
  List<String> pettype_ = [];
  List<String> age_ = [];
  List<String> status_ = [];
  List<String> details_ = [];
  List<String> date_ = [];

  // For search functionality
  List<int> filteredId = [];
  List<String> filteredpettype = [];
  List<String> filteredage = [];
  List<String> filteredStatus = [];
  List<String> filtereddetails = [];
  List<String> filteredDate = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ViewPetRequest(); // Calls the method to load data when the screen is created
  }

  // Function to fetch the pet request data
  Future<void> ViewPetRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? urlBase = prefs.getString('url');
      String? lid = prefs.getString('lid'); // Retrieve `lid` from SharedPreferences

      if (urlBase != null && lid != null) {
        String url = '$urlBase/user_view_petcare_request';
        var response = await http.post(
          Uri.parse(url),
          body: {'lid': lid}, // Sending `lid` in the POST request
        );

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          var data = jsonData['data'] as List;

          setState(() {
            id_ = data.map<int>((item) => int.parse(item['id'].toString())).toList();
            pettype_ = data.map<String>((item) => item['pettype'].toString()).toList();
            age_ = data.map<String>((item) => item['age'].toString()).toList();
            status_ = data.map<String>((item) => item['status'].toString()).toList();
            details_ = data.map<String>((item) => item['details'].toString()).toList();
            date_ = data.map<String>((item) => item['date'].toString()).toList();

            // Initialize filtered lists with full data
            filteredId = id_;
            filteredpettype = pettype_;
            filteredage = age_;
            filteredStatus = status_;
            filtereddetails = details_;
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

  // Function to filter vaccine requests based on search query (search by date)
  void filterByDate(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredId = id_;
        filteredpettype = pettype_;
        filteredage = age_;
        filteredStatus = status_;
        filtereddetails = details_;
        filteredDate = date_;
      });
    } else {
      setState(() {
        filteredId = [];
        filteredpettype = [];
        filteredage = [];
        filteredStatus = [];
        filtereddetails = [];
        filteredDate = [];

        for (int i = 0; i < date_.length; i++) {
          if (date_[i].toLowerCase().contains(query.toLowerCase())) {
            filteredId.add(id_[i]);
            filteredpettype.add(pettype_[i]);
            filteredage.add(age_[i]);
            filteredStatus.add(status_[i]);
            filtereddetails.add(details_[i]);
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
          title: const Text('View Petcare Requests'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Request by Date',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  filterByDate(value); // Call the function to filter by date
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
                            Text("Pet Type: ${filteredpettype[index]}"),
                            const SizedBox(height: 10),
                            Text("Age: ${filteredage[index]}"),
                            const SizedBox(height: 10),
                            Text("Details: ${filtereddetails[index]}"),
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
