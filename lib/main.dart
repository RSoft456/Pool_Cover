import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pool_cover/screens/gallery.dart';
import 'package:pool_cover/screens/noInternet.dart';
import 'package:pool_cover/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _width = TextEditingController();
  final TextEditingController _height = TextEditingController();
  int index = 0;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), (() {
      index = 1;
      setState(() {});
    }));
    super.initState();
  }

  toast(BuildContext context, String message) {
    final toast = ScaffoldMessenger.of(context);
    toast.showSnackBar(SnackBar(content: Text(message)));
  }

  checkConnection() async {
    return await InternetConnectionCheckerPlus().hasConnection;
  }

  SetData(int height, int width) async {
    log('hi3');
    if (await checkConnection()) {
      http.Response Data = await http.post(
        Uri.parse(
          "https://script.google.com/macros/s/AKfycbzBlxBbIVCswBOViEmGlphA4yFyK6z3Np7NGlaU8vfbP7aiYvyRWoQyZHkOUaM1WqdMxw/exec",
        ),
        body: {
          "height": height.toString(),
          "width": width.toString(),
        },
      );
      log(Data.body);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  GetData() async {
    if (await checkConnection()) {
      http.Response data = await http.get(
        Uri.parse(
            "https://script.google.com/macros/s/AKfycbzBlxBbIVCswBOViEmGlphA4yFyK6z3Np7NGlaU8vfbP7aiYvyRWoQyZHkOUaM1WqdMxw/exec"),
      );
      var response = jsonDecode(data.body);

      log("$response");
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Stuba',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Gallery()));
              },
              icon: const Icon(Icons.image)),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: [
          const splash(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _height,
                      decoration: const InputDecoration(hintText: "Height"),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _width,
                      decoration: const InputDecoration(hintText: "Width"),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_width.text.isEmpty || _height.text.isEmpty) {
                    toast(context, "Height and Width cannot be empty");
                  } else if (int.parse(_width.text.toString()) < 3000) {
                    toast(context, "Width cannot be less than 3000mm");
                  } else if (int.parse(_width.text.toString()) > 12000) {
                    toast(context, "Width cannot be greater than 12000mm");
                  } else if (int.parse(_height.text.toString()) < 8000) {
                    toast(context, "Height cannot be less than 8000mm");
                  } else if (int.parse(_height.text.toString()) > 28000) {
                    toast(context, "Height cannot be greater than 28000mm");
                  } else {
                    SetData(int.parse(_height.text.toString()),
                        int.parse(_width.text.toString()));
                  }
                },
                child: const Text('submit'),
              )
            ],
          )
        ],
      ),
    );
  }
}
