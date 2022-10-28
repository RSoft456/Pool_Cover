import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});
  final snackbar = const SnackBar(content: Text('No internet connection'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/network.gif",
          ),
          const Text('No internet connection'),
          ElevatedButton(
              onPressed: () async {
                if (await InternetConnectionCheckerPlus().hasConnection) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
              child: const Text('try again'))
        ],
      ),
    );
  }
}
