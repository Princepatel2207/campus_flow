import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class AdminDashboard extends StatelessWidget {
const AdminDashboard({super.key});

@override
Widget build(BuildContext context) {
final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
    appBar: AppBar(
    title: const Text('Admin Dashboard'),
    centerTitle: true,
    actions: [
    IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () {
    authProvider.logout();

    Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.login,
    (route) => false,
    );
    },
    ),
    ],
    ),

    body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

    Text(
    'Welcome, ${user?.name ?? 'Admin'} 👋',
    style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    Text(
    'Manage CampusCompass information',
    style: TextStyle(
    color: Colors.grey.shade600,
    fontSize: 15,
    ),
    ),

    const SizedBox(height: 30),

    Row(
    children: [
    Expanded(
    child: _dashboardCard(
    icon: Icons.description_outlined,
    title: 'Procedures',
    value: '0',
    onTap: () {},
    ),
    ),

    const SizedBox(width: 15),

    Expanded(
    child: _dashboardCard(
    icon: Icons.category_outlined,
    title: 'Categories',
    value: '0',
    onTap: () {},
    ),
    ),
    ],
    ),

    const SizedBox(height: 15),

    Row(
    children: [
    Expanded(
    child: _dashboardCard(
    icon: Icons.people_outline,
    title: 'Users',
    value: '0',
    onTap: () {},
    ),
    ),

    const SizedBox(width: 15),

    Expanded(
    child: _dashboardCard(
    icon: Icons.business_outlined,
    title: 'Offices',
    value: '0',
    onTap: () {},
    ),
    ),
    ],
    ),

    const SizedBox(height: 30),

    const Text(
    'Management',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 15),

        _managementButton(
            context,
            icon: Icons.description_outlined,
            title: 'Manage Procedures',
            onTap: () {
                Navigator.pushNamed(
                    context,
                    AppRoutes.procedureManagement,
                );
            },
        ),

        _managementButton(
            context,
            icon: Icons.category_outlined,
            title: 'Manage Categories',
            onTap: () {
                Navigator.pushNamed(
                    context,
                    AppRoutes.categoryManagement,
                );
            },
        ),

    _managementButton(
    context,
    icon: Icons.business_outlined,
    title: 'Manage Offices',
    onTap: () {},
    ),
    ],
    ),
    ),
    );
    }

    Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    }) {
    return Card(
    child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(
    children: [
    Icon(
    icon,
    size: 35,
    color: Colors.indigo,
    ),

    const SizedBox(height: 10),

    Text(
    value,
    style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    ),
    ),

    Text(
    title,
    style: TextStyle(
    color: Colors.grey.shade600,
    ),
    ),
    ],
    ),
    ),
    ),
    );
    }

    Widget _managementButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    }) {
    return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
    leading: CircleAvatar(
    backgroundColor: Colors.indigo.shade50,
    child: Icon(
    icon,
    color: Colors.indigo,
    ),
    ),
    title: Text(
    title,
    style: const TextStyle(
    fontWeight: FontWeight.w600,
    ),
    ),
    trailing: const Icon(
    Icons.arrow_forward_ios,
    size: 16,
    ),
    onTap: onTap,
    ),
    );
    }
    }