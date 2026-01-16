import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Progress Report",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.download, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your learning analytics",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // 🔹 STATS CARDS
            Row(
              children: const [
                _StatBox(title: "Concepts\nMastered", value: "24"),
                _StatBox(title: "Focused\nDays", value: "8"),
                _StatBox(title: "Study\nMinutes", value: "285"),
              ],
            ),

            const SizedBox(height: 30),

            // 🔹 WEEKLY STUDY TIME
            const Text(
              "Weekly Study Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _weeklyBars(),

            const SizedBox(height: 30),

            // 🔹 SUBJECT MASTERY
            const Text(
              "Subject Mastery",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _progressRow("Math", 0.78),
            _progressRow("Physics", 0.65),
            _progressRow("Chemistry", 0.85),
            _progressRow("Biology", 0.72),

            const SizedBox(height: 24),

            // 🔹 WEAKEST CHAPTER
            _infoCard(
              icon: Icons.menu_book,
              title: "Weakest Chapter",
              description:
              "Linear Equations — Solving equations containing variables on both sides.",
              bgColor: const Color(0xFFFFF7E6),
            ),

            const SizedBox(height: 16),

            // 🔹 TOP MISCONCEPTIONS
            _infoCard(
              icon: Icons.warning_amber,
              title: "Top Misconceptions",
              description:
              "1. Mass and weight confusion\n"
                  "2. Newton’s third law misinterpretation\n"
                  "3. Cell theory misunderstanding",
              bgColor: const Color(0xFFFFEEEE),
            ),

            const SizedBox(height: 16),

            // 🔹 AI INSIGHTS
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Color(0xFF4A3AFF)),
                      SizedBox(width: 8),
                      Text(
                        "AI Insights",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You're excelling, but struggling with linear equations. "
                        "Let’s focus on practice problems for this area.",
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5AE0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("View Recommendations"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 WEEKLY BAR CHART (SIMPLE UI VERSION)
  Widget _weeklyBars() {
    final values = [40, 60, 70, 55, 62, 48, 40];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((v) {
        return Column(
          children: [
            Container(
              width: 20,
              height: v.toDouble(),
              decoration: BoxDecoration(
                color: const Color(0xFFA8B7FF),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
          ],
        );
      }).toList(),
    );
  }

  // 🔹 SUBJECT PROGRESS ROW
  Widget _progressRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(title)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: const Color(0xFF6A8DFF),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text("${(value * 100).toInt()}%"),
        ],
      ),
    );
  }

  // 🔹 INFO CARD
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 SMALL STAT BOX
class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
