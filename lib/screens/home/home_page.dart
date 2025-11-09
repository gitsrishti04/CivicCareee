import 'package:civic_care/screens/complaint/nearby_complaints.dart';
import 'package:civic_care/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:civic_care/screens/complaint/complaint_register.dart';
import 'package:civic_care/screens/complaint/track_complaint.dart';
import 'package:civic_care/screens/complaint/complaint_history.dart';
import 'package:civic_care/screens/community/community_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui'; // Needed for BackdropFilter

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _locationText = "Fetching location...";

  // --- UI Color Palette ---
  static const Color _primaryColor = Color(0xFF0D47A1); // Deep Blue
  static const Color _lightPrimaryColor = Color(0xFF1976D2); // Lighter Blue
  static const Color _accentColor = Color(0xFF448AFF); // Accent Blue
  static const Color _scaffoldBgColor = Color(
    0xFFF4F6F8,
  ); // Light grey background
  static const Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted)
          setState(() => _locationText = "Location services disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted)
          setState(() => _locationText = "Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;
        setState(() {
          _locationText =
              "${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
        });
      } else if (mounted) {
        setState(() => _locationText = "Location not found");
      }
    } catch (e) {
      if (mounted) setState(() => _locationText = "Error fetching location");
    }
  }

  void _onItemTapped(int index) {
    // Prevent rebuilding the page if the same item is tapped
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    // Use a small delay to allow the bottom bar animation to feel smoother
    // before navigating.
    Future.delayed(const Duration(milliseconds: 150), () {
      switch (index) {
        case 0: // Home - Do nothing as we are on the home page
          break;
        case 1: // Nearby Complaints
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NearbyComplaintsPage(),
            ),
          );
          // Reset index after navigation to keep Home selected on return
          setState(() => _selectedIndex = 0);
          break;
        case 2: // Communities
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CommunityPage()),
          );
          setState(() => _selectedIndex = 0);
          break;
        case 3: // Profile
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
          setState(() => _selectedIndex = 0);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        title: const Text(
          "Civic Care",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 26,
          ),
          onPressed: () {
            // TODO: Implement notifications logic
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 26),
            onPressed: () {
              // TODO: Implement help/support logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            _buildHeader(),

            // --- Banner ---
            _buildBanner(),

            // --- Action Grid ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            _buildActionGrid(),

            const SizedBox(height: 80), // Extra space to prevent FAB overlap
          ],
        ),
      ),

      // --- Floating Action Button & Bottom Nav Bar ---
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  /// Builds the header section with a gradient, welcome text, and location.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: const BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _locationText,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // --- Search Bar ---
          TextField(
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: "Search services, departments...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the promotional banner.
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage("assets/banner.png"), // Ensure this asset exists
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }

  /// Builds the grid of action blocks.
  Widget _buildActionGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.25,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildBlock(
            icon: Icons.add_circle_outline,
            title: "Register Complaint",
            gradientColors: [const Color(0xFF5C6BC0), const Color(0xFF3F51B5)],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterComplaintScreen(),
              ),
            ),
          ),
          _buildBlock(
            icon: Icons.track_changes,
            title: "Track Complaint",
            gradientColors: [const Color(0xFF26A69A), const Color(0xFF00897B)],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TrackComplaintPage(),
              ),
            ),
          ),
          _buildBlock(
            icon: Icons.history_edu,
            title: "Complaint History",
            gradientColors: [const Color(0xFF7E57C2), const Color(0xFF5E35B1)],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyComplaintHistoryPage(),
              ),
            ),
          ),
          _buildBlock(
            icon: Icons.health_and_safety_outlined,
            title: "Emergency Contacts",
            gradientColors: [const Color(0xFFEF5350), const Color(0xFFE53935)],
            onTap: () {
              // TODO: Implement emergency contacts page navigation
            },
          ),
        ],
      ),
    );
  }

  /// A stylized block widget for the action grid.
  Widget _buildBlock({
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the central Floating Action Button.
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [_accentColor, _primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 0, // Handled by the container's shadow
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterComplaintScreen(),
          ),
        ),
        backgroundColor: Colors.transparent,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  /// Builds the custom Bottom App Bar with a notch.
  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: _cardColor,
      elevation: 10,
      child: SizedBox(
        height: 70, // ⬅️ slightly taller to prevent overflow
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.map_outlined, "Nearby", 1),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(Icons.group_work_outlined, "Communities", 2),
            _buildNavItem(Icons.person_outline, "Profile", 3),
          ],
        ),
      ),
    );
  }

  /// A stylized navigation item for the Bottom App Bar.
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ), // ⬅️ reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min, // ⬅️ prevents overflow
          children: [
            Icon(
              icon,
              color: isSelected ? _primaryColor : Colors.grey.shade600,
              size: isSelected ? 28 : 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _primaryColor : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
