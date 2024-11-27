//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:petzo/sent%20service%20request.dart';
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
//       home: const ViewServicesRequest(title: 'View Reply'),
//     );
//   }
// }
//
// class ViewServicesRequest extends StatefulWidget {
//   const ViewServicesRequest({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewServicesRequest> createState() => _ViewServicesRequestState();
// }
//
// class _ViewServicesRequestState extends State<ViewServicesRequest> {
//   List<int> id_ = [];
//   List<String> SERVICES_ = [];
//   List<String> SHOP_ = [];
//   List<String> date_ = [];
//   List<String> request_ = [];
//   List<String> status_ = [];
//
//
//
//
//   void ViewServicesRequest() async {
//     List<int> id = <int>[];
//     List<String> SERVICES = <String>[];
//     List<String> SHOP = <String>[];
//     List<String> date = <String>[];
//     List<String> request = <String>[];
//     List<String> status = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String url = '$urls/user_view_service_request_status';
//       String lid = sh.getString("lid").toString();
//       // String pid = sh.getString("pid").toString();
//       var data = await http.post(Uri.parse(url), body: {
//         "lid": lid,
//         // "pid": pid,
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id']);
//         SERVICES.add(arr[i]['SERVICES'].toString());
//         SHOP.add(arr[i]['SHOP']);
//         date.add(arr[i]['date']);
//         request.add(arr[i]['request']);
//         status.add(arr[i]['status']);
//       }
//
//       setState(() {
//         id_ = id;
//         SERVICES_ = SERVICES;
//         SHOP_ = SHOP;
//         date_ = date;
//         request_ = request;
//         status_ = status;
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
//     ViewServicesRequest();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async { return true; },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: Text('View Services Request'),
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
//                           "Service Name: " + SERVICES_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         SizedBox(height: 8),
//
//                         Text(
//                           "Shop Name: " + SHOP_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
// SizedBox(height: 8),
//
//                         Text(
//                           "Request: " + request_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
// SizedBox(height: 8),
//
//                         Text(
//                           "Status: " + status_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
//
//                         // SizedBox(height: 18),
//                         //
//                         // ElevatedButton(
//                         //   onPressed: () async {
//                         //     SharedPreferences sh =
//                         //     await SharedPreferences.getInstance();
//                         //     sh.setString(
//                         //         'sid', id_[index].toString());
//                         //
//                         //     Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //         builder: (context) =>
//                         //             SentServicesRequest(title: '',),
//                         //       ),
//                         //     );
//                         //   },
//                         //   style: ElevatedButton.styleFrom(
//                         //     backgroundColor: Colors.blue,
//                         //   ),
//                         //   child: Text('Request',
//                         //       style: TextStyle(color: Colors.white)),
//                         // ),
//
//
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
      home: const ViewServicesRequest(title: 'View Reply'),
    );
  }
}

class ViewServicesRequest extends StatefulWidget {
  const ViewServicesRequest({super.key, required this.title});

  final String title;

  @override
  State<ViewServicesRequest> createState() => _ViewServicesRequestState();
}

class _ViewServicesRequestState extends State<ViewServicesRequest> {
  List<int> id_ = [];
  List<String> SERVICES_ = [];
  List<String> SHOP_ = [];
  List<String> date_ = [];
  List<String> request_ = [];
  List<String> status_ = [];
  List<int> filteredId = [];
  List<String> filteredServices = [];
  List<String> filteredShop = [];
  List<String> filteredDate = [];
  List<String> filteredRequest = [];
  List<String> filteredStatus = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ViewServicesRequest();
  }

  void ViewServicesRequest() async {
    List<int> id = <int>[];
    List<String> SERVICES = <String>[];
    List<String> SHOP = <String>[];
    List<String> date = <String>[];
    List<String> request = <String>[];
    List<String> status = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_service_request_status';
      String lid = sh.getString("lid").toString();
      var data = await http.post(Uri.parse(url), body: {
        "lid": lid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        SERVICES.add(arr[i]['SERVICES'].toString());
        SHOP.add(arr[i]['SHOP']);
        date.add(arr[i]['date']);
        request.add(arr[i]['request']);
        status.add(arr[i]['status']);
      }

      setState(() {
        id_ = id;
        SERVICES_ = SERVICES;
        SHOP_ = SHOP;
        date_ = date;
        request_ = request;
        status_ = status;
        filteredId = List.from(id_);
        filteredServices = List.from(SERVICES_);
        filteredShop = List.from(SHOP_);
        filteredDate = List.from(date_);
        filteredRequest = List.from(request_);
        filteredStatus = List.from(status_);
      });
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredId = List.from(id_);
        filteredServices = List.from(SERVICES_);
        filteredShop = List.from(SHOP_);
        filteredDate = List.from(date_);
        filteredRequest = List.from(request_);
        filteredStatus = List.from(status_);
      } else {
        filteredId = [];
        filteredServices = [];
        filteredShop = [];
        filteredDate = [];
        filteredRequest = [];
        filteredStatus = [];

        for (int i = 0; i < date_.length; i++) {
          if (date_[i].contains(query)) {
            filteredId.add(id_[i]);
            filteredServices.add(SERVICES_[i]);
            filteredShop.add(SHOP_[i]);
            filteredDate.add(date_[i]);
            filteredRequest.add(request_[i]);
            filteredStatus.add(status_[i]);
          }
        }
      }
    });
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
          title: Text('View Services Request'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by date (YYYY-MM-DD)',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: _filterSearch,
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
                                "Service Name: " + filteredServices[index],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Shop Name: " + filteredShop[index],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Request: " + filteredRequest[index],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Status: " + filteredStatus[index],
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
