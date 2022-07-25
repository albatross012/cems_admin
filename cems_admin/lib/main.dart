import 'package:cems_admin/home.dart';
import 'package:cems_admin/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

const releaseUrl = "https://collage-event-management.herokuapp.com";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }
  //  @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 2)).then((value) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => const AdminNavigation()));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'CEMS',
                  style: GoogleFonts.iceberg(
                    color: const Color.fromARGB(255, 203, 108, 188)
                        .withOpacity(0.8),
                    fontSize: 68,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              SpinKitCircle(
                size: 60,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: index.isEven
                            ? const Color.fromARGB(255, 203, 108, 188)
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                child: RichText(
                  text: TextSpan(
                    text: "Created by ",
                    style: GoogleFonts.poppins(
                      color: Colors.grey.withOpacity(1),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'Team CEMS.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
