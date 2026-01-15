import 'package:flutter/material.dart';
import 'onboarding_academic_screen.dart';

class OnboardingNameScreen extends StatefulWidget {
  const OnboardingNameScreen({super.key});

  @override
  State<OnboardingNameScreen> createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = _nameController.text.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // STEP INDICATOR
              Row(
                children: [
                  _stepCircle(active: true, text: "1"),
                  _stepLine(),
                  _stepCircle(active: false, text: "2"),
                  _stepLine(),
                  _stepCircle(active: false, text: "3"),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                "Step 1 of 3",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // TITLE
              const Text(
                "What’s your name?",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),
              const Text(
                "Let’s personalize your experience",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // ILLUSTRATION
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9ECFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "👋",
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // NAME INPUT
              TextField(
                controller: _nameController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF4A3AFF),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // CONTINUE BUTTON → STEP 2
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isEnabled
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const OnboardingAcademicScreen(),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3AFF),
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
            ],
          ),
        ),
      ),
    );
  }

  // STEP CIRCLE
  Widget _stepCircle({required bool active, required String text}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF4A3AFF) : Colors.grey.shade300,
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

  // STEP LINE
  Widget _stepLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey.shade300,
      ),
    );
  }
}
