import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/procedure_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/procedure_provider.dart';
import '../../routes/app_routes.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final favoriteProvider =
    context.watch<FavoriteProvider>();

    final procedureProvider =
    context.watch<ProcedureProvider>();

    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    final favoriteIds =
    favoriteProvider.getFavoriteIds(user.id);

    final favoriteProcedures =
    procedureProvider.procedures.where(
          (procedure) {
        return favoriteIds.contains(procedure.id);
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),

      body: favoriteProcedures.isEmpty
          ? const _EmptyFavorites()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteProcedures.length,
        itemBuilder: (context, index) {
          final procedure =
          favoriteProcedures[index];

          return _FavoriteCard(
            procedure: procedure,
            userId: user.id,
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final ProcedureModel procedure;
  final String userId;

  const _FavoriteCard({
    required this.procedure,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.all(12),

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

        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 5,
          ),
          child: Text(
            '${procedure.categoryName} • '
                '${procedure.processingTime}',
          ),
        ),

        trailing: IconButton(
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: () {
            context
                .read<FavoriteProvider>()
                .toggleFavorite(
              userId: userId,
              procedureId: procedure.id,
            );
          },
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
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Save procedures here for quick access.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}