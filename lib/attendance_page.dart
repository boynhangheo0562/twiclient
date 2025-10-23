import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twiclient/google_sheets_service.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController hlvController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? factory;
  String? line;
  String? assessment;

  File? imageFile;

  List<String> factories = [
    'Nhà máy 1',
    'Nhà máy 2',
    'Nhà máy 3',
    'Nhà máy 4',
    'Nhà máy RTE'
  ];

  Map<String, List<String>> lines = {
    'Nhà máy 1': ['Cá tẩm', 'Chà bông nướng'],
    'Nhà máy 2': ['Cháo soup', 'Cá tẩm'],
    'Nhà máy 3': ['Chà bông nướng'],
    'Nhà máy 4': ['Cháo soup'],
    'Nhà máy RTE': ['Cá tẩm']
  };

  List<String> assessments = [
    'Đạt yêu cầu',
    'Cần huấn luyện lại',
    'Xuất sắc'
  ];

  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDate: selectedDate,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitAttendance() async {
    if (!_formKey.currentState!.validate()) return;

    await GoogleSheetsService.insertAttendance({
      'Họ và tên HLV': hlvController.text,
      'Nhà máy': factory,
      'Line': line,
      'Ngày đào tạo': dateController.text,
      'Nội dung đào tạo': contentController.text,
      'Thời gian đào tạo': timeController.text,
      'Hình ảnh minh chứng': imageFile != null ? 'Có' : 'Không',
      'Đánh giá': assessment,
      'Ghi chú': noteController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gửi điểm danh thành công')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điểm danh sau đào tạo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: hlvController,
                decoration:
                    const InputDecoration(labelText: 'Họ và tên Huấn luyện viên'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nhập tên HLV' : null,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Nhà máy'),
                value: factory,
                items: factories
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) => setState(() => factory = val),
              ),
              if (factory != null)
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Line sản xuất'),
                  value: line,
                  items: lines[factory]!
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (val) => setState(() => line = val),
                ),
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                    labelText: 'Ngày đào tạo',
                    suffixIcon: Icon(Icons.calendar_today)),
                onTap: () => _pickDate(context),
              ),
              TextFormField(
                controller: contentController,
                decoration:
                    const InputDecoration(labelText: 'Nội dung đào tạo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nhập nội dung' : null,
              ),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Thời gian đào tạo'),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Hình ảnh minh chứng:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey.shade100,
                  ),
                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(imageFile!, fit: BoxFit.cover))
                      : const Icon(Icons.camera_alt,
                          color: Colors.grey, size: 60),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Đánh giá'),
                value: assessment,
                items: assessments
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (val) => setState(() => assessment = val),
              ),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _submitAttendance,
                  child: const Text('Gửi điểm danh')),
              const SizedBox(height: 10),
              const Text('Copyright: Thuận An',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
