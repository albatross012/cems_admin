// ignore: file_names
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;
import 'package:cems_admin/main.dart';
import 'package:cems_admin/newevent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ActiveEvent extends StatefulWidget {
  const ActiveEvent({Key? key}) : super(key: key);

  @override
  State<ActiveEvent> createState() => _ActiveEventState();
}

class _ActiveEventState extends State<ActiveEvent> {
  List<Event> events = [];
  bool isLoading = true;
  final storage = const FlutterSecureStorage();
  Future<bool> getEvents() async {
    try {
      var url = Uri.parse('$releaseUrl/events/getevents');
      var response = await http.get(
        url,
      );
      log('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          events = jsonDecode(response.body)["events"]
              .map<Event>((e) => Event.fromJson(e))
              .toList();
          events = events.reversed.toList();
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
      appBar: AppBar(
        backgroundColor: const Color(0xff36CDC6),
      ),
      body: isLoading
          ? Center(
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
                                children: events[index]
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  events[index].eventName.toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  events[index].description.toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        itemCount: events.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
