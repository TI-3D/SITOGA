import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../pages/forgot_password.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String?> login(String username, String password) async {
    final url = Uri.parse(
        'http://127.0.0.1:8000/auth/login'); // Ganti dengan URL backend

    final response = await http.post(
      url,
      headers: {
        'Content-Type':
            'application/x-www-form-urlencoded', // Format sesuai OAuth2
      },
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Login berhasil! Token: ${data['access_token']}');
      return data['access_token']; // Mengembalikan token
    } else {
      print('Login gagal: ${response.body}');
      throw Exception('Login gagal: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/toga_sirih.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Color(0xFF2F2F2F),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFDBFFB7),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFDBFFB7),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    TextField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Color(0xFF2F2F2F),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFDBFFB7),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFDBFFB7),
                            width: 2.0,
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xFF75E00A)),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        String username = emailController.text;
                        String password = passwordController.text;

                        try {
                          // Panggil fungsi login dan dapatkan token
                          final token = await login(username, password);

                          if (token != null) {
                            // Navigasi ke halaman berikutnya
                            Navigator.pushReplacementNamed(context,
                                '/home'); // Ganti '/home' dengan rute halaman berikutnya
                          }
                        } catch (error) {
                          // Tampilkan pesan error jika login gagal
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login gagal: $error')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF75E00A),
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Garis dan teks "Or"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 35),

                    // Login dengan
                    Center(
                      child: Text(
                        'Login with',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 35),

                    // Box untuk login sosial media
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                              'assets/icons/google_36.png'), // Ganti dengan path ikon Gmail Anda
                          onPressed: () {
                            // Logic untuk login dengan Gmail
                          },
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Image.asset(
                              'assets/icons/facebook_36.png'), // Ganti dengan path ikon Facebook Anda
                          onPressed: () {
                            // Logic untuk login dengan Facebook
                          },
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Image.asset(
                              'assets/icons/twitter_38.png'), // Ganti dengan path ikon Twitter Anda
                          onPressed: () {
                            // Logic untuk login dengan Twitter
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 35),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: "Sign up",
                                style: TextStyle(color: Color(0xFF75E00A)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
