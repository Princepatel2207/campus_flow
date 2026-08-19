import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/procedure_model.dart';
import '../../providers/procedure_provider.dart';
import '../../routes/app_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProcedureModel> _filterProcedures(
      List<ProcedureModel> procedures,
      ) {
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return procedures;
    }

    return procedures.where((procedure) {
      final title =
      procedure.title.toLowerCase();

      final description =
      procedure.description.toLowerCase();

      final category =
      procedure.categoryName.toLowerCase();

      final office =
      procedure.office.toLowerCase();

      return title.contains(query) ||
          description.contains(query) ||
          category.contains(query) ||
          office.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final procedures =
        context.watch<ProcedureProvider>().procedures;

    final results =
    _filterProcedures(procedures);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Procedures'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,

              decoration: InputDecoration(
                hintText:
                'Search procedures...',
                prefixIcon:
                const Icon(Icons.search),

                suffixIcon:
                _searchText.isNotEmpty
                    ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    _searchController
                        .clear();

                    setState(() {
                      _searchText = '';
                    });
                  },
                )
                    : null,

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _searchText.isEmpty
                    ? '${results.length} procedures available'
                    : '${results.length} result(s) found',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: results.isEmpty
                  ? _EmptySearchResult(
                query: _searchText,
              )
                  : ListView.builder(
                itemCount: results.length,
                itemBuilder:
                    (context, index) {
                  final procedure =
                  results[index];

                  return _ProcedureSearchCard(
                    procedure: procedure,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcedureSearchCard
    extends StatelessWidget {
  final ProcedureModel procedure;

  const _ProcedureSearchCard({
    required this.procedure,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
      const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
        const EdgeInsets.all(14),

        leading: CircleAvatar(
          child: Text(
            procedure.title[0]
                .toUpperCase(),
          ),
        ),

        title: Text(
          procedure.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Padding(
          padding:
          const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                procedure.categoryName,
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                procedure.description,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
              ),

              const SizedBox(height: 5),

              Text(
                'Fee: ₹${procedure.fee.toStringAsFixed(0)}'
                    ' • ${procedure.processingTime}',
              ),
            ],
          ),
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
  }
}

class _EmptySearchResult
    extends StatelessWidget {
  final String query;

  const _EmptySearchResult({
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            query.isEmpty
                ? Icons.description_outlined
                : Icons.search_off,
            size: 70,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          Text(
            query.isEmpty
                ? 'No procedures available'
                : 'No procedures found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (query.isNotEmpty) ...[
            const SizedBox(height: 8),

            Text(
              'Try searching with another keyword.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}