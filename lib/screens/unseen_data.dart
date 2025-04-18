import 'package:csv_predictor/models/file_upload.dart';
import 'package:flutter/material.dart';
import 'package:csv_predictor/widgets/drawer.dart';
import 'package:flutter/services.dart';

class UnseenDataScreen extends StatefulWidget {
  final List<Map<String, dynamic>> formFields; // Dynamic form fields

  const UnseenDataScreen({
    super.key,
    required this.formFields, // Required parameter
  });

  @override
  State<UnseenDataScreen> createState() => _UnseenDataScreenState();
}

class _UnseenDataScreenState extends State<UnseenDataScreen> {
  final Map<String, dynamic> formValues = {}; // Store form values

  void _handleFileSelected(FileUpload file) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.white,
        ),
      ),
      drawer: MenuDrawer(onFileSelected: _handleFileSelected),
      body: Form(
        child: Column(
          children: [
            const Text(
              'Give unseen data to Predict',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Dynamically generate form fields
                        ...widget.formFields
                            .map((field) => _buildFormField(field))
                            .toList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Predict',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Predicted Value",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    height: 60,
                    width: 350,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(46, 158, 158, 158),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(
                      "Predicted Values",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 43,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(96, 172, 154, 154),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                        SizedBox(width: 100),
                        Text("Accuracy:"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(Map<String, dynamic> field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          field['inputtype'] == 'Number'
              ? _buildNumberField(field)
              : _buildDropdownField(field),
        ],
      ),
    );
  }

  Widget _buildNumberField(Map<String, dynamic> field) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: field['placeholder'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        formValues[field['name']] = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(Map<String, dynamic> field) {
    // Ensure 'values' is a valid list, or provide an empty list as fallback
    final List<dynamic> values = field['values'] ?? [];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: field['placeholder'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: values.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (value) {
        formValues[field['name']] = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a value';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    // TODO: Implement form submission logic
    print('Form Values: $formValues');
    // TODO:add navigation or prediction logic here
  }
}
