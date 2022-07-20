// ignore: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cems_admin/home.dart';
import 'package:cems_admin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadImageAndGetUrl() async {
  try {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File file = File(image.path);
      final ref = FirebaseStorage.instance
          .ref('/profile_images/${DateTime.now().millisecondsSinceEpoch}');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );
      log("her");
      final url = await ref.putFile(File(file.path), metadata).then((p0) async {
        log("herer");
        return (await p0.ref.getDownloadURL());
      });
      log(url);
      return url;
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<Event?> createEvent(List<String> imageUrl, String eventName,
    String description, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse('$releaseUrl/events/addevent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'imageUrl': [...imageUrl],
        'eventName': eventName,
        'description': description
      }),
    );
    log(response.statusCode.toString());
    if (response.statusCode != 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Backend Error!"),
          content: Text(jsonDecode(response.body)["message"]),
        ),
      );
      return null;
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminNavigation(),
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
}

class Event {
  final String description;
  final String eventName;
  final List<String> imageUrl;
  final String id;

  const Event(
      {required this.eventName,
      required this.description,
      required this.imageUrl,
      required this.id});

  factory Event.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Event(
        eventName: json['eventName'],
        description: json['description'],
        imageUrl: json['imageUrl'].map<String>((e) => e.toString()).toList(),
        id: json['_id']);
  }
}

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  List<String> imageUrl = [];
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff36CDC6),
        title: const Text('NEW EVENT '),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textfield(
                          "Event Name", "name of event", _eventName, false),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: _description,
                          minLines:
                              6, // any number you need (It works as the rows for the textarea)
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            labelText: "Description",
                            labelStyle: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                            hintText: "Description of event",
                            hintStyle: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                            fillColor: Colors.white30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 25,
                        ),
                        child: SizedBox(
                            height: 200,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...[
                                    GestureDetector(
                                      onTap: isUploading
                                          ? null
                                          : () async {
                                              setState(() {
                                                isUploading = true;
                                              });
                                              await uploadImageAndGetUrl()
                                                  .then((value) {
                                                log(value.toString());
                                                setState(() {
                                                  if (imageUrl != null) {
                                                    imageUrl.add(value!);
                                                  }
                                                });
                                              });
                                              setState(() {
                                                isUploading = false;
                                              });
                                            },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xff36CDC6)
                                                .withOpacity(0.6),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(width: 1),
                                          ),
                                          height: 200,
                                          width: 200,
                                          child: isUploading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.tap_and_play),
                                                    Text("Tap to add image")
                                                  ],
                                                )),
                                    )
                                  ],
                                  ...imageUrl.map((e) => Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(width: 1),
                                              image: DecorationImage(
                                                image: NetworkImage(e),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                          child: MaterialButton(
                            minWidth: 152,
                            height: 61,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                await createEvent(imageUrl, _eventName.text,
                                        _description.text, context)
                                    .then((value) {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const CupertinoAlertDialog(
                                          content: Text("Invalid Values."),
                                        ));
                              }
                            },
                            color: Color(0xff36CDC6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: const Text(
                              "CREATE",
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
              ),
            ),
            if (isLoading)
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height - 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Center(
                    child: SpinKitCircle(
                      size: 80,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(0.9),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index.isEven
                                  ? const Color(0xff36CDC6)
                                  : const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget textfield(
    String label, String hint, TextEditingController _controller, bool value) {
  return Padding(
    padding: const EdgeInsets.only(top: 25.0),
    child: TextField(
      controller: _controller,
      obscureText: value,
      decoration: InputDecoration(
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        labelText: label,
        labelStyle: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        fillColor: Colors.white30,
      ),
    ),
  );
}
