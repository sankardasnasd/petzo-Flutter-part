//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:petzo/home.dart';
//
// import 'package:readmore/readmore.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'add user pet.dart';
//
//
// void main() {
//   runApp(const ViewUserPet_less());
// }
//
// class ViewUserPet_less extends StatelessWidget {
//   const ViewUserPet_less({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'View Reply',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
//         useMaterial3: true,
//       ),
//       home: const ViewUserPet(title: 'View Reply'),
//     );
//   }
// }
//
// class ViewUserPet extends StatefulWidget {
//   const ViewUserPet({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ViewUserPet> createState() => _ViewUserPetState();
// }
//
// class _ViewUserPetState extends State<ViewUserPet> {
//   _ViewUserPetState() {
//     ViewUserPets();
//   }
//
//
//
//
//   List<int> id_ = [];
//   List<String> USER_ = [];
//   List<String> petname_ = [];
//   List<String> type_ = [];
//   List<String> image_ = [];
//   List<String> price_ = [];
//   List<String> age_ = [];
//
//   void ViewUserPets() async {
//     List<int> id = <int>[];
//     List<String> USER = <String>[];
//     List<String> petname = <String>[];
//     List<String> type = <String>[];
//     List<String> image = <String>[];
//     List<String> price = <String>[];
//     List<String> age = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String url = '$urls/user_view_user_pets';
//       // String lid = sh.getString("lid").toString();
//
//       // print(image);
//       var data = await http.post(Uri.parse(url), body: {
//         // "lid": lid,
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id']);
//         USER.add(arr[i]['USER']);
//         petname.add(arr[i]['petname'].toString());
//         type.add(arr[i]['type'].toString());
//         price.add(arr[i]['price'].toString());
//         age.add(arr[i]['age'].toString());
//         image.add(sh.getString('imgurl').toString() + arr[i]['image']);
//       }
//
//       setState(() {
//         id_ = id;
//         age_ = age;
//         USER_ = USER;
//         petname_ = petname;
//         image_ = image;
//         type_ = type;
//         price_ = price;
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.blue,
//           elevation: 0.0,
//           leadingWidth: 0.0,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.blue,
//                 radius: 20.0,
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => PetShopHomePage()));
//                   },
//                   splashRadius: 1.0,
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                     size: 24.0,
//                   ),
//                 ),
//               ),
//               Text(
//                 'Pets',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(
//                 width: 40.0,
//                 child: IconButton(
//                   onPressed: () {},
//                   splashRadius: 1.0,
//                   icon: Icon(
//                     Icons.more_vert,
//                     color: Colors.blue,
//                     size: 34.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: ListView.builder(
//           physics: BouncingScrollPhysics(),
//           itemCount: id_.length,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               onLongPress: () {
//                 print("long press" + index.toString());
//               },
//               title: Padding(
//                   padding: const EdgeInsets.all(0),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 400,
//                         child: Card(
//                           elevation: 6,
//                           margin: EdgeInsets.all(10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Container(
//                             color: Colors.white70,
//                             padding: EdgeInsets.all(16),
//                             child: InkWell(
//
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: 250.0, // Set the width of the rectangle
//                                         height: 250.0, // Set the height of the rectangle
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             image: NetworkImage(image_[index]),
//                                             fit: BoxFit.cover, // Ensures the image fits within the rectangle
//                                           ),
//                                           borderRadius: BorderRadius.circular(8.0), // Optional: Add slight rounding to the corners
//                                           color: Colors.grey[200], // Optional: Placeholder color
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//
//
//                                   SizedBox(height: 10,),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text("Name: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                                       Text(USER_[index]),
//                                     ],
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text("Pet Name: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                                       Text(petname_[index]),
//                                     ],
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text("Age: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                                       Text(age_[index]),
//                                     ],
//                                   ), SizedBox(height: 10,),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text("Price: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                                       Text(price_[index]),
//                                     ],
//                                   ),
//
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//             );
//           },
//         ),
//
//         floatingActionButton: FloatingActionButton(onPressed: () {
//
//           Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AddUserPet()));
//
//         },backgroundColor: Colors.lightBlueAccent,
//
//           child: Icon(Icons.add),
//         ),
//
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add user pet.dart';

class ViewUserPet extends StatefulWidget {
  const ViewUserPet({super.key, required this.title});

  final String title;

  @override
  State<ViewUserPet> createState() => _ViewUserPetState();
}

class _ViewUserPetState extends State<ViewUserPet> {
  List<int> id_ = [];
  List<String> USER_ = [];
  List<String> petname_ = [];
  List<String> type_ = [];
  List<String> image_ = [];
  List<String> price_ = [];
  List<String> age_ = [];

  List<String> filteredType_ = [];
  String selectedType = "All";

  @override
  void initState() {
    super.initState();
    ViewUserPets();
  }

  void ViewUserPets() async {
    List<int> id = <int>[];
    List<String> USER = <String>[];
    List<String> petname = <String>[];
    List<String> type = <String>[];
    List<String> image = <String>[];
    List<String> price = <String>[];
    List<String> age = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_user_pets';

      var data = await http.post(Uri.parse(url));
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        USER.add(arr[i]['USER']);
        petname.add(arr[i]['petname'].toString());
        type.add(arr[i]['type'].toString());
        price.add(arr[i]['price'].toString());
        age.add(arr[i]['age'].toString());
        image.add(sh.getString('imgurl').toString() + arr[i]['image']);
      }

      setState(() {
        id_ = id;
        USER_ = USER;
        petname_ = petname;
        type_ = type;
        price_ = price;
        age_ = age;
        image_ = image;
        filteredType_ = type;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  void filterPetsByType(String type) {
    setState(() {
      selectedType = type;
      if (type == "All") {
        filteredType_ = type_;
      } else {
        filteredType_ = type_.where((t) => t == type).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pets'),
        backgroundColor: Colors.blue,
        actions: [
          DropdownButton<String>(
            value: selectedType,
            icon: const Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.white,
            items: <String>["All", ...type_.toSet()].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                filterPetsByType(newValue);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredType_.length,
        itemBuilder: (BuildContext context, int index) {
          // Index for the filtered list
          int originalIndex = type_.indexOf(filteredType_[index]);

          return ListTile(
            title: Card(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 250.0, // Set the width of the rectangle
                                        height: 250.0, // Set the height of the rectangle
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(image_[index]),
                                            fit: BoxFit.cover, // Ensures the image fits within the rectangle
                                          ),
                                          borderRadius: BorderRadius.circular(8.0), // Optional: Add slight rounding to the corners
                                          color: Colors.grey[200], // Optional: Placeholder color
                                        ),
                                      ),
                                    ],
                                  ),
                  // Image.network(image_[originalIndex], height: 150, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("User Name: ${USER_[originalIndex]}"),
                  ), Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Pet Name: ${petname_[originalIndex]}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Type: ${type_[originalIndex]}"),
                  ),  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Price: ${price_[originalIndex]}"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUserPet(

                ),
              ));
        },
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
