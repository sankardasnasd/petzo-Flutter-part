
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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
      home: const Viewcomment(title: 'View Reply'),
    );
  }
}

class Viewcomment extends StatefulWidget {
  const Viewcomment({super.key, required this.title});

  final String title;

  @override
  State<Viewcomment> createState() => _ViewcommentState();
}

class _ViewcommentState extends State<Viewcomment> {
  List<int> id_ = [];
  List<String> comment_ = [];
  List<String> date_ = [];
  List<String> USER_ = [];

  void Viewcomment() async {
    List<int> id = <int>[];
    List<String> date = <String>[];
    List<String> comment = <String>[];
    List<String> USER = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_comment';
      String lid = sh.getString("lid").toString();
      String pid = sh.getString("pid").toString();
      var data = await http.post(Uri.parse(url), body: {
        "lid": lid,
        "pid": pid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        date.add(arr[i]['date'].toString());
        comment.add(arr[i]['comment']);
        USER.add(arr[i]['USER']);
      }

      setState(() {
        id_ = id;
        date_ = date;
        comment_ = comment;
        USER_ = USER;
      });

    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    Viewcomment();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { return true; },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('View Comments'),
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
                          "Date: " + date_[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),

                        Text(
                          "User: " + USER_[index],

                        ),
                        SizedBox(height: 8),
                        Text(
                          "Comments: " + comment_[index],
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
    );
  }
}
