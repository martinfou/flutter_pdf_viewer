import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'database_helper.dart'; // Add this import
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Viewer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.orange,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.blue),
          titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic, color: Colors.blue),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue,
            textStyle: const TextStyle(fontSize: 16.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, textStyle: const TextStyle(fontSize: 16.0),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const PDFViewerPage(),
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
  String? _selectedDocumentType;
  String? _selectedProject;
  String? _selectedVendor;
  DateTime? _selectedDate;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<String> _documentTypes = [];
  List<String> _projects = [];
  List<String> _vendors = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    final dbHelper = DatabaseHelper();
    final documentTypes = await dbHelper.getDocumentTypes();
    final projects = await dbHelper.getProjects();
    final vendors = await dbHelper.getVendors();
    if (!mounted) return;
    setState(() {
      _documentTypes = documentTypes;
      _projects = projects;
      _vendors = vendors;
    });
  }

  Future<void> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      if (!mounted) return;
      setState(() {
        _selectedFile = result.files.single.path;
      });
    }
  }

  Future<void> _renameFile() async {
    if (_selectedFile != null && _selectedDocumentType != null && _selectedProject != null && _selectedDate != null) {
      final file = File(_selectedFile!);
      final directory = file.parent;
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final newFileName = '${_selectedProject}_${_selectedDocumentType}_$formattedDate.pdf';
      final newPath = '${directory.path}/$newFileName';
      final newFile = await file.rename(newPath);
      if (!mounted) return;
      setState(() {
        _selectedFile = newFile.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File renamed to $newFileName')),
      );
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      if (!mounted) return;
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _showEditDialog({String? initialText, required Function(String) onSubmit}) async {
    final TextEditingController controller = TextEditingController(text: initialText);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(initialText == null ? 'Add Project' : 'Edit Project'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Project Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSubmit(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: <Widget>[
          const SizedBox(width: 16),
          _buildDocumentTypeDropdown(
            value: _selectedDocumentType,
            hint: 'Select Document Type',
            items: _documentTypes,
            onChanged: (String? newValue) {
              setState(() {
                _selectedDocumentType = newValue;
              });
            },
          ),
          const SizedBox(width: 16),
          _buildProjectDropdown(),
          const SizedBox(width: 16),
          _buildVendorDropdown(value: _selectedVendor, hint: 'Select Vendor', items: _vendors, onChanged: (String? newValue) {
            setState(() {
              _selectedVendor = newValue;
            });
          }),
          TextButton(
            onPressed: _pickDate,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
            child: const Text('Pick Date'),
          ),
          const SizedBox(width: 16),
          _buildDateTextField(),
          const SizedBox(width: 16),
          _buildDescriptionTextField(),
          const SizedBox(width: 16),
          TextButton(
            onPressed: _renameFile,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            child: const Text('Rename'),
          ),
          const SizedBox(width: 16),
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

    Widget _buildVendorDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      hint: Text(hint),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black), // Set text color for selected value
      dropdownColor: Colors.white, // Set background color for dropdown menu
    );
  }

  Widget _buildDocumentTypeDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      hint: Text(hint),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black), // Set text color for selected value
      dropdownColor: Colors.white, // Set background color for dropdown menu
    );
  }

  Widget _buildProjectDropdown() {
    return DropdownButton<String>(
      value: _selectedProject,
      hint: const Text('Select Project'),
      items: [
        ..._projects.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(
                      initialText: value,
                      onSubmit: (newName) async {
                        final dbHelper = DatabaseHelper();
                        await dbHelper.updateProject(value, newName);
                        _fetchDropdownData();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
        const DropdownMenuItem<String>(
          value: 'add_new',
          child: Text('Add New Project'),
        ),
      ],
      onChanged: (String? newValue) {
        if (newValue == 'add_new') {
          _showEditDialog(
            onSubmit: (newName) async {
              final dbHelper = DatabaseHelper();
              await dbHelper.insertProject(newName);
              _fetchDropdownData();
            },
          );
        } else {
          setState(() {
            _selectedProject = newValue;
          });
        }
      },
      style: const TextStyle(color: Colors.black), // Set text color for selected value
      dropdownColor: Colors.white, // Set background color for dropdown menu
    );
  }

  Widget _buildDateTextField() {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: 'Selected Date',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}