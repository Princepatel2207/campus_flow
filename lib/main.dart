import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/category_provider.dart';
import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';
import 'providers/procedure_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/favorite_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProcedureProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
      ],
      child: const CampusCompassApp(),
    ),
  );
}

class CampusCompassApp extends StatelessWidget {
  const CampusCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusCompass',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),

      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}