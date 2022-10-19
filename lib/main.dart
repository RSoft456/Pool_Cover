import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  fileData(int Height, int Width) async {
    var file = await rootBundle.load("assets/document.xlsx");
    var excel = Excel.decodeBytes(
        file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes));
    var worksheetsNames = excel.tables.keys;
    // var sheet = excel.tables["Calculator"];
    // var width = sheet!.cell(CellIndex.indexByString("C4"));
    // var height = sheet.cell(CellIndex.indexByString("C8"));
    // width.value = Width;
    // height.value = height;
    for (var sheetName in worksheetsNames) {
      if (sheetName == 'Calculator') {
        var sheet = excel.tables[sheetName];
        var sheetRows = sheet!.rows;
        var rowsLength = sheetRows.length;
        try {
          for (var idx = 0; idx < rowsLength; idx++) {
            var row = sheetRows[idx];
            // print(" ${row.map((e) => '${e?.value}').join(' | ')}");
            log("${row[0]?.value} | ${row[1]?.value} | ${row[2]?.value} | ${row[3]?.value} | ${row[4]?.value} | ${row[5]?.value} | ${row[6]?.value} | ${row[7]?.value} | ${row[8]?.value} ");
          }
        } catch (e) {
          log("$e");
        }
        break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileData(5000, 4000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pool_Cover'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: "Height"),
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: "Width"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
