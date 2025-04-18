import 'package:csv_predictor/models/file_upload.dart';
import 'package:csv_predictor/widgets/drawer.dart';
import 'package:flutter/material.dart';

class ForcastScreen extends StatelessWidget {
  const ForcastScreen({super.key});
  void handleFileSelected(FileUpload file) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MenuDrawer(onFileSelected: handleFileSelected),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "Forcasted Value",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration:
                const BoxDecoration(color: Color.fromARGB(96, 172, 154, 154)),
            child: Row(
              children: [
                const SizedBox(width: 30),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  tooltip: "Go Back",
                ),
                const SizedBox(width: 80),
                Text(
                  "Accuracy :",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
