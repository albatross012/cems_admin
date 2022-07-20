import 'dart:convert';
import 'dart:developer';

import 'package:cems_admin/main.dart';
import 'package:cems_admin/newevent.dart';
import 'package:cems_admin/participants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterDetail extends StatefulWidget {
  const RegisterDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterDetail> createState() => _RegisterDetailState();
}

class _RegisterDetailState extends State<RegisterDetail> {
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 110, vertical: 10),
                                child: Center(
                                  child: MaterialButton(
                                    onPressed: () {
                                      log(events[index].id);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Participants(
                                                  id: events[index].id,
                                                )),
                                      );
                                    },
                                    minWidth: 100,
                                    height: 50,
                                    color: const Color(0xff36CDC6),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(19),
                                    ),
                                    child: const Text(
                                      "LIST",
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
