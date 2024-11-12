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
    return Container(
      color: Colors.black, // Mengatur warna latar belakang jika diperlukan
      child: ListView(
        children: [
          // Background image with transparency
          Stack(
            children: [
              // Background image starts from the top and extends just below "Hi Abby"
              Container(
                height:
                    300, // Adjust this height to cover from "Hi Abby" to above the first card
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/nangka.jpg"), // Gambar latar belakang
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6),
                        BlendMode
                            .darken), // Menambahkan transparansi dan menggelapkan gambar
                  ),
                ),
              ),
              // Title placed just over the background image
              Positioned(
                top: 250, // Posisi judul di bawah gambar latar
                left: 16,
                child: Text(
                  "Pemindaian Terakhir",
                  style: TextStyle(
                      color: Colors.white,
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

          // Today's Choices Section (Two cards side by side)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              "Pilihan Hari Ini",
              style: TextStyle(
                  color: Colors.white,
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

          // Favorite Plants Section (Two cards side by side)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              "Tanaman Favorit",
              style: TextStyle(
                  color: Colors.white,
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
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
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
                          color: Colors.white,
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
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
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
                      color: Colors.white,
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
                      color: Colors.white70,
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
