import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  static const String scriptUrl =
      'https://script.google.com/macros/s/AKfycbyBkcXOoMK2-7aj-PVahvr6N0gAQglcd037XLrHaP7hN0v5GZOXYzy7C_QZpsnyWZ1N/exec';

  static Future<void> insertRegistration(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$scriptUrl?action=addRegistration'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Lỗi khi gửi đăng ký: ${response.body}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối Google Sheet: $e');
    }
  }

  static Future<void> insertAttendance(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$scriptUrl?action=addAttendance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Lỗi khi gửi điểm danh: ${response.body}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối Google Sheet: $e');
    }
  }
}
