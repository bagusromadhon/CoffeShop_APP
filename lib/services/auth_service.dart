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
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      print('ERROR signIn: $e');
      return 'Terjadi kesalahan, coba lagi.';
    }
  }

  static Future<String?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      // 1. sign up user
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) {
        return 'Gagal membuat user (user null).';
      }

      // 2. insert ke profiles
      final insertRes = await supabase.from('profiles').insert({
        'id': user.id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      });

      print('Insert profiles result: $insertRes');

      return null;
    } on AuthException catch (e) {
      print('AUTH ERROR signUp: $e');
      return e.message;
    } on PostgrestException catch (e) {
      print('POSTGREST ERROR signUp: ${e.message}');
      return e.message; // biar kamu lihat pesan error asli
    } catch (e) {
      print('UNKNOWN ERROR signUp: $e');
      return 'Terjadi kesalahan, coba lagi.';
    }
  }

  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
