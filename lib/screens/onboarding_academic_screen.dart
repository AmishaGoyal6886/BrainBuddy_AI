import 'package:flutter/material.dart';
import 'onboarding_subjects_screen.dart';
import '../services/user_data_service.dart';

class OnboardingAcademicScreen extends StatefulWidget {
  const OnboardingAcademicScreen({super.key});

  @override
  State<OnboardingAcademicScreen> createState() =>
      _OnboardingAcademicScreenState();
}

class _OnboardingAcademicScreenState
    extends State<OnboardingAcademicScreen> {
  int? selectedClass;
  String? selectedBoard;

  final List<int> classes = [8, 9, 10, 11, 12];
  final List<String> boards = ["CBSE", "ICSE", "State Board"];

  @override
  Widget build(BuildContext context) {
    final bool isEnabled =
        selectedClass != null && selectedBoard != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 SCROLLABLE CONTENT (FINAL FIXED VERSION)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              24, 24, 24, 140),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),

                              // STEP INDICATOR
                              Row(
                                children: [
                                  _stepCircle(
                                      active: false, text: "✓"),
                                  _stepLine(),
                                  _stepCircle(
                                      active: true, text: "2"),
                                  _stepLine(),
                                  _stepCircle(
                                      active: false, text: "3"),
                                ],
                              ),

                              const SizedBox(height: 16),
                              const Text(
                                "Step 2 of 3",
                                style: TextStyle(
                                    color: Colors.black54),
                              ),

                              const SizedBox(height: 30),

                              const Text(
                                "Academic Details",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Tell us about your class and board",
                                style: TextStyle(
                                    color: Colors.black54),
                              ),

                              const SizedBox(height: 30),

                              // ILLUSTRATION
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xFFDFF3FF),
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    size: 60,
                                    color:
                                    Color(0xFF4A3AFF),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // SELECT CLASS
                              const Text(
                                "Select your class",
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.w600),
                              ),
                              const SizedBox(height: 12),

                              Wrap(
                                spacing: 12,
                                children: classes.map((c) {
                                  final isSelected =
                                      selectedClass == c;
                                  return ChoiceChip(
                                    label:
                                    Text(c.toString()),
                                    selected: isSelected,
                                    selectedColor:
                                    const Color(
                                        0xFF4A3AFF),
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onSelected: (_) {
                                      setState(() {
                                        selectedClass = c;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 28),

                              // SELECT BOARD
                              const Text(
                                "Select your board",
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.w600),
                              ),
                              const SizedBox(height: 12),

                              ...boards.map((board) {
                                final isSelected =
                                    selectedBoard == board;
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedBoard =
                                            board;
                                      });
                                    },
                                    child: Container(
                                      width:
                                      double.infinity,
                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                          vertical: 14,
                                          horizontal:
                                          16),
                                      decoration:
                                      BoxDecoration(
                                        color: isSelected
                                            ? const Color(
                                            0xFFE8E6FF)
                                            : Colors.grey
                                            .shade100,
                                        borderRadius:
                                        BorderRadius
                                            .circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(
                                              0xFF4A3AFF)
                                              : Colors
                                              .transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        board,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          color: isSelected
                                              ? const Color(
                                              0xFF4A3AFF)
                                              : Colors
                                              .black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),

                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🔹 CONTINUE BUTTON → STEP 3
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isEnabled
                      ? () async {
                    // Save academic info
                    await UserDataService.saveUserClass(selectedClass!);
                    await UserDataService.saveUserBoard(selectedBoard!);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const OnboardingSubjectsScreen(),
                        ),
                      );
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF4A3AFF),
                    disabledBackgroundColor:
                    Colors.grey.shade300,
                    padding:
                    const EdgeInsets.symmetric(
                        vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Continue →",
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

  Widget _stepCircle({required bool active, required String text}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF4A3AFF)
            : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black54,
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
