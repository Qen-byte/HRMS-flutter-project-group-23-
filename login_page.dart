import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:human_resource_pulse/Admin/admin_dashboard.dart'; // Adjust with your actual import path
import 'package:human_resource_pulse/pages/employee_dashboard_page.dart'; // Adjust with your actual import path

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  logoWidget("assets/images/logo1.png",
                      MediaQuery.of(context).size.height * 0.2),
                  const SizedBox(height: 20),
                  reusableTextField("Enter Email", Icons.email_outlined, false,
                      _emailController),
                  const SizedBox(height: 20),
                  reusableTextField("Enter Password", Icons.lock_outline, true,
                      _passwordController),
                  const SizedBox(height: 20),
                  firebaseUIButton(context, "Log In", _signIn),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Fetch user role from Firestore
        String? userRole = await fetchUserRole(user.uid);

        if (userRole != null && userRole.isNotEmpty) {
          if (userRole == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminDashboardPage()),
            );
          } else if (userRole == "Employee") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmployeeDashboard()),
            );
          } else {
            _showSnackBar('Invalid user role');
          }
        } else {
          _showSnackBar('User role not found');
        }
      } else {
        _showSnackBar('User not found');
      }
    } catch (e) {
      _showSnackBar('Failed to sign in: $e');
      print('Sign in error: $e'); // Log the error for debugging
    }
  }

  Future<String?> fetchUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('employees').doc(uid).get();
      if (userDoc.exists) {
        print(
            'Document data: ${userDoc.data()}'); // Log document data for debugging
        return userDoc['role'];
      } else {
        print('Document does not exist for user with UID: $uid');
        return null; // Role not found
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return null; // Handle error as needed
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Color hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Widget logoWidget(String imagePath, double height) {
    return Image.asset(
      imagePath,
      height: height,
    );
  }

  Widget reusableTextField(String hint, IconData icon, bool isPassword,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget firebaseUIButton(
      BuildContext context, String title, Function() onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
