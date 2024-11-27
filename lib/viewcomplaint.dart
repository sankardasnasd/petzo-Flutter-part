//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:petzo/sent_complaint.dart';
// import 'package:readmore/readmore.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const ViewReply());
// }
//
// class ViewReply extends StatelessWidget {
//   const ViewReply({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'View Reply',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const ViewComplaints(title: 'View Reply'),
//     );
//   }
// }
//
// class ViewComplaints extends StatefulWidget {
//   const ViewComplaints({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewComplaints> createState() => _ViewComplaintsState();
// }
//
// class _ViewComplaintsState extends State<ViewComplaints> {
//   List<int> id_ = [];
//   List<String> complaint_ = [];
//   List<String> date_ = [];
//   List<String> reply_ = [];
//
//   void viewComplaints() async {
//     List<int> id = <int>[];
//     List<String> date = <String>[];
//     List<String> complaint = <String>[];
//     List<String> reply = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String url = '$urls/user_view_reply';
//       String lid = sh.getString("lid").toString();
//       var data = await http.post(Uri.parse(url), body: {
//         "lid": lid,
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id']);
//         date.add(arr[i]['date'].toString());
//         complaint.add(arr[i]['complaint']);
//         reply.add(arr[i]['reply']);
//       }
//
//       setState(() {
//         id_ = id;
//         date_ = date;
//         complaint_ = complaint;
//         reply_ = reply;
//       });
//
//     } catch (e) {
//       print("Error: " + e.toString());
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     viewComplaints();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async { return true; },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: Text('View Complaints'),
//         ),
//         body: ListView.builder(
//           itemCount: id_.length,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               title: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 4,
//                   margin: EdgeInsets.all(8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Date: " + date_[index],
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Complaint: " + complaint_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Reply: " + reply_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         floatingActionButton: FloatingActionButton(onPressed: () {
//
//           Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => compl(title: '',)));
//
//         },backgroundColor: Colors.lightBlueAccent,
//
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }


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
      home: const ViewComplaints(title: 'View Reply'),
    );
  }
}

class ViewComplaints extends StatefulWidget {
  const ViewComplaints({super.key, required this.title});

  final String title;

  @override
  State<ViewComplaints> createState() => _ViewComplaintsState();
}

class _ViewComplaintsState extends State<ViewComplaints> {
  List<int> id_ = [];
  List<String> complaint_ = [];
  List<String> date_ = [];
  List<String> reply_ = [];

  // Backup lists for filtering
  List<int> filteredId = [];
  List<String> filteredComplaint = [];
  List<String> filteredDate = [];
  List<String> filteredReply = [];

  TextEditingController searchController = TextEditingController();

  void viewComplaints() async {
    List<int> id = <int>[];
    List<String> date = <String>[];
    List<String> complaint = <String>[];
    List<String> reply = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_reply';
      String lid = sh.getString("lid").toString();
      var data = await http.post(Uri.parse(url), body: {
        "lid": lid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        date.add(arr[i]['date'].toString());
        complaint.add(arr[i]['complaint']);
        reply.add(arr[i]['reply']);
      }

      setState(() {
        id_ = id;
        date_ = date;
        complaint_ = complaint;
        reply_ = reply;

        // Initialize filtered lists
        filteredId = id_;
        filteredDate = date_;
        filteredComplaint = complaint_;
        filteredReply = reply_;
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
        filteredComplaint = complaint_;
        filteredReply = reply_;
      });
    } else {
      // Filter the lists based on the date
      setState(() {
        filteredId = [];
        filteredDate = [];
        filteredComplaint = [];
        filteredReply = [];
        for (int i = 0; i < date_.length; i++) {
          if (date_[i].toLowerCase().contains(query.toLowerCase())) {
            filteredId.add(id_[i]);
            filteredDate.add(date_[i]);
            filteredComplaint.add(complaint_[i]);
            filteredReply.add(reply_[i]);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    viewComplaints();
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
          title: Text('View Complaints'),
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
                                "Complaint: " + filteredComplaint[index],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Reply: " + filteredReply[index],
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => compl(
                    title: '',
                  ),
                ));
          },
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
