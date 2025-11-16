import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    final email = _emailC.text.trim();
    final pass = _passC.text;
    final confirm = _confirmC.text;

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showMsg('Semua field wajib diisi');
      return;
    }
    if (pass != confirm) {
      _showMsg('Password dan konfirmasi tidak sama');
      return;
    }

    setState(() => _isLoading = true);

    final error = await AuthService.signUp(email: email, password: pass);

    setState(() => _isLoading = false);

    if (error == null) {
      _showMsg('Registrasi berhasil, silakan cek email jika perlu verifikasi');
      Navigator.pop(context); // balik ke login
    } else {
      _showMsg(error);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email.ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passC,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _confirmC,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('REGISTER'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
