import 'package:flutter/material.dart';
import 'history.dart';
import 'favorites.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Edit profile action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFF1A5319),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
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
                      // Navigate to Favorites page
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
                      // Navigate to History page
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
                      // Log out action
                    },
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
