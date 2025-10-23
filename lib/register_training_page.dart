import 'package:flutter/material.dart';
import '../google_sheets_service.dart';

class RegisterTrainingPage extends StatefulWidget {
  const RegisterTrainingPage({super.key});

  @override
  State<RegisterTrainingPage> createState() => _RegisterTrainingPageState();
}

class _RegisterTrainingPageState extends State<RegisterTrainingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController hlvController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? factory;
  String? line;
  String? process;
  String? purpose;

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

  List<String> processes = [
    'Cắt/Fillet/Lạng xương',
    'Nướng/hấp/thanh trùng',
    'Hút chân không',
    'Vô bao'
  ];

  List<String> purposes = [
    'Nâng cao tay nghề',
    'Chuẩn thao tác',
    'Công nhân mới'
  ];

  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final nextMonth =
        DateTime(now.year, now.month + 1, DateTime(now.year, now.month + 2, 0).day);

    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: nextMonth,
      initialDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    await GoogleSheetsService.insertRegistration({
      'Họ và tên HLV': hlvController.text,
      'Nhà máy': factory,
      'Line': line,
      'Ngày tháng đào tạo': dateController.text,
      'Nội dung đào tạo': contentController.text,
      'Công đoạn': process,
      'Mục đích': purpose,
      'Ghi chú': noteController.text,
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Gửi dữ liệu thành công')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký đào tạo')),
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
                decoration: const InputDecoration(
                    labelText: 'Ngày tháng đào tạo', suffixIcon: Icon(Icons.date_range)),
                readOnly: true,
                onTap: () => _pickDate(context),
              ),
              TextFormField(
                controller: contentController,
                decoration:
                    const InputDecoration(labelText: 'Nội dung đào tạo'),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Công đoạn'),
                value: process,
                items: processes
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => process = val),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Mục đích đào tạo'),
                value: purpose,
                items: purposes
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => purpose = val),
              ),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _submitForm, child: const Text('Gửi dữ liệu')),
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
