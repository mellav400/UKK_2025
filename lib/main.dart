import 'package:flutter/material.dart';
import 'package:ukk_kasir/barang/addbarang.dart';
import 'package:ukk_kasir/barang/editbarang.dart';
import 'package:ukk_kasir/kasir.dart';
import 'package:ukk_kasir/loginpage.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/penjualan/detailpenjualan.dart';
import 'package:ukk_kasir/penjualan/penjualan.dart';
import 'package:ukk_kasir/petugas/kasir.dart';
import 'package:ukk_kasir/user/pelanggan.dart';
import 'supabase.dart';
import 'dart:async';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jvjzuvdaarwkacwqyrii.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2anp1dmRhYXJ3a2Fjd3F5cmlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NDIzNDEsImV4cCI6MjA1NTUxODM0MX0.Kw2LwEpq-zUDJhl0Gdv5kOP7a2rGBlHEOAdGQDgXbDc'
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Sales(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward(); 

  
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginpage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Image.asset('assets/splashscreen.png'), 
        ),
      ),
    );
  }
}   
  
