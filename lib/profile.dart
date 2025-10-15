import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  String _email = "";
  bool _isLoading = false;
  String _originalName = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Add listener to update UI when the text changes.
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? "No email available";
      });

      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();

      if (userData.exists) {
        setState(() {
          _nameController.text = userData['full_name'] ?? "";
          _originalName = _nameController.text;
        });
      } else {
        // If there isn't any user data, set the email and an empty full name.
        await _firestore.collection('users').doc(user.uid).set({
          'full_name': "",
          'email': _email,
        });
        setState(() {
          _nameController.text = "";
          _originalName = "";
        });
      }
    }
  }

  Future<void> _saveUserData() async {
    setState(() => _isLoading = true);
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'full_name': _nameController.text,
        });
        // After saving, update the original name to the new value.
        setState(() {
          _originalName = _nameController.text;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.blue,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ), // kept spacing to avoid layout shift
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: TextEditingController(text: _email),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity:
                        _nameController.text.trim() != _originalName.trim()
                            ? 1.0
                            : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (_nameController.text.trim() !=
                                        _originalName.trim() &&
                                    !_isLoading)
                                ? _saveUserData
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Save Profile",
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
