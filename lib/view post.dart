

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petzo/sent%20comment.dart';
import 'package:petzo/view%20comment.dart';
import 'package:readmore/readmore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'add post.dart';

class UserViewCase extends StatelessWidget {
  const UserViewCase({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'View Reply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const UserPostView(title: 'View Reply'),
    );
  }
}

class UserPostView extends StatefulWidget {
  const UserPostView({super.key, required this.title});

  final String title;

  @override
  State<UserPostView> createState() => _UserPostViewState();
}

class _UserPostViewState extends State<UserPostView> {
  _UserPostViewState() {
    viewComplaints();
  }

  List<int> id_ = [];
  List<String> USER_ = [];
  List<String> file_ = [];
  List<String> date_ = [];
  List<String> details_ = [];
  List<String> name_ = [];

  void viewComplaints() async {
    List<int> id = <int>[];
    List<String> USER = <String>[];
    List<String> Details = <String>[];
    List<String> file = <String>[];
    List<String> date = <String>[];
    List<String> name = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/user_view_post';
      print(url);

      var data = await http.post(Uri.parse(url));
      var jsondata = json.decode(data.body);

      String status = jsondata['status'];
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id']);
        USER.add(arr[i]['USER']);
        Details.add(arr[i]['details'].toString());
        date.add(arr[i]['date'].toString());
        name.add(arr[i]['name'].toString());
        file.add(sh.getString('imgurl').toString() + arr[i]['file']);
      }

      setState(() {
        id_ = id;
        USER_ = USER;
        file_ = file;
        date_ = date;
        details_ = Details;
        name_ = name;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          leadingWidth: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 20.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashRadius: 1.0,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
              const Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 40.0,
                child: IconButton(
                  onPressed: () {},
                  splashRadius: 1.0,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.blueAccent,
                    size: 34.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        file_[index].endsWith('.mp4')
                            ? Container(
                          width: 300.0,
                          height: 200.0,
                          child: VideoPlayerWidget(videoUrl: file_[index]),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            file_[index],
                            width: double.infinity,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text("Name: ${name_[index]}",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),         const SizedBox(height: 12),
                        Text("User Name: ${USER_[index]}",
                            style: const TextStyle()),
                        const SizedBox(height: 12),

                        Text("Date: ${date_[index]}", style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 8),
                        ReadMoreText(
                          details_[index],
                          style: const TextStyle(fontSize: 12),
                          trimLines: 3,
                          colorClickableText: Colors.blue,
                          trimMode: TrimMode.Line,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (id_.isNotEmpty && index < id_.length) {
                                  SharedPreferences sh = await SharedPreferences.getInstance();
                                  sh.setString('pid', id_[index].toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const comment(title: 'Your Title'),
                                    ),
                                  );
                                } else {
                                  Fluttertoast.showToast(msg: "Invalid data.");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Icon(Icons.comment),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (id_.isNotEmpty && index < id_.length) {
                                  SharedPreferences sh = await SharedPreferences.getInstance();
                                  sh.setString('pid', id_[index].toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Viewcomment(title: 'Your Title'),
                                    ),
                                  );
                                } else {
                                  Fluttertoast.showToast(msg: "Invalid data.");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                              ),
                              child: const Text('View Comments'),
                            )
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


          floatingActionButton: FloatingActionButton(
          onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => AddPost(
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

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        if (_controller.value.hasError) {
          print("Video Player Error: ${_controller.value.errorDescription}");
        }
      });
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play(); // Auto-play the video on load
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}





