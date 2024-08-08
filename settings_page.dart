import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:human_resource_pulse/pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAccountSection(),
            SizedBox(height: 20),
            _buildAppSettingsSection(),
            SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.account_circle, color: Colors.blueAccent),
        title: Text('Account'),
        subtitle: Text('Manage your account settings'),
        onTap: () {
          // Handle account management navigation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountSettingsPage()),
          );
        },
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.settings, color: Colors.blueAccent),
        title: Text('App Settings'),
        subtitle: Text('Customize app preferences'),
        onTap: () {
          // Handle app settings navigation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppSettingsPage()),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.redAccent),
        title: Text('Logout'),
        subtitle: Text('Sign out of your account'),
        onTap: () async {
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }
}

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Add widgets for account settings here
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: () {
                // Handle edit profile navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Change Password'),
              onTap: () {
                // Handle change password navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Add widgets for app settings here
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              onTap: () {
                // Handle language settings navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Handle notifications settings navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}
