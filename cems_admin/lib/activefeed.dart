import 'dart:convert';
import 'dart:developer';

import 'package:cems_admin/main.dart';
import 'package:cems_admin/newfeed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ActiveFeed extends StatefulWidget {
  const ActiveFeed({Key? key}) : super(key: key);

  @override
  State<ActiveFeed> createState() => _ActiveFeedState();
}

class _ActiveFeedState extends State<ActiveFeed> {
  List<Feeds> feeds = [];
  bool isLoading = true;
  final storage = const FlutterSecureStorage();
  Future<bool> getEvents() async {
    try {
      var url = Uri.parse('$releaseUrl/feeds/getfeeds');
      var response = await http.get(
        url,
      );
      log('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          feeds = jsonDecode(response.body)["events"]
              .map<Feeds>((e) => Feeds.fromJson(e))
              .toList();
          feeds = feeds.reversed.toList();
        });
        return true;
      } else {
        log("Somthing went wrong");
        return false;
      }
    } catch (e) {
      log("Error occured in events -->$e");
      return false;
    }
  }

  @override
  void initState() {
    getEvents().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewFeed()),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Color(0xff36CDC6),
              size: 75,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                color: Color(0xff36CDC6),
                radius: 40,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Material(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 200),
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(1, -1),
                                color: Colors.black.withAlpha(40),
                              )
                            ],
                            borderRadius: BorderRadiusDirectional.circular(
                              28,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImageSlideshow(
                                width: double.infinity,
                                height: 300,
                                initialPage: 0,
                                indicatorColor: Colors.blue,
                                indicatorBackgroundColor: Colors.grey,
                                children: feeds[index]
                                    .imageUrl
                                    .map((e) => Container(
                                          height: 300,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(e),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 110, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      minWidth: 100,
                                      height: 50,
                                      color: const Color(0xff36CDC6),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(19),
                                      ),
                                      child: const Text(
                                        "DELETE",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {},
                                      minWidth: 100,
                                      height: 50,
                                      color: const Color(0xff36CDC6),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(19),
                                      ),
                                      child: const Text(
                                        "EDIT",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        itemCount: feeds.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
