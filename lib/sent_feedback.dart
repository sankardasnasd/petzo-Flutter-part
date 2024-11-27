import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:petzo/home.dart'; // Assuming PetShopHomePage is defined in home.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const Com());
}

class Com extends StatelessWidget {
  const Com({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sent Feedback',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const UserFeedback(title: 'Feedback'),
    );
  }
}

class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key, required this.title});

  final String title;

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  TextEditingController feedbackController = TextEditingController();
  double _rating = 0; // Variable to store the rating value
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  PetShopHomePage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Feedback',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'We value your feedback!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 4,
                    controller: feedbackController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Enter your feedback",
                      prefixIcon: const Icon(Icons.feedback),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your feedback.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Rate Us:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendFeedback();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Send Feedback',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendFeedback() async {
    String feedback = feedbackController.text.trim();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String hid = sh.getString('hid').toString();
    String lid = sh.getString('lid').toString();
    final urls = Uri.parse(url + "/send_hs_rating");

    try {
      final response = await http.post(urls, body: {
        'feedback': feedback,
        'rating': _rating.toString(),
        'hid': hid,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Feedback sent successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  PetShopHomePage()),
          );
        } else {
          Fluttertoast.showToast(msg: 'Failed to send feedback.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }
}
