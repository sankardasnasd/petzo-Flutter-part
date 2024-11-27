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
//       home: const vaccine(title: 'View Reply'),
//     );
//   }
// }
//
// class vaccine extends StatefulWidget {
//   const vaccine({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<vaccine> createState() => _vaccineState();
// }
//
// class _vaccineState extends State<vaccine> {
//
//
//
//
//
//   List<int> id_ = [];
//   List<String> HOSPITAL_ = [];
//   List<String> dateupto_ = [];
//   List<String> vaccinename_ = [];
//   List<String> details_ = [];
//   List<String> uploadeddate_ = [];
//
//   void vaccine() async {
//     List<int> id = <int>[];
//     List<String> dateupto = <String>[];
//     List<String> HOSPITAL = <String>[];
//     List<String> vaccinename = <String>[];
//     List<String> details = <String>[];
//     List<String> uploadeddate = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String url = '$urls/user_view_vaccine';
//       // String lid = sh.getString("lid").toString();
//       var data = await http.post(Uri.parse(url), body: {
//         // "lid": lid,
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id']);
//   dateupto.add(arr[i]['dateupto'].toString());
//   HOSPITAL.add(arr[i]['HOSPITAL']);
//   vaccinename.add(arr[i]['vaccinename']);
//   details.add(arr[i]['details']);
//   uploadeddate.add(arr[i]['uploadeddate']);
//       }
//
//       setState(() {
//         id_ = id;
//         dateupto_ = dateupto;
//         HOSPITAL_ = HOSPITAL;
//   vaccinename_ = vaccinename;
//   details_ = details;
//   uploadeddate_ = uploadeddate;
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
//     vaccine();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async { return true; },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: Text('View Vaccine'),
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
//                           "Date: " + uploadeddate_[index],
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         SizedBox(height: 10,),
//                         Text(
//                           "Hospital: " + HOSPITAL_[index],
//                           style: TextStyle(
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//
//                         Text(
//                           "Expire Date: " + uploadeddate_[index],
//                           style: TextStyle(
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Vaccine: " + vaccinename_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Details: " + details_[index],
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
//
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petzo/sent%20request.dart';
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
      home: const VaccineScreen(title: 'View Vaccine'),
    );
  }
}

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key, required this.title});

  final String title;

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  List<int> id_ = [];
  List<String> HOSPITAL_ = [];
  List<String> dateupto_ = [];
  List<String> vaccinename_ = [];
  List<String> details_ = [];
  List<String> uploadeddate_ = [];
  List<int> filteredIds = [];

  TextEditingController searchController = TextEditingController();

  void fetchVaccineData() async {
    List<int> id = <int>[];
    List<String> dateupto = <String>[];
    List<String> HOSPITAL = <String>[];
    List<String> vaccinename = <String>[];
    List<String> details = <String>[];
    List<String> uploadeddate = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_vaccine';

      var data = await http.post(Uri.parse(url));
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        dateupto.add(arr[i]['dateupto'].toString());
        HOSPITAL.add(arr[i]['HOSPITAL']);
        vaccinename.add(arr[i]['vaccinename']);
        details.add(arr[i]['details']);
        uploadeddate.add(arr[i]['uploadeddate']);
      }

      setState(() {
        id_ = id;
        dateupto_ = dateupto;
        HOSPITAL_ = HOSPITAL;
        vaccinename_ = vaccinename;
        details_ = details;
        uploadeddate_ = uploadeddate;
        filteredIds = List<int>.from(id_); // Initially, show all IDs
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void filterSearch(String query) {
    List<int> results = [];
    for (int i = 0; i < id_.length; i++) {
      if (vaccinename_[i].toLowerCase().contains(query.toLowerCase()) ||
          uploadeddate_[i].toLowerCase().contains(query.toLowerCase())) {
        results.add(id_[i]);
      }
    }
    setState(() {
      filteredIds = results;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchVaccineData();
    searchController.addListener(() {
      filterSearch(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Date or Vaccine Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredIds.length,
              itemBuilder: (BuildContext context, int index) {
                int actualIndex = id_.indexOf(filteredIds[index]);
                return Padding(
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
                            "Date: " + uploadeddate_[actualIndex],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Hospital: " + HOSPITAL_[actualIndex],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Expire Date: " + dateupto_[actualIndex],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Vaccine: " + vaccinename_[actualIndex],
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Details: " + details_[actualIndex],
                            style: TextStyle(fontSize: 14),
                          ),

                          ElevatedButton(
                            onPressed: () async {
                              SharedPreferences sh =
                              await SharedPreferences.getInstance();
                              sh.setString(
                                  'vid', id_[index].toString());

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Request(title: ''),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                            ),
                            child: Text('Request',
                                style: TextStyle(color: Colors.white)),
                          ),

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
    );
  }
}
