import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/kasir.dart';
import 'package:ukk_kasir/petugas/kasir.dart';
import 'package:ukk_kasir/user/pelanggan.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  _Loginpagestate createState() => _Loginpagestate();
}

class _Loginpagestate extends State<Loginpage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  final supabase = Supabase.instance.client;


  String encodePassword(String password) {
    return base64Encode(utf8.encode(password));
  }

  String decodePassword(String encodedPassword) {
    return utf8.decode(base64Decode(encodedPassword));
  }

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await supabase
          .from('users')
          .select('password, role')
          .eq('username', username)
          .maybeSingle();

      print('Response dari Supabase: $response');

      if (response == null || response['password'] == null || response['role'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User tidak ditemukan atau data tidak lengkap!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String storedPassword = response['password'];
      String role = response['role'];

      // print('Password dari database: $storedPassword');
      // print('Password yang dimasukkan: $password');
      print(encodePassword(password));

      if (decodePassword(storedPassword) == password) {
        _usernameController.clear();
        _passwordController.clear();
        print('Login berhasil! Role: $role');

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Admin()),
          );
        } else if (role == 'petugas') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Admin()),
          );
        } else if (role == 'pelanggan') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Pelanggan()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Role tidak dikenali!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan, coba lagi!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 244, 255),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 200, width: 200),
              ],
            ),
            Text(
              'Sign In and Start Working',
              style: GoogleFonts.poppins(
                color: Color(0xFF181D27),
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.027,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username', style: GoogleFonts.poppins(color: Color(0xFF181D27))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Type your username',
                      labelStyle: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 131, 131, 131),
                        fontSize: MediaQuery.of(context).size.height * 0.015,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  Text('Password', style: GoogleFonts.poppins(color: Color(0xFF181D27))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Type your password',
                      labelStyle: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 131, 131, 131),
                        fontSize: MediaQuery.of(context).size.height * 0.015,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 79, 77, 77).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 197, 217),
                        foregroundColor: const Color.fromARGB(255, 32, 30, 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
