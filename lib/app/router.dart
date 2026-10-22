import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Login Screen (Tahap 3)')),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Register Screen (Tahap 3)')),
      ),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Dashboard Screen (Tahap 4)')),
      ),
    ),
  ],
);