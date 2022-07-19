import 'package:cems_admin/activefeed.dart';
import 'package:cems_admin/newfeed.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewFeed()),
                  );
                },
                child: const Text(
                  "Add new feed",
                  style: TextStyle(
                    color: Color(0xff36CDC6),
                    fontSize: 35,
                  ),
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ActiveFeed()),
                  );
                },
                child: const Text(
                  "Active Feed",
                  style: TextStyle(
                    color: Color(0xff36CDC6),
                    fontSize: 35,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
