import 'package:flutter/material.dart';
import 'register_training_page.dart';
import 'attendance_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Thuận An chào mừng anh chị đến với hệ thống đào tạo TWI SGF',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.app_registration_rounded,
                      label: 'Đăng ký đào tạo',
                      color: Colors.blueAccent,
                      page: const RegisterTrainingPage(),
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.assignment_turned_in_rounded,
                      label: 'Điểm danh sau đào tạo',
                      color: Colors.green,
                      page: const AttendancePage(),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Phiên bản thử nghiệm Ver 1.1\nCopyright: Thuận An',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required Widget page}) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
