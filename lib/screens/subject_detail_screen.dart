import 'package:flutter/material.dart';
import 'chapter_concepts_screen.dart';

class SubjectDetailScreen extends StatelessWidget {
  final String subjectName;
  
  const SubjectDetailScreen({
    super.key,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    // Sample chapter data - in real app, this would come from a service
    final chapters = _getChaptersForSubject(subjectName);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6A5AE0),
                    Color(0xFF8E7BFF),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        subjectName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mastery Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E6FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Mastery: 78%",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Today's study completed",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "18 / 30 min completed",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    value: 0.78,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                  ),
                                ),
                                const Text(
                                  "78%",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Chapters Section
                    const Text(
                      "Chapters",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chapters List
                    ...chapters.map((chapter) => _buildChapterCard(
                      context,
                      chapter['name'] as String,
                      chapter['progress'] as double,
                      chapter['difficulty'] as String,
                      chapter['status'] as String,
                      chapter['icon'] as IconData,
                    )),
                    
                    const SizedBox(height: 24),

                    // XP and Rank Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Color(0xFF6A5AE0),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Current XP: 285",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rank: #12",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tip Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Tip: Progress faster by improving in Needs Attention chapters!",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, 1),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    String name,
    double progress,
    String difficulty,
    String status,
    IconData icon,
  ) {
    Color difficultyColor;
    if (difficulty == "Easy") {
      difficultyColor = Colors.green;
    } else if (difficulty == "Medium") {
      difficultyColor = Colors.orange;
    } else {
      difficultyColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChapterConceptsScreen(
              subjectName: subjectName,
              chapterName: name,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF6A5AE0), size: 24),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Progress: ${(progress * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0 ? Colors.green : const Color(0xFF6A5AE0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Difficulty and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      color: difficultyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (status.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getChaptersForSubject(String subject) {
    if (subject.toLowerCase().contains("math")) {
      return [
        {
          'name': 'Quadratic Equations',
          'progress': 0.65,
          'difficulty': 'Easy',
          'status': 'Needs Attention',
          'icon': Icons.show_chart,
        },
        {
          'name': 'Linear Equations',
          'progress': 0.40,
          'difficulty': 'Medium',
          'status': '',
          'icon': Icons.trending_up,
        },
        {
          'name': 'Trigonometry',
          'progress': 1.0,
          'difficulty': 'Easy',
          'status': '',
          'icon': Icons.change_history,
        },
        {
          'name': 'Probability',
          'progress': 0.0,
          'difficulty': 'Medium',
          'status': '',
          'icon': Icons.casino,
        },
      ];
    } else {
      // Default chapters for other subjects
      return [
        {
          'name': 'Introduction',
          'progress': 0.50,
          'difficulty': 'Easy',
          'status': '',
          'icon': Icons.book,
        },
        {
          'name': 'Advanced Topics',
          'progress': 0.25,
          'difficulty': 'Medium',
          'status': '',
          'icon': Icons.school,
        },
      ];
    }
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF6A5AE0),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: "Study",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: "Navigator",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Reports",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
