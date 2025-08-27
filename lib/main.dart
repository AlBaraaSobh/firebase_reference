import 'package:elancer_firebase/firebase/fb_notifications.dart';
import 'package:elancer_firebase/screens/app/home_screen.dart';
import 'package:elancer_firebase/screens/app/note_screen.dart';
import 'package:elancer_firebase/screens/app/notification_screen.dart';
import 'package:elancer_firebase/screens/auth/login_screen.dart';
import 'package:elancer_firebase/screens/auth/register_screen.dart';
import 'package:elancer_firebase/screens/core/launch_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تشغيل Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // تشغيل الإشعارات
  await FbNotifications.initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
           iconTheme: IconThemeData(
             color: Colors.black
           ),
           titleTextStyle: GoogleFonts.poppins(
             fontWeight: FontWeight.bold,
             fontSize: 18,
             color: Colors.black
           ),
        ),
      ),
      initialRoute: '/launch_screen',
      routes: {
        '/launch_screen' : (context) => LaunchScreen(),
        '/login_screen' : (context) => LoginScreen(),
        '/register_screen' : (context) => RegisterScreen(),
        '/home_screen' : (context) => HomeScreen(),
        '/note_screen' : (context) => NoteScreen(),
        '/notification_screen' : (context) => NotificationScreen(),

      },
    );
  }
}
