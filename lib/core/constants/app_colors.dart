import 'package:flutter/material.dart';

class AppColors {
  // Palette Utama Monokromatik (shadcn/ui zinc style)
  static const Color primaryDark = Color(0xFF09090B); // Primary Action & Accent (Hitam Pekat)
  static const Color bgLight = Color(0xFFFAFAFA);     // Latar belakang utama (Off-White)
  static const Color surfaceLight = Color(0xFFFFFFFF); // Warna Surface Kartu (Putih)
  
  // Teks & Subtitle
  static const Color textDark = Color(0xFF09090B);     // Teks Utama (Hitam)
  static const Color textMuted = Color(0xFF71717A);    // Teks Sekunder / Muted (Zinc-500)
  
  // Border & Divider
  static const Color borderLight = Color(0xFFE4E4E7);  // Border Tipis (Zinc-200)
  
  // Deprecated Fallback Compatibility (Aksen Merah Diganti ke Hitam Utuh)
  static const Color primaryRed = Color(0xFF09090B);

  static const Color destructive = Color(0xFFEF4444);
}