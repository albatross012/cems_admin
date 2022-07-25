// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background colour
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color(0xff36CDC6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                // SizedBox(
                // height: 20,
                // ),
                // ignore: sized_box_for_whitespace
                Container(
                  height: 200,
                  width: 200,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/eventmanagement-7d33f.appspot."
                          "com/o/icon_page-0001.png?alt=media&token=be2a6669-eda5-4c70-8105-4e332e4fd265"),
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //cems
                Text("CEMS",
                    style: GoogleFonts.iceberg(
                      color:
                          Color.fromARGB(255, 203, 108, 188).withOpacity(0.8),
                      fontSize: 68,
                      fontWeight: FontWeight.w200,
                    )),
                //email
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                //password
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                      ),
                    ),
                  ),
                ),
                //Login
                SizedBox(height: 30),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const AdminNavigation())));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(
                          child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 133, 128, 128),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Navigator.push(context, MaterialPageRoute(builder: ((context) => const AdminNavigation())));