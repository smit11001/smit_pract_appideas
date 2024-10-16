import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smit_pract_appideas/room_booking_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Room Booking',
    options: FirebaseOptions(
      messagingSenderId: '348745520427',
      projectId: 'room-booking-app-437ef',
      apiKey: 'AIzaSyCmgjUAqXjXcP35t3vwmLrMDBLmyuVMt3k',
      appId: '1:348745520427:android:b897891a9b34d4482d616e',
    )
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoomBookingScreen(),
    );
  }
}
