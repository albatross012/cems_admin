// ignore: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadImageAndGetUrl() async {
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
}

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String? imageUrl;
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
                child: Column(
                  children: [
                    textfield("Event Name", "name of event", _eventName, false),
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
                      child: GestureDetector(
                        onTap: () async {
                          await uploadImageAndGetUrl().then((value) {
                            log(value.toString());
                            setState(() {
                              if (value != null) imageUrl = value;
                            });
                          });
                        },
                        child: Container(
                          // ignore: sort_child_properties_last
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: imageUrl != null
                                  ? []
                                  : [
                                      Icon(
                                        Icons.tap_and_play,
                                        color: Color.fromARGB(255, 77, 57, 57),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Tap to add image",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 77, 57, 57),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                            ),
                          ),
                          height: 300,
                          decoration: BoxDecoration(
                            image: imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      imageUrl.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(18),
                            color: const Color.fromARGB(114, 160, 200, 120),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                        child: MaterialButton(
                          minWidth: 152,
                          height: 61,
                          onPressed: () {},
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
            )
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
