import 'package:flutter/material.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeName;
  final String recipeDescription;
  final String recipeImagePath;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeDetailPage({
    Key? key,
    required this.recipeName,
    required this.recipeDescription,
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
      body: CustomScrollView(
        slivers: [
          // Bagian gambar yang akan menghilang saat di-scroll
          SliverAppBar(
            expandedHeight: 250.0, // Tinggi area gambar
            floating: false,
            pinned: true, // Menampilkan AppBar tetap saat di-scroll
            automaticallyImplyLeading: true, // Otomatis menampilkan ikon back
            title: Text(
              'Recipe Details',
              style: TextStyle(color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.recipeImagePath, // Menggunakan gambar yang diterima
                fit: BoxFit.cover,
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
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.white : Colors.grey,
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
                  Text(
                    widget.recipeDescription, // Deskripsi resep dinamis
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),

                  // Bahan-bahan
                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  for (var ingredient in widget.ingredients)
                    Text("- $ingredient"),
                  SizedBox(height: 16),

                  // Cara memasak
                  Text(
                    "How to Cook",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  for (var step in widget.instructions) Text(step),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
