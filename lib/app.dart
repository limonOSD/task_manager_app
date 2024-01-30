import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/screens/splash_screen.dart';

import 'ui/screens/controllers/auth_controller.dart';
import 'ui/screens/controllers/forget_password_controller.dart';
import 'ui/screens/controllers/login_controller.dart';
import 'ui/screens/controllers/new_task_controller.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigationKey,
      home: const SplashScreen(),
      theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          primaryColor: Colors.green,
          primarySwatch: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
          ))),
      initialBinding: ControllerBinder(),
    );
  }
}

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(LoginController());
    Get.put(NewTaskController());
    Get.put(ForgetPasswordController());
  }
}
