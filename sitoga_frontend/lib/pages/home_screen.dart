import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username; // Menyimpan username pengguna
  bool isLoading = true; // Untuk menunjukkan loading status

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Periksa session login saat init
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    setState(() {
      username = storedUsername; // Update state username
      isLoading = false; // Loading selesai
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indikator
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0XFF72BF78), // Green top
                    Color(0XFFA0D683), // Green middle
                    Color(0XFFF1F8E8), // Green bottom
                  ],
                  stops: [0.01, 0.1, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Background image with transparency
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage("assets/nangka.jpg"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.darken),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Text(
                          username != null
                              ? "Hi $username"
                              : "Hi Guest", // Menampilkan Hi Guest atau username
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Bagian Pemindaian Terakhir (hanya untuk user login)
                  if (username != null) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Text(
                        "Pemindaian terakhir",
                        style: TextStyle(
                          color: Color(0XFF1A5319),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          plantInfoCard1(context, "Jambu Biji",
                              "assets/jambu_biji.jpg"),
                          plantInfoCard1(context, "Sirih",
                              "assets/toga_sirih.jpg"),
                        ],
                      ),
                    ),
                  ],

                  // Pilihan Hari Ini (Selalu muncul)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Text(
                      "Pilihan Hari Ini",
                      style: TextStyle(
                          color: Color(0XFF1A5319),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 280,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: plantInfoCard2(
                              context,
                              "Jambu Biji",
                              "jambu biji adalah",
                              "assets/jambu_biji.jpg"),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: plantInfoCard2(
                              context,
                              "Sirih",
                              "sirih adalah",
                              "assets/toga_sirih.jpg"),
                        ),
                      ],
                    ),
                  ),

                  // Tanaman Favorit (hanya untuk user login)
                  if (username != null) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Text(
                        "Tanaman Favorit",
                        style: TextStyle(
                          color: Color(0XFF1A5319),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 280,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: plantInfoCard2(
                                context,
                                "Jambu Biji",
                                "jambu biji adalah",
                                "assets/jambu_biji.jpg"),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: plantInfoCard2(
                                context,
                                "Sirih",
                                "sirih adalah",
                                "assets/toga_sirih.jpg"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget plantInfoCard1(BuildContext context, String name, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          // Detail tanaman
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Color(0XFF1A5319),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget plantInfoCard2(BuildContext context, String name, String description,
    String imagePath) {
  return GestureDetector(
    onTap: () {
      // Aksi ketika kartu ditekan
    },
    child: Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gambar dengan BoxFit.cover agar proporsional
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          // Nama tanaman
          Text(
            name,
            style: TextStyle(
              color: Color(0XFF1A5319),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          // Deskripsi tanaman
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}

}
