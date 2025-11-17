import 'package:eboutic/pages/admin/catalogue_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart'; // généré automatiquement par flutterfire configure
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation Firebase
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialisation Supabase
  await Supabase.initialize(
    url: 'https://sbxlsharcuzozrnfmewy.supabase.co',   // ⚠️ à remplacer par ton URL Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNieGxzaGFyY3V6b3pybmZtZXd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyNDQ0MDMsImV4cCI6MjA3ODgyMDQwM30.7XLLYrWEX0ZTM9c6b3i0SH-QfAJnXkGaLfJGKZY5YXs',                 // ⚠️ à remplacer par ta clé publique Supabase
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace Équitable',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CataloguePage(), // page d’accueil
    );
  }
}
