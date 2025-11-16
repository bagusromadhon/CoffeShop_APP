import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class AuthService {
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null; // sukses
    } on AuthException catch (e) {
      return e.message; // error dari Supabase
    } catch (_) {
      return 'Terjadi kesalahan, coba lagi.';
    }
  }

  static Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Terjadi kesalahan, coba lagi.';
    }
  }

  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
