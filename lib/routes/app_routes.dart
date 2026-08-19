import 'package:flutter/material.dart';
import '../screens/admin/category_management_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/user/user_home.dart';
import '../screens/admin/procedure_management_screen.dart';
import '../screens/user/procedure_details_screen.dart';
import '../models/procedure_model.dart';
import '../screens/user/procedure_tracker_screen.dart';
import '../screens/user/search_screen.dart';
import '../screens/user/favorites_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String adminDashboard = '/admin';
  static const String userHome = '/user';
  static const String categoryManagement = '/admin/categories';
  static const String procedureManagement = '/admin/procedures';
  static const String procedureDetails = '/user/procedure-details';
  // static const String search = '/search';
  static const String tracker = '/user/tracker';
  static const String search = '/user/search';
  static const String favorites = '/user/favorites';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),

    adminDashboard: (context) => const AdminDashboard(),

    userHome: (context) => const UserHome(),

    categoryManagement: (context) =>
    const CategoryManagementScreen(),

    procedureManagement: (context) =>
    const ProcedureManagementScreen(),

    search: (context) =>
    const SearchScreen(),

    favorites: (context) =>
    const FavoritesScreen(),

    tracker: (context) {
      final procedure =
      ModalRoute.of(context)!
          .settings
          .arguments as ProcedureModel;

      return ProcedureTrackerScreen(
        procedure: procedure,
      );
    },

    procedureDetails: (context) {
      final procedure =
      ModalRoute.of(context)!.settings.arguments
      as ProcedureModel;

      return ProcedureDetailsScreen(
        procedure: procedure,
      );
    },
  };
}