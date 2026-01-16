import 'package:flutter/material.dart';
import '../services/user_data_service.dart';
import '../services/progress_service.dart';

class ConceptDetailScreen extends StatefulWidget {
  final String subjectName;
  final String chapterName;
  final String conceptName;

  const ConceptDetailScreen({
    super.key,
    required this.subjectName,
    required this.chapterName,
    required this.conceptName,
  });

  @override
  State<ConceptDetailScreen> createState() => _ConceptDetailScreenState();
}

class _ConceptDetailScreenState extends State<ConceptDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = true;
  String? _explanation;
  List<Map<String, dynamic>>? _assignments;
  String _difficultyLevel = "Medium"; // Will be determined from reports
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateContent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _generateContent() async {
    // Simulate AI content generation
    setState(() {
      _isGenerating = true;
    });

    // Get user's difficulty level based on previous performance
    _difficultyLevel = await _determineDifficultyLevel();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate personalized content based on difficulty
    final explanation = _generateExplanation();
    final assignments = _generateAssignments();

    setState(() {
      _explanation = explanation;
      _assignments = assignments;
      _isGenerating = false;
    });
  }

  Future<String> _determineDifficultyLevel() async {
    // In real app, this would analyze reports and progress
    // For now, return based on a simple check
    final progress = await ProgressService.getOverallProgress();
    if (progress > 0.8) {
      return "Hard";
    } else if (progress > 0.5) {
      return "Medium";
    }
    return "Easy";
  }

  String _generateExplanation() {
    // Personalized explanation based on difficulty level
    final baseExplanation = _getBaseExplanation();
    
    if (_difficultyLevel == "Easy") {
      return "$baseExplanation\n\n💡 **Simple Explanation**: This concept is like building blocks - once you understand the basics, everything else becomes easier!";
    } else if (_difficultyLevel == "Medium") {
      return "$baseExplanation\n\n📚 **Key Points**: Focus on understanding the relationships between different parts of this concept.";
    } else {
      return "$baseExplanation\n\n🎯 **Advanced Understanding**: This concept connects to multiple areas. Understanding it deeply will help you master related topics.";
    }
  }

  String _getBaseExplanation() {
    // Base explanation for the concept
    if (widget.conceptName.toLowerCase().contains("introduction")) {
      return """
**What is ${widget.conceptName}?**

${widget.conceptName} is a fundamental concept in ${widget.chapterName} that forms the basis for more advanced topics.

**Why is it important?**

Understanding this concept is crucial because:
• It builds the foundation for future learning
• Many real-world applications use this principle
• It helps develop critical thinking skills

**How does it work?**

The basic principle involves understanding the core components and how they interact with each other.
""";
    } else if (widget.conceptName.toLowerCase().contains("standard form")) {
      return """
**Standard Form in ${widget.chapterName}**

The standard form is a way of writing equations that makes them easier to solve and understand.

**Structure:**
• A standardized format
• Easy to identify key components
• Simplifies problem-solving

**Example:**
A quadratic equation in standard form is: ax² + bx + c = 0

**Key Benefits:**
• Consistent structure
• Easy comparison
• Simplifies calculations
""";
    } else {
      return """
**Understanding ${widget.conceptName}**

${widget.conceptName} is an important topic in ${widget.chapterName} that helps you solve complex problems.

**Core Concepts:**
• Fundamental principles
• Practical applications
• Problem-solving strategies

**Learning Objectives:**
• Master the basic concepts
• Apply knowledge to solve problems
• Build confidence in this area

**Real-World Applications:**
This concept is used in various fields and everyday situations.
""";
    }
  }

  List<Map<String, dynamic>> _generateAssignments() {
    // Generate assignments based on difficulty level
    final List<Map<String, dynamic>> assignments = [];

    if (_difficultyLevel == "Easy") {
      assignments.addAll([
        {
          'type': 'Multiple Choice',
          'question': 'What is the basic definition of this concept?',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'points': 10,
        },
        {
          'type': 'True/False',
          'question': 'This concept can be applied in real-world scenarios.',
          'points': 10,
        },
        {
          'type': 'Short Answer',
          'question': 'Explain this concept in your own words.',
          'points': 15,
        },
      ]);
    } else if (_difficultyLevel == "Medium") {
      assignments.addAll([
        {
          'type': 'Problem Solving',
          'question': 'Solve a problem using this concept. Show your work.',
          'points': 20,
        },
        {
          'type': 'Application',
          'question': 'Apply this concept to a given scenario.',
          'points': 20,
        },
        {
          'type': 'Analysis',
          'question': 'Compare and contrast this concept with related topics.',
          'points': 25,
        },
      ]);
    } else {
      assignments.addAll([
        {
          'type': 'Advanced Problem',
          'question': 'Solve a complex problem requiring deep understanding of this concept.',
          'points': 30,
        },
        {
          'type': 'Synthesis',
          'question': 'Combine this concept with other topics to create a solution.',
          'points': 35,
        },
        {
          'type': 'Critical Thinking',
          'question': 'Analyze a real-world problem and propose a solution using this concept.',
          'points': 35,
        },
      ]);
    }

    return assignments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A5AE0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.conceptName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Explanation"),
            Tab(text: "Assignments"),
          ],
        ),
      ),
      body: _isGenerating
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildExplanationTab(),
                _buildAssignmentsTab(),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A5AE0)),
          ),
          const SizedBox(height: 24),
          Text(
            "AI is generating personalized content...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Difficulty Level: $_difficultyLevel",
              style: const TextStyle(
                color: Color(0xFF6A5AE0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Difficulty Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _difficultyLevel == "Easy"
                  ? Colors.green.withOpacity(0.1)
                  : _difficultyLevel == "Medium"
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _difficultyLevel == "Easy"
                      ? Icons.thumb_up
                      : _difficultyLevel == "Medium"
                          ? Icons.trending_up
                          : Icons.school,
                  size: 16,
                  color: _difficultyLevel == "Easy"
                      ? Colors.green
                      : _difficultyLevel == "Medium"
                          ? Colors.orange
                          : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  "Personalized for: $_difficultyLevel Level",
                  style: TextStyle(
                    color: _difficultyLevel == "Easy"
                        ? Colors.green
                        : _difficultyLevel == "Medium"
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Explanation Content
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _explanation ?? "",
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Additional Resources
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Color(0xFF6A5AE0)),
                    const SizedBox(width: 8),
                    const Text(
                      "Study Tips",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A5AE0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTipItem("Take notes as you read through the explanation"),
                _buildTipItem("Try to explain the concept in your own words"),
                _buildTipItem("Complete the assignments to test your understanding"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF6A5AE0),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Assignments",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A5AE0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_assignments?.length ?? 0} Questions",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Difficulty: $_difficultyLevel • Total Points: ${_assignments?.fold<int>(0, (sum, a) => sum + (a['points'] as int)) ?? 0}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          // Assignment Cards
          ...(_assignments ?? []).asMap().entries.map((entry) {
            final index = entry.key;
            final assignment = entry.value;
            return _buildAssignmentCard(index + 1, assignment);
          }),
          const SizedBox(height: 20),
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showSubmissionDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Complete Concept",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(int number, Map<String, dynamic> assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  assignment['type'] as String,
                  style: const TextStyle(
                    color: Color(0xFF6A5AE0),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "${assignment['points']} pts",
                style: const TextStyle(
                  color: Color(0xFF6A5AE0),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "$number. ${assignment['question'] as String}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          if (assignment['options'] != null) ...[
            const SizedBox(height: 12),
            ...(assignment['options'] as List<String>).map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            }),
          ] else ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type your answer here...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                maxLines: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Complete Concept?"),
          content: const Text(
            "You will earn XP upon completion. Make sure you've reviewed all the content and attempted the assignments.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Mark concept as complete
                await ProgressService.markConceptComplete(
                  widget.subjectName,
                  widget.chapterName,
                  widget.conceptName,
                );
                // Show success and navigate back
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Concept completed! You earned XP."),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
              ),
              child: const Text("Complete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
