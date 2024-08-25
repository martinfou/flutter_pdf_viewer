import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Viewer Demo',
      home: PDFViewerPage(),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  const PDFViewerPage({super.key});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? _selectedFile;
  String? _selectedOption; // State variable for dropdown selection
  String? _selectedProject; // State variable for the selected project name
  final List<String> _options = [
    'document',
    'facture',
    'identification'
  ]; // Dropdown options
  final List<String> _projects = [
    'DesEcluses',
    'Compica',
    'Saint-Laurent',
    'Edouard'
  ]; // Project names
  DateTime? _selectedDate; // State variable for the selected date
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.path;
      });
    }
  }

  Future<void> _renameFile() async {
    if (_selectedFile != null &&
        _selectedOption != null &&
        _selectedProject != null &&
        _selectedDate != null) {
      final file = File(_selectedFile!);
      final directory = file.parent;
       // Format the date to include only the date portion
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      final newFileName =
          '${_selectedProject}_${_selectedOption}_$formattedDate.pdf'; // Updated file name format // Updated file name format
      final newPath = '${directory.path}/$newFileName';
      final newFile = await file.rename(newPath);
      setState(() {
        _selectedFile = newFile.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File renamed to $newFileName')),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: <Widget>[
          DropdownButton<String>(
            value: _selectedProject,
            hint: const Text('Select Project'),
            items: _projects.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedProject = newValue;
              });
            },
          ),
          DropdownButton<String>(
            value: _selectedOption,
            hint: const Text('Select Type'),
            items: _options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue;
              });
            },
          ),
          TextButton(
            onPressed: () => _pickDate(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue, // Choose an appropriate color
            ),
            child: const Text('Pick Date'),
          ),
          TextButton(
            onPressed: () => _pickDate(context),
            child: Text(_selectedDate == null
                ? 'Select Date'
                : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
          ),
                   
          TextButton(
            onPressed: _renameFile,
            style: TextButton.styleFrom(
              backgroundColor: Colors.black, // Dark background color
            ),
            child: const Text('Rename'),
          ),
        ],
      ),
      body: _selectedFile == null
          ? const Center(child: Text('No PDF selected'))
          : SfPdfViewer.file(File(_selectedFile!)),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickPdfFile,
        tooltip: 'Pick PDF',
        child: const Icon(Icons.add),
      ),
    );
  }
}
