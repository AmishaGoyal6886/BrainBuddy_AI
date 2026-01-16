import 'package:flutter/material.dart';
import '../services/user_data_service.dart';
import 'onboarding_name_screen.dart';
import 'student_dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  List<String> subjects = [];
  int? userClass;
  String? userBoard;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await UserDataService.getUserName();
    final userSubjects = await UserDataService.getUserSubjects();
    final classNum = await UserDataService.getUserClass();
    final board = await UserDataService.getUserBoard();
    setState(() {
      userName = name ?? 'Student';
      subjects = userSubjects;
      userClass = classNum;
      userBoard = board;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Get first letter of name for profile icon
    final profileInitial = (userName != null && userName!.isNotEmpty) 
        ? userName![0].toLowerCase() 
        : 'u';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Purple Gradient Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6A5AE0),
                      Color(0xFF8E7BFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Info
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName ?? 'Student',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userClass != null && userBoard != null
                                    ? "Class $userClass • $userBoard"
                                    : "Student",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            Icons.bolt,
                            "0",
                            "Total XP",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            Icons.local_fire_department,
                            "0",
                            "Day Streak",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            Icons.shield,
                            "L1",
                            "1 Level",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // My Subjects Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Subjects",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (subjects.isNotEmpty)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: subjects.asMap().entries.map((entry) {
                          final index = entry.key;
                          final subject = entry.value;
                          final isSelected = index == 0; // First subject is highlighted
                          return _subjectPill(subject, isSelected);
                        }).toList(),
                      )
                    else
                      const Text(
                        "No subjects selected",
                        style: TextStyle(color: Colors.black54),
                      ),

                    const SizedBox(height: 24),

                    // Achievements Section
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: const Color(0xFF6A5AE0),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Achievements",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _achievementCard(
                            "Week Warrior",
                            Icons.local_fire_department,
                            const Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _achievementCard(
                            "Perfect Score",
                            Icons.shield,
                            const Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _achievementCard(
                            "Fast Learner",
                            Icons.bolt,
                            Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Streak History / Menu Section
                    const Text(
                      "Streak History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _menuItem(
                            Icons.settings,
                            "Account Settings",
                            () {},
                          ),
                          _divider(),
                          _menuItem(
                            Icons.notifications,
                            "Notifications",
                            () {},
                            badge: "3",
                          ),
                          _divider(),
                          _menuItem(
                            Icons.lock,
                            "Privacy & Security",
                            () {},
                          ),
                          _divider(),
                          _menuItem(
                            Icons.help_outline,
                            "Help & Support",
                            () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6A5AE0),
        unselectedItemColor: Colors.grey,
        currentIndex: 4, // Profile is index 4
        onTap: (index) {
          if (index == 0) {
            // Home tab - navigate back to dashboard
            Navigator.pop(context);
          }
          // Profile tab (index 4) is already active, no action needed
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
            icon: Icon(Icons.emoji_events),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6A5AE0), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _subjectPill(String subject, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6A5AE0) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? const Color(0xFF6A5AE0) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Text(
        subject,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _achievementCard(String title, IconData icon, Color color) {
    final isGrey = color == Colors.grey.shade300;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: isGrey ? Colors.grey.shade700 : Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isGrey ? Colors.grey.shade700 : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap, {String? badge}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6A5AE0), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 60,
      color: Colors.grey.shade200,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Clear user data and navigate to onboarding
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const OnboardingNameScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
