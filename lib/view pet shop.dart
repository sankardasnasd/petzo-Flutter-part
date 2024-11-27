//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:petzo/sent_complaint.dart';
// import 'package:petzo/sent_feedback.dart';
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
//       home: const petshop(title: 'View Reply'),
//     );
//   }
// }
//
// class petshop extends StatefulWidget {
//   const petshop({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<petshop> createState() => _petshopState();
// }
//
// class _petshopState extends State<petshop> {
//
//
//
//
//
//   List<int> id_ = [];
//   List<String> name_ = [];
//   List<String> place_ = [];
//   List<String> district_ = [];
//   List<String> email_ = [];
//
//   void petshop() async {
//     List<int> id = <int>[];
//     List<String> name = <String>[];
//     List<String> place = <String>[];
//     List<String> district = <String>[];
//     List<String> email = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String url = '$urls/user_view_petshop';
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
//   name.add(arr[i]['name'].toString());
//         place.add(arr[i]['place']);
//         district.add(arr[i]['district']);
//         email.add(arr[i]['email']);
//       }
//
//       setState(() {
//         id_ = id;
//         name_ = name;
//         place_ = place;
//         district_ = district;
//         email_ = email;
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
//     petshop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async { return true; },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: Text('View petshop'),
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
//                           "Name: " + name_[index],
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         SizedBox(height: 10,),
//                         Text(
//                           "Place: " + place_[index],
//                           style: TextStyle(
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//
//                         Text(
//                           "District: " + district_[index],
//                           style: TextStyle(
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Email: " + email_[index],
//                           style: TextStyle(fontSize: 14),
//                         ),
//
//
//                         ElevatedButton(
//                           onPressed: () async {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             sh.setString('hid', id_[index].toString());
//
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => user_feed(title: '',),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.pink,
//                           ),
//                           child: Text('Rating', style: TextStyle(color: Colors.white)),
//                         ),
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
import 'package:petzo/petcare%20request.dart';
import 'package:petzo/sent_complaint.dart';
import 'package:petzo/sent_feedback.dart';
import 'package:petzo/view%20services.dart';
import 'package:readmore/readmore.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';

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
      home: const petshop(title: 'View Reply'),
    );
  }
}

class petshop extends StatefulWidget {
  const petshop({super.key, required this.title});

  final String title;

  @override
  State<petshop> createState() => _petshopState();
}

class _petshopState extends State<petshop> {
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

  void petshop() async {
    List<int> id = <int>[];
    List<String> name = <String>[];
    List<String> place = <String>[];
    List<String> district = <String>[];
    List<String> email = <String>[];
    List<String> LOGIN = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_shop';
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
        LOGIN_ = LOGIN;
        email_ = email;
        // Initialize filtered lists with full data
        filteredId = id_;
        filteredName = name_;
        filteredLOGIN = LOGIN_;
        filteredPlace = place_;
        filteredDistrict = district_;
        filteredEmail = email_;
      });
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  void filterpetshops(String query) {
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
    petshop();
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
          title: Text('View petshops'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search petshop by Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  filterpetshops(value);
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


                              SizedBox(height: 20),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sh =
                                      await SharedPreferences.getInstance();
                                      sh.setString(
                                          'pid', filteredId[index].toString());

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PetCareRequest(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                    ),
                                    child: Text('Request',
                                        style: TextStyle(color: Colors.white)),
                                  ),



                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sh = await SharedPreferences.getInstance();
                                      sh.setString('clid', LOGIN_[index].toString());

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyChatPage(title: '',)),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green, // Set the background color to green
                                    ),
                                    child: Icon(Icons.chat),
                                  ),

                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sh =
                                      await SharedPreferences.getInstance();
                                      sh.setString(
                                          'pid', filteredId[index].toString());

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewServices(title: '',),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text('Services',
                                        style: TextStyle(color: Colors.white)),
                                  ),


                                ],
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
