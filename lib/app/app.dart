import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'router.dart';

class WakeQuestApp extends StatelessWidget {
  const WakeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WakeQuest',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
          primary: AppColors.primaryRed,
          surface: AppColors.surfaceLight,
        ),
      ),
    );
  }
}