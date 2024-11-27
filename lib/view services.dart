
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:petzo/sent%20service%20request.dart';
import 'package:petzo/sent_complaint.dart';
import 'package:readmore/readmore.dart';
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
      home: const ViewServices(title: 'View Reply'),
    );
  }
}

class ViewServices extends StatefulWidget {
  const ViewServices({super.key, required this.title});

  final String title;

  @override
  State<ViewServices> createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> {
  List<int> id_ = [];
  List<String> servicename_ = [];
  List<String> details_ = [];


void ViewServices() async {
    List<int> id = <int>[];
    List<String> servicename = <String>[];
    List<String> details = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_services';
      // String lid = sh.getString("lid").toString();
      String pid = sh.getString("pid").toString();
      var data = await http.post(Uri.parse(url), body: {
        // "lid": lid,
        "pid": pid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        servicename.add(arr[i]['servicename'].toString());
        details.add(arr[i]['details']);
      }

      setState(() {
        id_ = id;
        servicename_ = servicename;
        details_ = details;
      });

    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    ViewServices();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { return true; },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('View Services'),
        ),
        body: ListView.builder(
          itemCount: id_.length,
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
                          "Service: " + servicename_[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Details: " + details_[index],
                          style: TextStyle(fontSize: 14),
                        ),

                        SizedBox(height: 18),

                        ElevatedButton(
                          onPressed: () async {
                            SharedPreferences sh =
                            await SharedPreferences.getInstance();
                            sh.setString(
                                'sid', id_[index].toString());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SentServicesRequest(title: '',),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text('Request',
                              style: TextStyle(color: Colors.white)),
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
    );
  }
}
