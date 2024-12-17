import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history.dart';
import 'favorites.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<bool> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Cek apakah ada data pengguna yang tersimpan dalam session
    String? username = prefs.getString('username');
    return username != null;
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Hapus data sesi
    await prefs.clear();
    // Navigasikan pengguna kembali ke halaman login
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading spinner saat memeriksa status login
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == false) {
          // Jika belum login, tampilkan dialog pop-up
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Required'),
                  content: Text('Please log in to access your profile.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('Login'),
                    ),
                  ],
                );
              },
            );
          });
          return Scaffold(

            // appBar: AppBar(
            //   title: Text('Profile'),
            //   backgroundColor: Color(0XFF72BF78),
            // ),
            body: Center(
              child: Text(
                'Please log in to view your profile.',
                style: TextStyle(fontSize: 18, color: Colors.white),

              ),
            ),
          );
        }

        // Jika sudah login, tampilkan halaman profile
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0XFF72BF78), // Green top
                  Color(0XFFA0D683), // Green middle
                  Color(0XFFF1F8E8), // Green bottom
                ],
                stops: [0.01, 0.1, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // Profile photo and user name
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/flower.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'User',
                  style: TextStyle(
                      color: Color(0XFF1A5319), fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'User@gmail.com',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 30),
                // Feature list
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.favorite, color: Color(0XFF1A5319)),
                        title: Text('Favorites', style: TextStyle(color: Color(0XFF1A5319))),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.history, color: Color(0XFF1A5319)),
                        title: Text('History', style: TextStyle(color: Color(0XFF1A5319))),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text('Log Out', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          _logout();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
