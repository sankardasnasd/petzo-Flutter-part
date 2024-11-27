import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserOutfit extends StatefulWidget {
  const UserOutfit({Key? key}) : super(key: key);

  @override
  State<UserOutfit> createState() => _UserOutfitState();
}

class _UserOutfitState extends State<UserOutfit> {
  _UserOutfitState() {
    view_outfits();
  }

  List<Map<String, String>> outfits = [];

  Future<void> view_outfits() async {
    List<Map<String, String>> fetchedOutfits = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';
      String url = urls + 'user_view_outfit';

      var data = await http.post(Uri.parse(url), body: {"lid": lid});

      if (data.statusCode == 200) {
        var jsondata = json.decode(data.body);
        String statuss = jsondata['status'];

        var arr = jsondata["data"];
        print(arr.length);

        for (int i = 0; i < arr.length; i++) {
          fetchedOutfits.add({
            'oid': arr[i]['oid'] ?? '',
            'image': arr[i]['image'] ?? '',
            'type': arr[i]['type'] ?? 'Unknown Type',
            'rate': arr[i]['rate'] ?? '0',
            'designer': arr[i]['designer'] ?? '0',
            'size': arr[i]['size'] ?? 'Unknown Size',
            'status': arr[i]['status'] ?? 'Unknown status',
          });
        }

        setState(() {
          outfits = fetchedOutfits;
        });

        print(statuss);
      } else {
        print('Error: ${data.statusCode} - ${data.body}');
      }
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: outfits.length,
          itemBuilder: (context, index) {
            return _buildOutfitCard(index, outfits[index]);
          },
        ),
      ),
    );
  }

  Widget _buildOutfitCard(int index, Map<String, String> outfit) {
    String image = outfit['image']!;
    String type = outfit['type']!;
    String rate = outfit['rate']!;
    String size = outfit['size']!;
    String designer = outfit['designer']!;
    String status = outfit['status']!;
    String oid = outfit['oid']!;

    return GestureDetector(
      onTap: () => _showOutfitDetailsDialog(context, outfit),
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  image.isNotEmpty ? image : 'default_image_url_here',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Text('Failed to load image');
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$rate ($status)',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: $size',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Designer: $designer',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the dialog with full-screen details
  void _showOutfitDetailsDialog(BuildContext context, Map<String, String> outfit) {
    String image = outfit['image']!;
    String type = outfit['type']!;
    String rate = outfit['rate']!;
    String designer = outfit['designer']!;
    String size = outfit['size']!;
    String status = outfit['status']!;
    String oid = outfit['oid']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 700, // Set the height to 700
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          image.isNotEmpty ? image : 'default_image_url_here',
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          type,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$rate | $status',
                          style: const TextStyle(fontSize: 18, color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Size: $size',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          'Designer: $designer',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        // Inside ElevatedButton's onPressed:
                        ElevatedButton(
                          onPressed: () async {
                            // Controllers for date and quantity inputs
                            TextEditingController dateController = TextEditingController();
                            TextEditingController quantityController = TextEditingController();

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Booking"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Do you want to book the service '${outfit['type']}'?"),
                                      const SizedBox(height: 16),

                                      // Date Input Field
                                      TextFormField(
                                        controller: dateController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.calendar_today),
                                          labelText: "Select Booking Date",
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100),
                                          );
                                          if (pickedDate != null) {
                                            dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format date
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Quantity Input Field
                                      TextFormField(
                                        controller: quantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.confirmation_number),
                                          labelText: "Enter Quantity",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Validation for date and quantity inputs
                                        if (dateController.text.isEmpty || quantityController.text.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please fill all fields before booking.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                          return;
                                        }

                                        try {
                                          SharedPreferences sh = await SharedPreferences.getInstance();
                                          String urls = sh.getString('url') ?? '';
                                          String bookServiceUrl = urls + 'user_book_outfit';

                                          // API request to book the service
                                          var response = await http.post(
                                            Uri.parse(bookServiceUrl),
                                            body: {
                                              'sid': outfit['oid'],
                                              'amount': outfit['rate'],
                                              'lid': sh.getString('lid'),
                                              'date': dateController.text, // Selected booking date
                                              'quantity': quantityController.text, // Entered quantity
                                            },
                                          );
                                          var jsonData = json.decode(response.body);

                                          if (jsonData['status'] == 'ok') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => UserOutfit()),
                                            );
                                            Fluttertoast.showToast(
                                              msg: "Service '${outfit['type']}' booked successfully!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                            );

                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Failed to book the service. Please try again.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                            );
                                          }
                                        } catch (e) {
                                          print("Error: $e");
                                          Fluttertoast.showToast(
                                            msg: "An error occurred. Please try again later.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        }

                                        // Close the dialog after booking
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Book Now"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("Book Now"),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
