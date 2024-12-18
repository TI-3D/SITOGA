import 'package:flutter/material.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeName;
  // final String recipeDescription;
  final String recipeImagePath;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeDetailPage({
    Key? key,
    required this.recipeName,
    // required this.recipeDescription,
    required this.recipeImagePath,
    required this.ingredients,
    required this.instructions,
  }) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF72BF78), // Green top
                  Color(0xFFA0D683), // Green middle
                  Color(0xFFF1F8E8), // Light green bottom
                ],
              ),
            ),
          ),

          // Content with CustomScrollView
          CustomScrollView(
            slivers: [
              // Bagian gambar yang akan menghilang saat di-scroll
              SliverAppBar(
                expandedHeight: 250.0, // Tinggi area gambar
                floating: false,
                pinned: true, // Menampilkan AppBar tetap saat di-scroll
                automaticallyImplyLeading: true, // Otomatis menampilkan ikon back
                backgroundColor: Colors.transparent,
                title: Text(
                  'Recipe Details',
                  style: TextStyle(color: Colors.white),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.darken,
                    child: Image.asset(
                      widget.recipeImagePath, // Menggunakan gambar yang diterima
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Konten di bawah gambar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama resep dengan ikon bookmark
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.recipeName, // Nama resep dinamis
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A5319),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked ? Color(0xFF72BF78) : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                isBookmarked = !isBookmarked;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Deskripsi resep
                      // Text(
                        // widget.recipeDescription,
                        // style: TextStyle(fontSize: 16, color: Color(0xFF1A5319)),
                      // ),
                      SizedBox(height: 16),

                      // Bahan-bahan
                      Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A5319),
                        ),
                      ),
                      SizedBox(height: 8),
                      for (var ingredient in widget.ingredients)
                        Text(
                          "- $ingredient",
                          style: TextStyle(color: Color(0xFF1A5319)),
                        ),
                      SizedBox(height: 16),

                      // Cara memasak
                      Text(
                        "How to Cook",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A5319),
                        ),
                      ),
                      SizedBox(height: 8),
                      for (var step in widget.instructions)
                        Text(
                          step,
                          style: TextStyle(color: Color(0xFF1A5319)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
