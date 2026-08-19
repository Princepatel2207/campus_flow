import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/progress_model.dart';
import '../../models/procedure_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';

class ProcedureTrackerScreen extends StatelessWidget {
  final ProcedureModel procedure;

  const ProcedureTrackerScreen({
    super.key,
    required this.procedure,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider =
    context.watch<AuthProvider>();

    final progressProvider =
    context.watch<ProgressProvider>();

    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    final progress =
    progressProvider.startProcedure(
      userId: user.id,
      procedure: procedure,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedure Tracker'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              procedure.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Track your progress step by step',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            _ProgressCard(
              progress: progress,
            ),

            const SizedBox(height: 30),

            const Text(
              'Procedure Steps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (procedure.steps.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No procedure steps available.',
                  ),
                ),
              )
            else
              ...List.generate(
                procedure.steps.length,
                    (index) {
                  final completed =
                  progress.completedSteps[index];

                  return _TrackerStep(
                    number: index + 1,
                    title: procedure.steps[index],
                    completed: completed,
                    isLast:
                    index ==
                        procedure.steps.length - 1,
                    onChanged: () {
                      progressProvider.toggleStep(
                        userId: user.id,
                        procedureId: procedure.id,
                        stepIndex: index,
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 30),

            if (progress.isCompleted)
              _CompletedCard(),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final ProgressModel progress;

  const _ProgressCard({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${progress.percentage}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ClipRRect(
              borderRadius:
              BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress.progress,
                minHeight: 12,
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${progress.completedCount} '
                    'of ${progress.totalSteps} steps completed',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackerStep extends StatelessWidget {
  final int number;
  final String title;
  final bool completed;
  final bool isLast;
  final VoidCallback onChanged;

  const _TrackerStep({
    required this.number,
    required this.title,
    required this.completed,
    required this.isLast,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: onChanged,
              child: CircleAvatar(
                radius: 19,
                backgroundColor: completed
                    ? Colors.green
                    : Colors.indigo,
                child: completed
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
                    : Text(
                  '$number',
                  style:
                  const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 65,
                color: completed
                    ? Colors.green.shade200
                    : Colors.indigo.shade100,
              ),
          ],
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Card(
            margin:
            const EdgeInsets.only(bottom: 12),
            child: CheckboxListTile(
              value: completed,
              onChanged: (_) {
                onChanged();
              },
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: completed
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              controlAffinity:
              ListTileControlAffinity.trailing,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompletedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.celebration,
              size: 50,
              color: Colors.green,
            ),

            const SizedBox(height: 12),

            const Text(
              'Procedure Completed! 🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'You have completed all the '
                  'steps of this procedure.',
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