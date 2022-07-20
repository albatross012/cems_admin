import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cems_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register {
  final String username;
  final String id;

  const Register({
    required this.username,
    required this.id,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Register(username: json['username'], id: json['id']);
  }
}

class Participants extends StatefulWidget {
  final String id;
  const Participants({Key? key, required this.id}) : super(key: key);

  @override
  State<Participants> createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  List<dynamic> register = [];
  bool isLoading = true;
  final storage = const FlutterSecureStorage();
  Future<bool> getRegister(String id, BuildContext context) async {
    try {
      log(id.toString());
      var url = Uri.parse('$releaseUrl/register/getid');
      var response = await http.post(
        url,
        body: {
          'id': id,
        },
      );
      log('Response status: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          register = jsonDecode(response.body)["users"];
          register = register.reversed.toList();
          log(register.toString());
        });
        return true;
      } else {
        log("Somthing went wrong");
        return false;
      }
    } catch (e) {
      log("Error occured -->$e");
      return false;
    }
  }

  @override
  void initState() {
    getRegister(widget.id, context).then((value) {
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
        title: const Text('CEMS ADMIN'),
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
                        padding: const EdgeInsets.only(bottom: 200),
                        itemBuilder: (context, index) => Container(
                          height: 200,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xff36CDC6),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Name: ${register[index]["firstName"]} ${register[index]["lastName"]}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Email: ${register[index]["email"]}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Dept: ${register[index]["deptName"]}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "College: ${register[index]["collegeName"]}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        itemCount: register.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
