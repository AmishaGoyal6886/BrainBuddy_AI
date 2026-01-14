import 'package:flutter/material.dart';

class ConceptScreen extends StatelessWidget {
  final String title;

  const ConceptScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.deepPurple,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: "Explanation"),
              Tab(text: "Notes"),
              Tab(text: "Mindmap"),
              Tab(text: "Quiz"),
            ],
          ),

        ),
        body: const TabBarView(
          children: [
            // ================= EXPLANATION =================
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                "Acids, bases and salts are substances commonly used in our daily life.\n\n"
                    "🔹 Acids:\n"
                    "• Taste sour\n"
                    "• Found naturally in lemon and vinegar\n"
                    "• Example: Citric acid, Acetic acid\n\n"
                    "🔹 Bases:\n"
                    "• Taste bitter and feel soapy\n"
                    "• Found in soap and baking soda solution\n\n"
                    "🔹 Salts:\n"
                    "• Formed when an acid reacts with a base\n"
                    "• Used in daily life and industries\n"
                    "• Example: Common salt (NaCl)",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // ================= NOTES =================
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                "📌 IMPORTANT NOTES\n\n"
                    "• Acids are sour in taste\n"
                    "• Bases are bitter and soapy\n"
                    "• Salts are formed from acid + base\n\n"
                    "Examples:\n"
                    "• Lemon → Acid\n"
                    "• Soap → Base\n"
                    "• Common salt → NaCl\n\n"
                    "Acids and bases are identified using indicators.",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // ================= MINDMAP =================
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                "🧠 MINDMAP\n\n"
                    "Acids, Bases & Salts\n"
                    "│\n"
                    "├── Acids\n"
                    "│   ├ Sour taste\n"
                    "│   ├ Lemon\n"
                    "│   └ Vinegar\n"
                    "│\n"
                    "├── Bases\n"
                    "│   ├ Bitter taste\n"
                    "│   ├ Soap\n"
                    "│   └ Baking soda\n"
                    "│\n"
                    "└── Salts\n"
                    "    ├ Formed from acid + base\n"
                    "    ├ Common salt\n"
                    "    └ Daily uses",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // ================= QUIZ + ASSIGNMENT =================
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                "🧪 QUIZ\n\n"
                    "Q1. Which of the following tastes sour?\n"
                    "• Lemon ✅\n\n"
                    "Q2. Which substance feels soapy?\n"
                    "• Base ✅\n\n"
                    "Q3. What is common salt?\n"
                    "• Salt ✅\n\n"
                    "✔ Passing rule: 2 out of 3 correct\n\n"
                    "📝 ASSIGNMENT\n\n"
                    "1. Name two natural acids used in daily life.\n"
                    "2. Write one difference between acids and bases.\n"
                    "3. Where do we use common salt in daily life?",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
