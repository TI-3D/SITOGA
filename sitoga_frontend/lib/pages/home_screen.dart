import 'package:flutter/material.dart';
import 'package:sitoga_frontend/pages/plant_detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> favoritePlants = ["Jambu Biji", "Sirih"];

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
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Background image with transparency
            Stack(
              children: [
                // Background image starts from the top and extends just below "Hi Abby"
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/nangka.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken),
                    ),
                  ),
                ),
                // Title placed just over the background image
                Positioned(
                  top: 250,
                  left: 16,
                  child: Text(
                    "Pemindaian Terakhir",
                    style: TextStyle(
                        color: Colors.white, // Keep white text color for this title
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  plantInfoCard1(context, "Jambu Biji", "assets/jambu_biji.jpg"),
                  plantInfoCard1(context, "Sirih", "assets/toga_sirih.jpg"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Text(
                "Pilihan Hari Ini",
                style: TextStyle(
                    color: Color(0XFF1A5319), // Green text for this title
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
                    child: plantInfoCard2(context, "Jambu Biji",
                        "jambu biji adalah", "assets/jambu_biji.jpg"),
                  ),
                  SizedBox(width: 0),
                  Expanded(
                    child: plantInfoCard2(context, "Sirih", "sirih adalah",
                        "assets/toga_sirih.jpg"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Text(
                "Tanaman Favorit",
                style: TextStyle(
                    color: Color(0XFF1A5319), // Green text for this title
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
                    child: plantInfoCard2(context, "Jambu Biji",
                        "jambu biji adalah", "assets/jambu_biji.jpg"),
                  ),
                  SizedBox(width: 0),
                  Expanded(
                    child: plantInfoCard2(context, "Sirih", "sirih adalah",
                        "assets/toga_sirih.jpg"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget plantInfoCard1(BuildContext context, String name, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetailPage(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              color: Color(0XFFDFF5D8), // Updated to match profile card colors
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5)],
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: double.infinity,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Color(0XFF1A5319), // Green text for plant name
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget plantInfoCard2(
      BuildContext context, String name, String description, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetailPage(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 280,
            decoration: BoxDecoration(
              color: Color(0XFFDFF5D8), // Updated to match profile card colors
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Color(0XFF1A5319), // Green text for plant name
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[700], // Lighter text color for description
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
