import 'package:flutter/material.dart';
import 'student_dashboard_screen.dart';
import '../services/user_data_service.dart';

class OnboardingSubjectsScreen extends StatefulWidget {
  const OnboardingSubjectsScreen({super.key});

  @override
  State<OnboardingSubjectsScreen> createState() =>
      _OnboardingSubjectsScreenState();
}

class _OnboardingSubjectsScreenState
    extends State<OnboardingSubjectsScreen> {
  final List<String> subjects = [
    "Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
    "English",
    "Computer Science",
    "Social Science",
    "Hindi",
  ];

  final Set<String> selectedSubjects = {};

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = selectedSubjects.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // STEP INDICATOR
                    Row(
                      children: [
                        _stepCircle(done: true, text: "✓"),
                        _stepLine(),
                        _stepCircle(done: true, text: "✓"),
                        _stepLine(),
                        _stepCircle(done: false, text: "3"),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      "Step 3 of 3",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Choose Subjects",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Select subjects you want to focus on",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    // ILLUSTRATION
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2E9FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.track_changes,
                          size: 60,
                          color: Color(0xFF4A3AFF),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // SUBJECT GRID
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subjects.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.6,
                      ),
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        final isSelected =
                        selectedSubjects.contains(subject);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedSubjects.remove(subject);
                              } else {
                                selectedSubjects.add(subject);
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE8E6FF)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF4A3AFF)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              subject,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF4A3AFF)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        "${selectedSubjects.length} subjects selected",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 FIXED COMPLETE BUTTON
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isEnabled
                      ? () async {
                    // Save selected subjects
                    await UserDataService.saveUserSubjects(
                        selectedSubjects.toList());
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StudentDashboardScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3AFF),
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding:
                    const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Complete Setup →",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCircle({required bool done, required String text}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: done
            ? const Color(0xFF4A3AFF)
            : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: done ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _stepLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey.shade300,
      ),
    );
  }
}
