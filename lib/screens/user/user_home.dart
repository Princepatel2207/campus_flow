import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/procedure_provider.dart';
import '../../routes/app_routes.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final procedureProvider = context.watch<ProcedureProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = context.watch<CategoryProvider>().categories;

    final user = authProvider.currentUser;
    final procedures = procedureProvider.procedures;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusCompass'),
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
            // Greeting
            Text(
              'Good Morning, ${user?.name ?? 'Student'} 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'What do you need help with?',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            // Search box
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.search,
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search procedures...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.arrow_forward),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Favorites
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
                title: const Text(
                  'My Favorites',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'View your saved procedures',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.favorites,
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Popular Procedures
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Procedures',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (procedures.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.search,
                      );
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            if (procedures.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No procedures available yet.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              )
            else
              ...procedures.take(5).map(
                    (procedure) {
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          procedure.title[0].toUpperCase(),
                        ),
                      ),
                      title: Text(
                        procedure.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${procedure.categoryName} • '
                            '${procedure.processingTime}',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.procedureDetails,
                          arguments: procedure,
                        );
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 25),

            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (categories.isNotEmpty)
                  Text(
                    '${categories.length}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 15),

            // Dynamic categories
            if (categories.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No categories available yet.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return _CategoryCard(
                    title: category.name,
                    description: category.description,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;

  const _CategoryCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.category_outlined,
              size: 32,
              color: Colors.indigo,
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}