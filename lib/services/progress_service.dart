import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProgressService {
  static const String _progressKey = 'user_progress';
  static const String _xpKey = 'user_xp';
  static const String _overallProgressKey = 'overall_progress';

  // Get overall progress percentage
  static Future<double> getOverallProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_overallProgressKey) ?? 0.0;
  }

  // Update overall progress
  static Future<void> updateOverallProgress(double progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_overallProgressKey, progress);
  }

  // Get user's total XP
  static Future<int> getUserXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  // Add XP to user
  static Future<int> addXP(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentXP = await getUserXP();
    final newXP = currentXP + amount;
    await prefs.setInt(_xpKey, newXP);
    return newXP;
  }

  // Get all completed concepts
  static Future<Map<String, dynamic>> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);
    if (progressJson != null) {
      return json.decode(progressJson) as Map<String, dynamic>;
    }
    return {};
  }

  // Mark a concept as complete
  static Future<void> markConceptComplete(
    String subjectName,
    String chapterName,
    String conceptName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final progress = await getProgress();

    final subjectKey = subjectName.toLowerCase().replaceAll(' ', '_');
    final chapterKey = chapterName.toLowerCase().replaceAll(' ', '_');
    final conceptKey = conceptName.toLowerCase().replaceAll(' ', '_');

    if (progress[subjectKey] == null) {
      progress[subjectKey] = {};
    }
    if (progress[subjectKey][chapterKey] == null) {
      progress[subjectKey][chapterKey] = {};
    }

    progress[subjectKey][chapterKey][conceptKey] = {
      'completed': true,
      'completedAt': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_progressKey, json.encode(progress));

    // Award XP (typically 20-30 XP per concept)
    await addXP(20);

    // Update overall progress
    await _calculateOverallProgress();
  }

  // Check if a concept is completed
  static Future<bool> isConceptComplete(
    String subjectName,
    String chapterName,
    String conceptName,
  ) async {
    final progress = await getProgress();
    final subjectKey = subjectName.toLowerCase().replaceAll(' ', '_');
    final chapterKey = chapterName.toLowerCase().replaceAll(' ', '_');
    final conceptKey = conceptName.toLowerCase().replaceAll(' ', '_');

    return progress[subjectKey]?[chapterKey]?[conceptKey]?['completed'] == true;
  }

  // Check if a concept is ready to start (previous concepts completed)
  static Future<bool> isConceptReady(
    String subjectName,
    String chapterName,
    String conceptName,
    List<String> previousConcepts,
  ) async {
    // If no previous concepts, it's ready
    if (previousConcepts.isEmpty) {
      return true;
    }

    // Check if all previous concepts are completed
    for (final prevConcept in previousConcepts) {
      final isCompleted = await isConceptComplete(subjectName, chapterName, prevConcept);
      if (!isCompleted) {
        return false;
      }
    }

    return true;
  }

  // Calculate overall progress percentage
  static Future<void> _calculateOverallProgress() async {
    // This is a simplified calculation
    // In a real app, you'd count total vs completed concepts across all subjects
    final progress = await getProgress();
    int totalConcepts = 0;
    int completedConcepts = 0;

    progress.forEach((subject, chapters) {
      if (chapters is Map) {
        chapters.forEach((chapter, concepts) {
          if (concepts is Map) {
            totalConcepts += concepts.length;
            concepts.forEach((concept, data) {
              if (data is Map && data['completed'] == true) {
                completedConcepts++;
              }
            });
          }
        });
      }
    });

    final overallProgress = totalConcepts > 0 
        ? completedConcepts / totalConcepts 
        : 0.0;

    await updateOverallProgress(overallProgress);
  }

  // Get difficulty level based on user's performance
  static Future<String> getDifficultyLevel() async {
    final overallProgress = await getOverallProgress();
    
    // Analyze performance to determine difficulty
    // Higher progress = more advanced content
    if (overallProgress > 0.8) {
      return "Hard";
    } else if (overallProgress > 0.5) {
      return "Medium";
    }
    return "Easy";
  }

  // Reset all progress (for testing/debugging)
  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
    await prefs.remove(_xpKey);
    await prefs.remove(_overallProgressKey);
  }
}
