import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/alarms/data/alarm_model.dart';
import '../features/alarms/presentation/screens/add_alarm_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (session == null && !isLoggingIn) {
      return '/login';
    }

    if (session != null && isLoggingIn) {
      return '/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/add-alarm',
      builder: (context, state) {
        final alarmToEdit = state.extra as AlarmModel?;
        return AddAlarmScreen(alarmToEdit: alarmToEdit);
      },
    ),
  ],
);