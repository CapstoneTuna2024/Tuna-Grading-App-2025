import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'About Us',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: AboutUsPage(),
    );
  }
}

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  bool isDescriptionSelected = true;
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _subtitleController;

  late Animation<Offset> _logoAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _subtitleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _logoAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeIn));

    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeIn),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _logoController.forward();
    await _titleController.forward();
    await _subtitleController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopSection(context),
            SizedBox(height: 20),
            _buildTabs(),
            SizedBox(height: 20),
            isDescriptionSelected ? _buildContent() : _buildDeveloperContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/bgaboutus.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SlideTransition(
                position: _logoAnimation,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'lib/images/aruna logo.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: _titleFadeAnimation,
                      child: Text(
                        'Sejarah Aruna',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _subtitleFadeAnimation,
                      child: Text(
                        'Aruna / Indonesia',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 16),
          _buildCard(
            "R Narendra Maharddhika Agastya M.",
            Text("Ai Specialist"),
          ),
          SizedBox(height: 16),
          _buildCard(
            "Azka Abdul Rachman Rizki.",
            Text("UI Designer & Frontend Developer"),
          ),
          SizedBox(height: 16),
          _buildCard(
            "Mochamad Reyhand Landenzy Zulfikar",
            Text("Backend Developer"),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton('Description', isDescriptionSelected),
        _tabButton('Developer', !isDescriptionSelected),
      ],
    );
  }

  Widget _tabButton(String text, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.blueAccent,
          backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          setState(() {
            isDescriptionSelected = (text == 'Description');
          });
        },
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCard('History', _buildTimeline())],
      ),
    );
  }

  Widget _buildTimeline() {
    final List<Map<String, String>> timelineData = [
      {
        'year': '2016',
        'event':
            'Aruna didirikan untuk menghubungkan nelayan lokal ke pasar luas dengan teknologi.',
      },
      {
        'year': '2017',
        'event':
            'Aruna mendirikan hub pertama di Balikpapan dan mulai ekspor internasional.',
      },
      {
        'year': '2018',
        'event':
            'Ekspansi ke pulau-pulau besar, meningkatkan pendapatan nelayan hingga 12x lipat.',
      },
      {
        'year': '2019',
        'event':
            'Terdaftar 5.301 nelayan, ekspor ke 8 negara, memenangkan Social Impact Startup ASEAN.',
      },
      {
        'year': '2020',
        'event':
            'Pendapatan naik 86x meski pandemi, pendanaan USD 5,5 juta, peluncuran Seafood by Aruna.',
      },
      {
        'year': '2021',
        'event':
            'Memberdayakan 26.000+ nelayan di 27 provinsi dengan omzet tinggi.',
      },
      {
        'year': '2022',
        'event':
            'Jaringan lebih dari 40.000 nelayan di 177 titik seluruh Indonesia.',
      },
    ];

    return Column(
      children:
          timelineData.map((data) {
            return ListTile(
              leading: Icon(Icons.donut_large_sharp, color: Colors.blueAccent),
              title: Text(
                data['year']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data['event']!),
            );
          }).toList(),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
