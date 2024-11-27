

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:petzo/profile.dart';
import 'package:petzo/user_view_service_request_status.dart';
import 'package:petzo/view%20hospital.dart';
import 'package:petzo/view%20pet%20shop.dart';
import 'package:petzo/view%20pet%20tips.dart';
import 'package:petzo/view%20pet.dart';
import 'package:petzo/view%20post.dart';
import 'package:petzo/view%20vaccine.dart';
import 'package:petzo/view_pet_request.dart';
import 'package:petzo/view_vaccine_request.dart';
import 'package:petzo/viewcomplaint.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'add post.dart';
import 'add user pet.dart';
import 'login.dart';
import 'logins.dart';

void main() {
  runApp(MaterialApp(
    home: PetShopHomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class PetShopHomePage extends StatefulWidget {
  @override
  _PetShopHomePageState createState() => _PetShopHomePageState();
}

class _PetShopHomePageState extends State<PetShopHomePage> {
  final List<String> carouselImages = [
    'assets/dog.jpg',
    'assets/cat.jpg',
    'assets/fish.jpg',
    'assets/bird.jpg',
  ];

  final List<Map<String, String>> petCategories = [
    {'icon': 'assets/dog.jpg', 'title': 'Dogs'},
    {'icon': 'assets/cat.jpg', 'title': 'Cats'},
    {'icon': 'assets/fish.jpg', 'title': 'Fish'},
    {'icon': 'assets/bird.jpg', 'title': 'Birds'},
    {'icon': 'assets/other.jpg', 'title': 'Others'},
  ];

  List<int> id_ = [];
  List<String> petname_ = [];
  List<String> image_ = [];
  List<String> type_ = [];
  List<String> age_ = [];
  List<String> price_ = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    view_pets(); // Fetch pet details on page load
  }

  Future<void> view_pets() async {
    List<int> id = <int>[];
    List<String> petname = <String>[];
    List<String> image = <String>[];
    List<String> type = <String>[];
    List<String> age = <String>[];
    List<String> price = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_View_Pet';

      var data = await http.post(Uri.parse(url), body: {});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        petname.add(arr[i]['petname']);
        type.add(arr[i]['type'].toString());
        age.add(arr[i]['age'].toString());
        price.add(arr[i]['price'].toString());
        image.add(sh.getString('imgurl').toString() + arr[i]['image']);
      }

      setState(() {
        id_ = id;
        petname_ = petname;
        type_ = type;
        age_ = age;
        image_ = image;
        price_ = price;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  // Handle Bottom Navigation Item Taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: ()async{
       Navigator.push(context, MaterialPageRoute(builder: (context) => PetShopHomePage()));
  return false;

     },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            'Pet Shop',
            style: TextStyle(color: Colors.white),
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   onPressed: () {
          //     Scaffold.of(context).openDrawer(); // Open drawer when menu button is pressed
          //   },
          // ),
        ),
    //     drawer: Drawer(
    //       child: ListView(
    //         padding: EdgeInsets.zero,
    //         children: <Widget>[
    //           DrawerHeader(
    //             decoration: BoxDecoration(
    //               color: Colors.orange,
    //             ),
    //             child: Text(
    //               'Pet Shop Menu',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 24,
    //               ),
    //             ),
    //           ),
    //           ListTile(
    //             title: Text('View Profile'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => userProfile_new1(title: '',)));
    //             },
    //           ),
    //           ListTile(
    //             title: Text('Vaccine'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => VaccineScreen(title: '',)));
    //             },
    //           ), ListTile(
    //             title: Text('Vaccine Request'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => ViewVaccineRequest(title: '',)));
    //             },
    //           ),
    //           ListTile(
    //             title: Text('Pet Care'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => Hospital(title: '',)));
    //             },
    //           ),
    //
    //           ListTile(
    //             title: Text('Pet Shop'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => petshop(title: '',)));
    //             },
    //           ),  ListTile(
    //             title: Text('Pet Care Request'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPetRequest(title: '',)));
    //             },
    //           ),
    //           // ListTile(
    //           //   title: Text('Add Post'),
    //           //   onTap: () {
    //           //     // Handle profile view
    //           //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
    //           //   },
    //           // ),
    //           ListTile(
    //             title: Text('Post'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => UserPostView(title: '',)));
    //             },
    //           ),  ListTile(
    //             title: Text('Service Request'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => ViewServicesRequest(title: '',)));
    //             },
    //           ),
    //
    //
    //           ListTile(
    //             title: Text(' Pets'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) =>ViewUserPet (title: '',)));
    //             },
    //           ),
    // ListTile(
    //             title: Text('complaints'),
    //             onTap: () {
    //               // Handle profile view
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => ViewComplaints(title: '',)));
    //             },
    //           ),
    //
    //           ListTile(
    //             title: Text('Logout'),
    //             onTap: () {
    //               // Handle settings
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => PetShopLogin()));
    //             },
    //           ),
    //         ],
    //       ),
    //     ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  image: DecorationImage(
                    image: AssetImage('assets/bird.jpg'), // Add a background image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/fish.jpg'), // Add a logo or pet image
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Pet Shop ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: Icon(Icons.person, color: Colors.orange),
                title: Text('View Profile'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => userProfile_new1(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.vaccines, color: Colors.orange),
                title: Text('Vaccine'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VaccineScreen(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.medical_services, color: Colors.orange),
                title: Text('Vaccine Request'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewVaccineRequest(title: '')));
                },
              ), ListTile(
                leading: Icon(Icons.tips_and_updates, color: Colors.orange),
                title: Text('Tips'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewTips(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.pets, color: Colors.orange),
                title: Text('Pet Care'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Hospital(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.store, color: Colors.orange),
                title: Text('Pet Shop'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => petshop(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment, color: Colors.orange),
                title: Text('Pet Care Request'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPetRequest(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.post_add, color: Colors.orange),
                title: Text('Post'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserPostView(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.build, color: Colors.orange),
                title: Text('Service Request'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewServicesRequest(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.pets, color: Colors.orange),
                title: Text('Pets'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewUserPet(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.report_problem, color: Colors.orange),
                title: Text('Complaints'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewComplaints(title: '')));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.orange),
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PetShopLogin()));
                },
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              // Carousel Slider
              CarouselSlider(
                items: carouselImages.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
              SizedBox(height: 20),

              // Pet Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Pet Categories',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: petCategories.map((category) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(category['icon']!),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          category['title']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),

              // Available Pets
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Available Pets',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 40,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: id_.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            image_[index], // You can replace with pet image if available
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 0,),

                              Text(
                                petname_[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2,),

                              Text(
                                'Type: ${type_[index]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),





                              SizedBox(height: 5,),

                              Text(
                                'Price: ${price_[index]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),

                              SizedBox(height: 5,),

                              Text(
                                'Age: ${age_[index]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
