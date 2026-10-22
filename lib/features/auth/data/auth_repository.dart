import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failure.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      if (response.user == null) {
        throw const Failure('Gagal mendaftarkan akun.');
      }
    } on AuthException catch (e) {
      throw Failure(e.message);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const Failure('Gagal masuk. Periksa kembali email dan password.');
      }
    } on AuthException catch (e) {
      throw Failure(e.message);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw Failure(e.message);
    }
  }
}