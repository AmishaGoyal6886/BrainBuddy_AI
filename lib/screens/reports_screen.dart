import 'package:flutter/material.dart';
import '../services/user_data_service.dart';
import 'profile_screen.dart';
import 'student_dashboard_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  String? userName;
  bool isLoading = true;
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final name = await UserDataService.getUserName();
    setState(() {
      userName = name ?? 'Student';
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
        : 'a';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back, Title, Bell, and Profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Title
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Reports",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Bell icon
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.black),
                    onPressed: () {},
                  ),
                  // Profile icon
                  Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A5AE0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        profileInitial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF6A5AE0),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: "Overview"),
                  Tab(text: "Progress"),
                  Tab(text: "Streaks"),
                  Tab(text: "Time Spent"),
                ],
              ),
            ),

            // Content based on selected tab
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildProgressTab(),
                  _buildStreaksTab(),
                  _buildTimeSpentTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6A5AE0),
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Reports is index 3
        onTap: (index) {
          if (index == 0) {
            // Home tab
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentDashboardScreen()),
            );
          } else if (index == 4) {
            // Profile tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
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
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Learning Summary Section
          const Text(
            "Learning Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Weekly Stats",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.star,
                  iconColor: Colors.amber,
                  value: "+100 XP",
                  change: "+25%",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.trending_up,
                  iconColor: const Color(0xFF6A5AE0),
                  value: "2 +1",
                  change: "+100%",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                  value: "3d",
                  change: "+50%",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.access_time,
                  iconColor: Colors.green,
                  value: "4h 30m",
                  change: "+80%",
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Achievements Section
          const Text(
            "Achievements",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildAchievementCard(index);
              },
            ),
          ),
          const SizedBox(height: 12),
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: index == 0 ? const Color(0xFF6A5AE0) : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          // Learning Activity Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Learning Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Weekly",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Total: 4h 30m",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Bar Chart
          _buildBarChart(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String change,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.green, size: 16),
              Text(
                change,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(int index) {
    final achievements = [
      {
        'title': "Week's Top Learner",
        'description': "You earned the most XP this week!",
        'xp': "100 XP",
        'icon': Icons.emoji_events,
        'color': Colors.amber,
      },
      {
        'title': "Perfect Streak",
        'description': "You've maintained a 7-day streak!",
        'xp': "75 XP",
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
      },
      {
        'title': "Speed Demon",
        'description': "Completed 10 lessons in one day!",
        'xp': "50 XP",
        'icon': Icons.speed,
        'color': Colors.blue,
      },
    ];

    final achievement = achievements[index];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            achievement['color'] as Color,
            (achievement['color'] as Color).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            achievement['icon'] as IconData,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement['description'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              achievement['xp'] as String,
              style: const TextStyle(
                color: Color(0xFF6A5AE0),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final values = [13, 28, 23, 18, 14, 10, 9]; // minutes per day
    final maxValue = 30;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final colors = [
      const Color(0xFF6A5AE0),
      const Color(0xFF6A5AE0).withOpacity(0.9),
      const Color(0xFF6A5AE0).withOpacity(0.8),
      const Color(0xFF6A5AE0).withOpacity(0.7),
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.green.shade600,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Chart with Y-axis labels and bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis labels
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("30", style: TextStyle(fontSize: 11, color: Colors.black54)),
                  SizedBox(height: 25),
                  Text("20", style: TextStyle(fontSize: 11, color: Colors.black54)),
                  SizedBox(height: 25),
                  Text("10", style: TextStyle(fontSize: 11, color: Colors.black54)),
                  SizedBox(height: 25),
                  Text("0", style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
              const SizedBox(width: 8),
              // Bars
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final height = (values[index] / maxValue) * 120;
                      return Container(
                        width: 28,
                        height: height,
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              return SizedBox(
                width: 28,
                child: Text(
                  days[index],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A5AE0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "Time Learned (min)",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return const Center(
      child: Text(
        "Progress Tab",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStreaksTab() {
    return const Center(
      child: Text(
        "Streaks Tab",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTimeSpentTab() {
    return const Center(
      child: Text(
        "Time Spent Tab",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
