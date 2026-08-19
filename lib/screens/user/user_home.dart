import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/procedure_provider.dart';
import '../../routes/app_routes.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final procedureProvider =
    context.watch<ProcedureProvider>();

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
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
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
                    prefixIcon:
                    const Icon(Icons.search),
                    suffixIcon:
                    const Icon(Icons.arrow_forward),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

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

            // Procedures
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
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
                    margin:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          procedure.title[0]
                              .toUpperCase(),
                        ),
                      ),

                      title: Text(
                        procedure.title,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
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
                          AppRoutes
                              .procedureDetails,
                          arguments: procedure,
                        );
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 25),

            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,

              children: const [
                _CategoryCard(
                  icon: Icons.school_outlined,
                  title: 'Academic',
                ),
                _CategoryCard(
                  icon: Icons.assignment_outlined,
                  title: 'Examination',
                ),
                _CategoryCard(
                  icon: Icons
                      .account_balance_wallet_outlined,
                  title: 'Finance',
                ),
                _CategoryCard(
                  icon: Icons.home_outlined,
                  title: 'Hostel',
                ),
                _CategoryCard(
                  icon: Icons.menu_book_outlined,
                  title: 'Library',
                ),
                _CategoryCard(
                  icon: Icons.badge_outlined,
                  title: 'Certificates',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: Colors.indigo,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}