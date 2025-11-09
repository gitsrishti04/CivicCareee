import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  String name = '';
  String address = '';
  String phone = '';
  int tokens = 0;
  List<dynamic> issues = [];
  List<Map<String, dynamic>> badges = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _fetchProfile();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse('https://your-backend.com/api/profile'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'] ?? '';
          address = data['address'] ?? '';
          phone = data['phone'] ?? '';
          tokens = data['tokens'] ?? 0;
          issues = data['issues'] ?? [];
          badges = List<Map<String, dynamic>>.from(data['badges'] ?? _generateBadges());
          _nameController.text = name;
          _addressController.text = address;
          _phoneController.text = phone;
        });
      } else {
        // Generate sample badges for demo
        setState(() {
          badges = _generateBadges();
        });
      }
    } catch (e) {
      // Generate sample badges for demo
      setState(() {
        badges = _generateBadges();
      });
    }
  }

  List<Map<String, dynamic>> _generateBadges() {
    final issueCount = issues.length;
    List<Map<String, dynamic>> earnedBadges = [];
    
    final allBadges = [
      {
        'name': 'First Reporter',
        'description': 'Reported your first issue',
        'icon': Icons.flag,
        'color': Colors.blue,
        'requirement': 1,
        'earned': issueCount >= 1,
      },
      {
        'name': 'Community Helper',
        'description': 'Reported 5 issues',
        'icon': Icons.volunteer_activism,
        'color': Colors.green,
        'requirement': 5,
        'earned': issueCount >= 5,
      },
      {
        'name': 'Civic Champion',
        'description': 'Reported 10 issues',
        'icon': Icons.emoji_events,
        'color': Colors.orange,
        'requirement': 10,
        'earned': issueCount >= 10,
      },
      {
        'name': 'Guardian',
        'description': 'Reported 25 issues',
        'icon': Icons.shield,
        'color': Colors.purple,
        'requirement': 25,
        'earned': issueCount >= 25,
      },
      {
        'name': 'Legend',
        'description': 'Reported 50+ issues',
        'icon': Icons.military_tech,
        'color': Colors.amber,
        'requirement': 50,
        'earned': issueCount >= 50,
      },
    ];
    
    return allBadges;
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final response = await http.post(
      Uri.parse('https://your-backend.com/api/profile/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        name = _nameController.text;
        address = _addressController.text;
        phone = _phoneController.text;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You are logged out'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildTokenCard() {
    final taxReduction = (tokens * 0.1).toStringAsFixed(2);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[600]!, Colors.purple[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🪙 Your Tokens',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Redeemable',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tokens.toString(),
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 4),
                  child: Text(
                    'tokens',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Reduction Value',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹10 per token',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹$taxReduction',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to redemption page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tax redemption feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple[600],
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Redeem for Tax Benefits',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection() {
    final earnedBadges = badges.where((b) => b['earned'] == true).toList();
    final lockedBadges = badges.where((b) => b['earned'] == false).toList();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '🏆 Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${earnedBadges.length}/${badges.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Earned Badges
          if (earnedBadges.isNotEmpty) ...[
            const Text(
              'Unlocked',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: earnedBadges.map((badge) => _buildBadgeCard(badge, true)).toList(),
            ),
          ],
          
          // Locked Badges
          if (lockedBadges.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Locked',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: lockedBadges.map((badge) => _buildBadgeCard(badge, false)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge, bool earned) {
    return Tooltip(
      message: '${badge['description']}\n${earned ? "✓ Earned" : "🔒 Report ${badge['requirement']} issues"}',
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: earned ? badge['color'].withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: earned ? badge['color'].withOpacity(0.3) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              badge['icon'],
              size: 36,
              color: earned ? badge['color'] : Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              badge['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: earned ? Colors.black87 : Colors.grey[500],
              ),
            ),
            if (!earned) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${badge['requirement']} reports',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing)
                // Edit Form Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            prefixIcon: const Icon(Icons.home_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter address' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone No',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Enter phone number'
                              : null,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _isEditing = false),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Token Card
                _buildTokenCard(),
                
                const SizedBox(height: 24),
                
                // Badges Section
                _buildBadgesSection(),
                
                const SizedBox(height: 24),
                
                // Profile Information Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          name.isEmpty ? 'Not provided' : name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Name',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.home,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          address.isEmpty ? 'Not provided' : address,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Address',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: Colors.purple,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          phone.isEmpty ? 'Not provided' : phone,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Phone No',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Issues Section
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '📋 My Issues',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${issues.length} reported',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (issues.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.report_problem_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No issues reported yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start reporting to earn tokens!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...issues.map(
                          (issue) => Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.report_problem,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  issue['title'] ?? 'Untitled Issue',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    issue['status'] ?? 'Unknown Status',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                trailing: const Text(
                                  '+10 🪙',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              if (issue != issues.last)
                                const Divider(height: 24),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Action Buttons Section
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => setState(() => _isEditing = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Edit your profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _logout,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}