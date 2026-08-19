import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../models/procedure_model.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';

class ProcedureDetailsScreen extends StatelessWidget {
  final ProcedureModel procedure;

  const ProcedureDetailsScreen({
    super.key,
    required this.procedure,
  });

  @override
  Widget build(BuildContext context) {
    final user =
        context.watch<AuthProvider>().currentUser;

    final isFavorite = user != null &&
        context.watch<FavoriteProvider>().isFavorite(
          userId: user.id,
          procedureId: procedure.id,
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedure Details'),

        actions: [
          if (user != null)
            IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFavorite
                    ? Colors.red
                    : null,
              ),

              onPressed: () {
                context
                    .read<FavoriteProvider>()
                    .toggleFavorite(
                  userId: user.id,
                  procedureId: procedure.id,
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
            // Title
            Text(
              procedure.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Category
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Text(
                procedure.categoryName,
                style: const TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              procedure.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            // Information
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.timer_outlined,
                    title: 'Processing',
                    value:
                    procedure.processingTime,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _InfoCard(
                    icon: Icons.currency_rupee,
                    title: 'Fee',
                    value:
                    '₹${procedure.fee.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.location_on_outlined,
              title: 'Office',
              value: procedure.office,
            ),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.access_time_outlined,
              title: 'Working Hours',
              value: procedure.workingHours,
            ),

            const SizedBox(height: 30),

            // Required documents
            const Text(
              'Required Documents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (procedure.requiredDocuments.isEmpty)
              const Text(
                'No documents specified.',
              )
            else
              ...procedure.requiredDocuments.map(
                    (document) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 22,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            document,
                            style:
                            const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 30),

            // Steps
            const Text(
              'Procedure Steps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (procedure.steps.isEmpty)
              const Text(
                'No steps specified.',
              )
            else
              ...List.generate(
                procedure.steps.length,
                    (index) {
                  return _StepItem(
                    number: index + 1,
                    title: procedure.steps[index],
                    isLast:
                    index ==
                        procedure.steps.length - 1,
                  );
                },
              ),

            const SizedBox(height: 30),

            // Start button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tracker,
                    arguments: procedure,
                  );
                },
                icon: const Icon(
                  Icons.play_arrow,
                ),
                label: const Text(
                  'Start Procedure',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.indigo,
              size: 28,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String title;
  final bool isLast;

  const _StepItem({
    required this.number,
    required this.title,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: Colors.indigo,
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 45,
                color: Colors.indigo.shade100,
              ),
          ],
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.only(top: 7),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}