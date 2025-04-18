import 'package:csv_predictor/models/file_upload.dart';
import 'package:csv_predictor/widgets/drawer.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void handleFileSelected(FileUpload file) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MenuDrawer(onFileSelected: handleFileSelected),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            const Text(
              "Loading",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
