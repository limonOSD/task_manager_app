import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/canceled_task_screen.dart';
import 'package:task_manager_app/ui/screens/completed_task_screen.dart';
import 'package:task_manager_app/ui/screens/new_task_screen.dart';
import 'package:task_manager_app/ui/screens/progress_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    NewTasksScreen(),
    ProgressTasksScreen(),
    CompletedTasksScreen(),
    CancelledTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined), label: 'New'),
          BottomNavigationBarItem(
              icon: Icon(Icons.change_circle_outlined), label: 'In Progress'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outlined), label: 'Completed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_outlined), label: 'Cancelled'),
        ],
      ),
    );
  }
}
