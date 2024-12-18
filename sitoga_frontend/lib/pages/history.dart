import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/config.dart'; // Ensure you have this config file
import 'plant_detail.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;
  int? userId; // User ID for fetching history

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Fetch user_id from SharedPreferences
  Future<void> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('user_id');
    
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      _fetchHistory(); // Fetch history if userId is available
    }
  }

  // Fetch history data from backend
  Future<void> _fetchHistory() async {
    if (userId == null) {
      print("User ID not found.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/history/history'),
        body: {'user_id': userId.toString()}, // Pass the user_id for the request
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            history = List<Map<String, dynamic>>.from(responseData['data']);
          });
        } else {
          print('Failed to load history: ${responseData['detail']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching history: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearSnackBars();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: const Text('History'),
          backgroundColor: Color(0XFF72BF78),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0XFF72BF78), // Green top
                      Color(0XFFFA0D683), // Green bottom
                      Color(0XFFF1F8E8), // Light color below
                    ],
                    stops: [0.01, 0.1, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                  ),
                ),
                child: history.isEmpty
                    ? const Center(
                        child: Text(
                          'No History Added',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final plant = history[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            color: Color(0XFFDFF5D8), // Card color
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlantDetailPage(
                                        plantData: plant,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  plant['image_path'] ?? 'assets/placeholder.jpg',
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlantDetailPage(
                                        plantData: plant,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  plant['plant_name'] ?? "No Name",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF1A5319),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                plant['nama_latin'] ?? 'No Latin Name',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0XFF1A5319),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    history.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${plant['name']} removed!'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
