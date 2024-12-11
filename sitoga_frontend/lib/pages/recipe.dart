import 'package:flutter/material.dart';
import 'recipe_detail.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final TextEditingController _RecipeController = TextEditingController();
  List<Map<String, String>> allRecipe = [
    {
      "name": "Jamu Jahe Merah Serai",
      "image": "assets/toga_sirih.jpg",
      "category": "Herbal",
      "description":
          "Ramuan tradisional yang bermanfaat untuk meningkatkan daya tahan tubuh."
    },
    {
      "name": "Teh Daun Sirih",
      "image": "assets/belimbing_wuluh.jpg",
      "category": "Tea",
      "description": "Teh herbal yang kaya manfaat untuk kesehatan tubuh."
    },
    {
      "name": "Ramuan Daun Jambu Biji",
      "image": "assets/jeruk_nipis.jpg",
      "category": "Juice",
      "description": "Minuman segar yang membantu menjaga kesehatan pencernaan."
    },
    {
      "name": "Ramuan Daun Kelor",
      "image": "assets/nangka.jpg",
      "category": "Herbal",
      "description":
          "Herbal alami yang dipercaya memiliki kandungan gizi tinggi."
    },
  ];
  List<Map<String, String>> displayedRecipe = [];
  List<Map<String, String>> filteredRecipe = [];
  String selectedCategory = "All";
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    displayedRecipe = allRecipe;
    _RecipeController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _RecipeController.removeListener(_onSearchChanged);
    _RecipeController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      String searchQuery = _RecipeController.text.toLowerCase();
      filteredRecipe = allRecipe
          .where(
              (recipe) => recipe["name"]!.toLowerCase().contains(searchQuery))
          .toList();
      showDropdown = searchQuery.isNotEmpty;
    });
  }

  void _selectPlant(String recipeName) {
    setState(() {
      _RecipeController.text = recipeName;
      displayedRecipe = allRecipe
          .where((recipe) =>
              recipe["name"]!.toLowerCase() == recipeName.toLowerCase())
          .toList();
      showDropdown = false;
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      displayedRecipe = category == "All"
          ? allRecipe
          : allRecipe
              .where((recipe) => recipe["category"] == category)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0XFF72BF78), // Hijau atas
              Color(0XFFA0D683), // Hijau tengah
              Color(0XFFF1F8E8), // Hijau bawah
            ],
            stops: [0.01, 0.1, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                TextField(
                  controller: _RecipeController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Color(0XFF1A5319)),
                    prefixIcon: Icon(Icons.search, color: Color(0XFF1A5319)),
                    filled: true,
                    fillColor: Color(0XFFDFF5D8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Color(0XFF1A5319)),
                ),
                if (showDropdown)
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Color(0XFFDFF5D8),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredRecipe.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipe[index];
                        return ListTile(
                          title: Text(
                            recipe["name"]!,
                            style: TextStyle(color: Color(0XFF1A5319)),
                          ),
                          onTap: () => _selectPlant(recipe["name"]!),
                        );
                      },
                      shrinkWrap: true,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton("All"),
                  _buildCategoryButton("Herbal"),
                  _buildCategoryButton("Tea"),
                  _buildCategoryButton("Juice"),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.75,
                ),
                itemCount: displayedRecipe.length,
                itemBuilder: (context, index) {
                  final recipe = displayedRecipe[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            recipeName: recipe["name"]!,
                            recipeDescription: recipe["description"]!,
                            recipeImagePath: recipe["image"]!,
                            ingredients: ["Ingredient 1", "Ingredient 2"],
                            instructions: ["Step 1", "Step 2"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0XFFDFF5D8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              recipe["image"]!,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              recipe["name"]!,
                              style: TextStyle(
                                color: Color(0XFF1A5319),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              recipe["description"]!,
                              style: TextStyle(
                                color: Color(0XFF1A5319),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => _filterByCategory(category),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0XFF1A5319) : Color(0XFFDFF5D8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Color(0XFFDFF5D8) : Color(0XFF1A5319),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
