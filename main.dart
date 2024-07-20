import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBw0uEJ2VyDEhHDBHU-Zs-ov9jN_4T_V1M",
            authDomain: "human-resource-pulse.firebaseapp.com",
            projectId: "human-resource-pulse",
            storageBucket: "human-resource-pulse.appspot.com",
            messagingSenderId: "68406744591",
            appId: "1:68406744591:android:7d8765f5fb3fdb0f21757a",
            measurementId: "G-DSXV2NSJSW"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: LoginPage(),
    );
  }
}
