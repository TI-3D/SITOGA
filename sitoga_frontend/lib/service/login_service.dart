import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> login(String username, String password) async {
  final url =
      Uri.parse('http://127.0.0.1:8000/login'); // Ganti dengan URL backend
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Login berhasil! Token: ${data['access_token']}');
  } else {
    print('Login gagal: ${response.body}');
  }
}
