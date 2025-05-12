import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sales/firebase_options.dart';
import 'package:sales/screens/dashboard_screen.dart';
import 'package:sales/services/connectivity_service.dart';

final ConnectivityService connectivityService = ConnectivityService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home:  const DashboardScreen(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}