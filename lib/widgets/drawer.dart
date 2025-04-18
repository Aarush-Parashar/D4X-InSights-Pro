import 'package:csv_predictor/screens/account_screen.dart';
import 'package:csv_predictor/screens/features_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv_predictor/models/file_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MenuDrawer extends StatefulWidget {
  final Function(FileUpload) onFileSelected;

  const MenuDrawer({
    super.key,
    required this.onFileSelected,
  });

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  List<FileUpload> previousUploads = [];
  List<FileUpload> filteredUploads = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPreviousUploads();
  }

  Future<void> loadPreviousUploads() async {
    final prefs = await SharedPreferences.getInstance();
    final uploadsJson = prefs.getStringList('previous_uploads') ?? [];

    setState(() {
      previousUploads = uploadsJson
          .map((json) => FileUpload.fromJson(jsonDecode(json)))
          .toList();
      filteredUploads = previousUploads;
    });
  }

  Future<void> savePreviousUploads() async {
    final prefs = await SharedPreferences.getInstance();
    final uploadsJson =
        previousUploads.map((upload) => jsonEncode(upload.toJson())).toList();
    await prefs.setStringList('previous_uploads', uploadsJson);
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = result.files.first;
      final newUpload = FileUpload(
        name: file.name,
        path: file.path ?? '',
        timestamp: DateTime.now(),
      );

      setState(() {
        previousUploads.insert(0, newUpload);
        filteredUploads = previousUploads;
      });

      await savePreviousUploads();
      widget.onFileSelected(newUpload);
      Navigator.pop(context);
    }
  }

  void filterUploads(String query) {
    setState(() {
      filteredUploads = previousUploads
          .where((upload) =>
              upload.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 57, left: 22, bottom: 20),
            child: Row(
              children: [
                const Text(
                  'CSV Predictor',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: filterUploads,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      hintText: 'Search',
                      suffixIcon: const Icon(Icons.search),
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: pickFile,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Upload new CSV',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(92, 172, 170, 170),
                        borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    child: Text(
                      'New',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUploads.length,
                      itemBuilder: (context, index) {
                        final upload = filteredUploads[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            child: ListTile(
                              title: Center(
                                child: Text(
                                  upload.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              onTap: () {
                                widget.onFileSelected(upload);
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FeaturesScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 351,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(92, 172, 170, 170),
              borderRadius: BorderRadius.circular(17),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AccountScreen(),
                  ),
                );
              },
              child: const Text(
                "Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
