import 'package:flutter/material.dart';
// import 'package:taproject3/login_page.dart';
import 'package:taproject3/main.dart';
// import 'package:taproject3/main.dart';
import 'grading.dart'; // Import the GradingPage
import 'profile.dart'; // Import the ProfilePage
import 'aboutus.dart'; // Import the AboutUsPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(MaterialApp(home: DashboardPage(), debugShowCheckedModeBanner: false));
// } // COMMAND IF WANNA RUN IT ON PHONE

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<Widget> _pages = [BerandaPage(), GradingPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );
    _controller.forward(); // Start the animation initially
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _controller.reverse().then((_) {
        setState(() {
          _selectedIndex = index;
        });
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.blue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_camera_back_outlined),
                label: 'Grading',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String fullName = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        fullName = doc['full_name'] ?? 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.logout_outlined, color: Colors.white),
          onPressed: () async {
            await FirebaseAuth.instance.signOut(); // Logout session
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),

        title: Text(
          'Welcome $fullName',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  GestureDetector(
                    onTap: () {
                      // Navigate to AboutUsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUsPage()),
                      );
                    },
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main Box that wraps everything
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue, // White background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, // Light shadow
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'HOW TO DISTINGUISH THE QUALITY OF TUNA LOIN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    _buildImageWithDescription(
                      'lib/images/GradeA.jpg',
                      'Grade A',
                      'Bright red or pink loin with a firm, smooth texture.',
                      context,
                    ),
                    _buildImageWithDescription(
                      'lib/images/GradeB.jpg',
                      'Grade B',
                      'slightly softer or have a slightly less vibrant color, such as a deeper red or pink.',
                      context,
                    ),
                    _buildImageWithDescription(
                      'lib/images/gradeC.jpg',
                      'Grade C',
                      'show signs of deterioration, such as discoloration or a faint, unpleasant odor. The flesh may be mushy or have a pale color.',
                      context,
                    ),
                  ],
                ),
              ),
            ),
            // New section for Types of Tuna Loin
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '5 Types of Tuna Loin in Indonesia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    _buildImageWithDescription(
                      'lib/images/bigeyetuna.png',
                      'Big Eye',
                      'large, prominent eyes and streamlined body. It has a deep blue back and silvery sides.',
                      context,
                    ),
                    _buildImageWithDescription(
                      'lib/images/yellowfin_tuna.png',
                      'Yellowfin',
                      'long yellow dorsal and anal fins, with a dark blue back and silvery belly.',
                      context,
                    ),
                    _buildImageWithDescription(
                      'lib/images/albacore tuna.png',
                      'Albacore',
                      'long pectoral fins and smaller body, has a silvery belly and dark blue back.',
                      context,
                    ),
                    _buildImageWithDescription(
                      'lib/images/shipjack tuna.png',
                      'ShipJack',
                      'Dark vertical striped pattern on its body and a streamlined build.',
                      context,
                    ),
                    _buildImageWithDescription(
                      'lib/images/Southern_Bluefin_Tuna.png',
                      'Southern Bluefin',
                      'dark blue or blackish back and silvery belly make it easily identifiable.',
                      context,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build image with description
  Widget _buildImageWithDescription(
    String imagePath,
    String title,
    String description,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showImageDialog(context, imagePath),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Rounded image corners
              child: Image.asset(
                imagePath,
                width: 100, // Adjusted size for better fit
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to show image in dialog
  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(imagePath),
                  SizedBox(height: 8),
                  Text(
                    'Tap outside to close',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
