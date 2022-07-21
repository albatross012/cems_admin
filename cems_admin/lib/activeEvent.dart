// ignore: file_names
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;
import 'package:cems_admin/main.dart';
import 'package:cems_admin/newevent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<Event?> deleteEvent(String id, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse('$releaseUrl/events/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );
    log(response.statusCode.toString());
    if (response.statusCode != 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Alert"),
          content: Text(jsonDecode(response.body)["message"]),
        ),
      );
      return null;
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Deleted"),
          content: Text("Event deleted Successfully"),
        ),
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error!"),
        content: Text(e.toString()),
      ),
    );
    return null;
  }
  return null;
}

class ActiveEvent extends StatefulWidget {
  const ActiveEvent({Key? key}) : super(key: key);

  @override
  State<ActiveEvent> createState() => _ActiveEventState();
}

class _ActiveEventState extends State<ActiveEvent> {
  List<Event> events = [];
  bool isLoading = true;
  bool isBusy = false;
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
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewEvent()),
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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: () {},
      //   child: const Icon(
      //     Icons.add,
      //     color: Color(0xff36CDC6),
      //     size: 50,
      //   ),
      // ),
      body: isLoading || isBusy
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
                        padding: const EdgeInsets.only(bottom: 200),
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(1, -1),
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
                                height: 500,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 110, vertical: 10),
                                child: Center(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      setState(() {
                                        isBusy = false;
                                      });
                                      await deleteEvent(
                                          events[index].id, context);
                                      if (mounted) {
                                        setState(() {
                                          isBusy = false;
                                        });
                                      }
                                    },
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
