import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/services/native_alarm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Memuat file .env dengan penanganan aman jika file aset tidak ditemukan
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // Apabila .env gagal dimuat, fallback menggunakan variabel lingkungan compiler
  }

  // Inisialisasi Native Alarm Manager Service (Bypass aman di Web)
  await NativeAlarmService.initialize();

  // Ambil URL dan Key dari dotenv atau dari --dart-define
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 
      const String.fromEnvironment('SUPABASE_URL');
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseKey,
  );

  runApp(
    const ProviderScope(
      child: WakeQuestApp(),
    ),
  );
}