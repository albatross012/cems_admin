import 'package:cems_admin/newevent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Host extends StatefulWidget {
  const Host({Key? key}) : super(key: key);

  @override
  State<Host> createState() => _HostState();
}

class _HostState extends State<Host> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewEvent()),
              );
            },
            child: const Text(
              "Create new event",
              style: TextStyle(
                color: Color(0xff36CDC6),
                fontSize: 35,
              ),
            )),
      ),
    );
  }
}
