import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Supabase{
  static const String supabaseUrl = 'https://dowfyjfobosndxxhpmum.supabase.co';
  static const String supabaseKey= 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRvd2Z5amZvYm9zbmR4eGhwbXVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg3NzAsImV4cCI6MjA1NDk4NDc3MH0.jD7-LcQkJAeEsL2eznelX0iwpvGxyXWvDKMtqvV8idk';

  static var instance;

  static Future<void> initialize({ required String url, required String anonKey}) async{
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey
    );
  }
}