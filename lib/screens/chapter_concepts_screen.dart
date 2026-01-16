import 'package:flutter/material.dart';
import 'concept_detail_screen.dart';
import '../services/progress_service.dart';

class ChapterConceptsScreen extends StatefulWidget {
  final String subjectName;
  final String chapterName;
  
  const ChapterConceptsScreen({
    super.key,
    required this.subjectName,
    required this.chapterName,
  });

  @override
  State<ChapterConceptsScreen> createState() => _ChapterConceptsScreenState();
}

class _ChapterConceptsScreenState extends State<ChapterConceptsScreen> {
  List<Map<String, dynamic>> concepts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConcepts();
  }

  Future<void> _loadConcepts() async {
    final allConcepts = _getConceptsForChapter(widget.chapterName);
    
    // Check completion and readiness for each concept
    final updatedConcepts = <Map<String, dynamic>>[];
    
    for (int i = 0; i < allConcepts.length; i++) {
      final concept = Map<String, dynamic>.from(allConcepts[i]);
      final conceptName = concept['name'] as String;
      
      // Check if completed
      final isCompleted = await ProgressService.isConceptComplete(
        widget.subjectName,
        widget.chapterName,
        conceptName,
      );
      
      // Get previous concepts (all concepts before this one)
      final previousConcepts = i > 0 
          ? allConcepts.sublist(0, i).map((c) => c['name'] as String).toList()
          : <String>[];
      
      // Check if ready (all previous completed)
      final isReady = await ProgressService.isConceptReady(
        widget.subjectName,
        widget.chapterName,
        conceptName,
        previousConcepts,
      );
      
      concept['isCompleted'] = isCompleted;
      concept['isReady'] = isReady && !isCompleted;
      concept['isLocked'] = !isReady && !isCompleted;
      
      updatedConcepts.add(concept);
    }
    
    setState(() {
      concepts = updatedConcepts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
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
                        widget.chapterName,
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

            // Banner
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6A5AE0),
                    Color(0xFF8E7BFF),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative elements
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Text(
                      "x²",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 60,
                    bottom: 30,
                    child: Text(
                      "x³",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Unlock lessons and master ${widget.chapterName} to win XP and improve your skills!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Concepts List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: concepts.length + 1, // +1 for tip
                itemBuilder: (context, index) {
                  if (index == concepts.length) {
                    // Tip at the end
                    return Container(
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
                              "Tip: Complete checkpoints to unlock new lessons!",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final concept = concepts[index];
                  final isLocked = concept['isLocked'] as bool;
                  final isCompleted = concept['isCompleted'] as bool;
                  final isReady = concept['isReady'] as bool;

                  return _buildConceptCard(
                    context,
                    concept['name'] as String,
                    concept['xp'] as int,
                    concept['requiredXp'] as int?,
                    isLocked,
                    isCompleted,
                    isReady,
                    index,
                    concepts.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptCard(
    BuildContext context,
    String name,
    int xp,
    int? requiredXp,
    bool isLocked,
    bool isCompleted,
    bool isReady,
    int index,
    int total,
  ) {
    Color circleColor;
    IconData icon;
    String statusText;
    Color statusColor;
    VoidCallback? onTap;

    if (isCompleted) {
      circleColor = Colors.green;
      icon = Icons.check_circle;
      statusText = "Complete";
      statusColor = Colors.green;
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConceptDetailScreen(
              subjectName: widget.subjectName,
              chapterName: widget.chapterName,
              conceptName: name,
            ),
          ),
        ).then((_) {
          // Reload concepts after returning from concept detail
          _loadConcepts();
        });
      };
    } else if (isReady) {
      circleColor = Colors.orange;
      icon = Icons.book;
      statusText = "Start";
      statusColor = const Color(0xFF6A5AE0);
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConceptDetailScreen(
              subjectName: widget.subjectName,
              chapterName: widget.chapterName,
              conceptName: name,
            ),
          ),
        ).then((_) {
          // Reload concepts after returning from concept detail
          _loadConcepts();
        });
      };
    } else {
      circleColor = Colors.grey.shade400;
      icon = Icons.lock;
      statusText = requiredXp != null ? "$requiredXp XP" : "Locked";
      statusColor = Colors.grey.shade600;
      onTap = null;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dotted line connector
              if (index < total - 1)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.only(top: 40, left: 19),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey.shade300,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              // Circle with icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isLocked ? Colors.grey.shade600 : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "+ $xp XP",
                              style: TextStyle(
                                fontSize: 13,
                                color: isLocked ? Colors.grey.shade500 : const Color(0xFF6A5AE0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  List<Map<String, dynamic>> _getConceptsForChapter(String chapter) {
    // Sample data - in real app, this would check progress from a service
    if (chapter == "Quadratic Equations") {
      return [
        {
          'name': 'Introduction',
          'xp': 20,
          'requiredXp': null,
          'isLocked': false,
          'isCompleted': true,
          'isReady': false,
        },
        {
          'name': 'Standard Form',
          'xp': 20,
          'requiredXp': null,
          'isLocked': false,
          'isCompleted': false,
          'isReady': true,
        },
        {
          'name': 'Factorization Method',
          'xp': 20,
          'requiredXp': 25,
          'isLocked': true,
          'isCompleted': false,
          'isReady': false,
        },
        {
          'name': 'Completing the Square',
          'xp': 20,
          'requiredXp': 25,
          'isLocked': true,
          'isCompleted': false,
          'isReady': false,
        },
        {
          'name': 'Solving Quadratics by Formula',
          'xp': 20,
          'requiredXp': 30,
          'isLocked': true,
          'isCompleted': false,
          'isReady': false,
        },
        {
          'name': 'Finding the Discriminant',
          'xp': 30,
          'requiredXp': 30,
          'isLocked': true,
          'isCompleted': false,
          'isReady': false,
        },
        {
          'name': 'Quadratic Word Problems',
          'xp': 30,
          'requiredXp': 30,
          'isLocked': true,
          'isCompleted': false,
          'isReady': false,
        },
      ];
    }
    
    // Default concepts for other chapters
    return [
      {
        'name': 'Introduction',
        'xp': 20,
        'requiredXp': null,
        'isLocked': false,
        'isCompleted': false,
        'isReady': true,
      },
      {
        'name': 'Core Concepts',
        'xp': 25,
        'requiredXp': 20,
        'isLocked': true,
        'isCompleted': false,
        'isReady': false,
      },
    ];
  }
}
