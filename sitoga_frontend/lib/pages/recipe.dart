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
  String selectedCategory = "All"; // Default filter: All categories
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
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Stack(
              children: [
                TextField(
                  controller: _RecipeController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                if (showDropdown)
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
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
                            style: TextStyle(color: Colors.white),
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

            // Category Filters
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

            // Display Recipes
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.6,
                ),
                itemCount: displayedRecipe.length,
                itemBuilder: (context, index) {
                  final recipe = displayedRecipe[index];
                  return PlantCard3(
                    name: recipe["name"]!,
                    imagePath: recipe["image"]!,
                    description: recipe["description"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build category filter buttons
  Widget _buildCategoryButton(String category) {
    bool isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => _filterByCategory(category),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.grey[800],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class PlantCard3 extends StatefulWidget {
  final String name;
  final String imagePath;
  final String description;

  const PlantCard3({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.description,
  }) : super(key: key);

  @override
  _PlantCard3State createState() => _PlantCard3State();
}

class _PlantCard3State extends State<PlantCard3> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 8.0, vertical: 16.0), // Add more vertical padding here
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(
                  recipeName: widget.name,
                  recipeDescription: widget.description,
                  recipeImagePath: widget.imagePath,
                  ingredients: ["Ingredient 1", "Ingredient 2", "Ingredient 3"],
                  instructions: [
                    "1. Step 1",
                    "2. Step 2",
                    "3. Step 3",
                  ],
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.imagePath,
                        width: double.infinity,
                        height: 160, // Increased height for the image
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(12.0), // Adjust padding here
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Larger font size for the name
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(
                              height:
                                  8), // Increased space between name and description
                          Text(
                            widget.description,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16, // Larger font size for description
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isBookmarked = !isBookmarked;
                      });
                    },
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.white : Colors.white,
                    ),
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
