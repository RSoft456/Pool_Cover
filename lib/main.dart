import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as SF;

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
    //var file = "D:/FlutterProjects/pool_cover/assets/document.xlsx";
    //File doc = File(file);
    //var bytes = doc.readAsBytesSync();
    //log("{ ${file.lengthInBytes} } { ${file.offsetInBytes} } ");
    var excel = Excel.decodeBytes(
        file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes));
    Sheet sheet = excel['Pricelist'];

    final SF.Workbook workbook = SF.Workbook();
    final SF.Worksheet sheetObj = workbook.worksheets[0];

    //sheet2.enableSheetCalculations();
    // sheet2.getRangeByName('C4').setNumber(Height.toDouble());
    // sheet2.getRangeByName('C8').setNumber(Width.toDouble());

    // String? calculatedValue = sheet2.getRangeByName('IH13').calculatedValue;
    // log("$calculatedValue");

    // var width = sheet.cell(CellIndex.indexByString("C4"));
    // var height = sheet.cell(CellIndex.indexByString("C8"));
    // width.value = Width;
    // height.value = height;
    // var result = sheet.cell(CellIndex.indexByString("F13"));
    // Formula price = result.value;
    // if (price.toString().isEmpty) {
    //   log("yes");
    // }
    // log(price.toString());

    // log("value ${price.formula}");
    int count = 0;
    for (var table in excel.tables["Calculator"]!.rows) {
      sheetObj.importList(table, count, 1, true);
      count++;
      if (count == 13) {
        Data fjk = table[1] as Data;
        log("${fjk.cellIndex}    ${fjk.colIndex}    ${fjk.rowIndex}    ${fjk.value}");
      }
    }
    var data = sheetObj.getRangeByName('H13:I13').calculatedValue;

    log("$data");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileData(8000, 9000);
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
