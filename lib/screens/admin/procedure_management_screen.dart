import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../models/procedure_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/procedure_provider.dart';

class ProcedureManagementScreen extends StatelessWidget {
  const ProcedureManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final procedures =
        context.watch<ProcedureProvider>().procedures;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Procedures'),
        centerTitle: true,
      ),

      body: procedures.isEmpty
          ? const Center(
        child: Text(
          'No procedures found.\nAdd your first procedure.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: procedures.length,
        itemBuilder: (context, index) {
          final procedure = procedures[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  procedure.title.isNotEmpty
                      ? procedure.title[0].toUpperCase()
                      : '?',
                ),
              ),

              title: Text(
                procedure.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),

                  Text(
                    procedure.categoryName,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Fee: ₹${procedure.fee.toStringAsFixed(0)}'
                        ' • ${procedure.processingTime}',
                  ),
                ],
              ),

              isThreeLine: true,

              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showProcedureDialog(
                      context,
                      procedure: procedure,
                    );
                  }

                  if (value == 'delete') {
                    _deleteProcedure(
                      context,
                      procedure,
                    );
                  }
                },

                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 10),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showProcedureDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Procedure'),
      ),
    );
  }

  void _showProcedureDialog(
      BuildContext context, {
        ProcedureModel? procedure,
      }) {
    final isEditing = procedure != null;

    final titleController = TextEditingController(
      text: procedure?.title ?? '',
    );

    final descriptionController = TextEditingController(
      text: procedure?.description ?? '',
    );

    final processingTimeController = TextEditingController(
      text: procedure?.processingTime ?? '',
    );

    final feeController = TextEditingController(
      text: procedure != null
          ? procedure.fee.toString()
          : '',
    );

    final officeController = TextEditingController(
      text: procedure?.office ?? '',
    );

    final workingHoursController = TextEditingController(
      text: procedure?.workingHours ?? '',
    );

    final documentsController = TextEditingController(
      text: procedure?.requiredDocuments.join('\n') ?? '',
    );

    final stepsController = TextEditingController(
      text: procedure?.steps.join('\n') ?? '',
    );

    final formKey = GlobalKey<FormState>();

    String? selectedCategoryId =
        procedure?.categoryId;

    String? selectedCategoryName =
        procedure?.categoryName;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final categories =
                context.watch<CategoryProvider>().categories;

            return AlertDialog(
              title: Text(
                isEditing
                    ? 'Edit Procedure'
                    : 'Add Procedure',
              ),

              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Procedure Title',
                            hintText:
                            'e.g. Bonafide Certificate',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Enter procedure title';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: selectedCategoryId,
                          decoration:
                          const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: categories
                              .map(
                                (category) =>
                                DropdownMenuItem<String>(
                                  value: category.id,
                                  child: Text(
                                    category.name,
                                  ),
                                ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedCategoryId = value;

                              final selected =
                              categories.firstWhere(
                                    (category) =>
                                category.id == value,
                              );

                              selectedCategoryName =
                                  selected.name;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Select a category';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller:
                          descriptionController,
                          maxLines: 3,
                          decoration:
                          const InputDecoration(
                            labelText: 'Description',
                            hintText:
                            'Describe the procedure',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Enter description';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller:
                          processingTimeController,
                          decoration:
                          const InputDecoration(
                            labelText: 'Processing Time',
                            hintText: 'e.g. 2 Days',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Enter processing time';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: feeController,
                          keyboardType:
                          TextInputType.number,
                          decoration:
                          const InputDecoration(
                            labelText: 'Fee',
                            prefixText: '₹ ',
                            hintText: 'e.g. 20',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Enter fee';
                            }

                            if (double.tryParse(value) ==
                                null) {
                              return 'Enter a valid fee';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: officeController,
                          decoration:
                          const InputDecoration(
                            labelText: 'Office',
                            hintText:
                            'e.g. Student Section',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Enter office';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller:
                          workingHoursController,
                          decoration:
                          const InputDecoration(
                            labelText: 'Working Hours',
                            hintText:
                            'e.g. 10 AM - 4 PM',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Enter working hours';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: documentsController,
                          maxLines: 5,
                          decoration:
                          const InputDecoration(
                            labelText:
                            'Required Documents',
                            hintText:
                            'Enter one document per line',
                            alignLabelWithHint: true,
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: stepsController,
                          maxLines: 6,
                          decoration:
                          const InputDecoration(
                            labelText:
                            'Procedure Steps',
                            hintText:
                            'Enter one step per line',
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!
                        .validate()) {
                      return;
                    }

                    final provider =
                    context.read<ProcedureProvider>();

                    final fee =
                    double.parse(feeController.text);

                    final documents =
                    documentsController.text
                        .split('\n')
                        .map((item) => item.trim())
                        .where(
                          (item) => item.isNotEmpty,
                    )
                        .toList();

                    final steps =
                    stepsController.text
                        .split('\n')
                        .map((item) => item.trim())
                        .where(
                          (item) => item.isNotEmpty,
                    )
                        .toList();

                    if (isEditing) {
                      provider.updateProcedure(
                        id: procedure.id,
                        title:
                        titleController.text.trim(),
                        categoryId:
                        selectedCategoryId!,
                        categoryName:
                        selectedCategoryName!,
                        description:
                        descriptionController.text
                            .trim(),
                        processingTime:
                        processingTimeController
                            .text
                            .trim(),
                        fee: fee,
                        office:
                        officeController.text.trim(),
                        workingHours:
                        workingHoursController.text
                            .trim(),
                        requiredDocuments: documents,
                        steps: steps,
                      );
                    } else {
                      provider.addProcedure(
                        title:
                        titleController.text.trim(),
                        categoryId:
                        selectedCategoryId!,
                        categoryName:
                        selectedCategoryName!,
                        description:
                        descriptionController.text
                            .trim(),
                        processingTime:
                        processingTimeController
                            .text
                            .trim(),
                        fee: fee,
                        office:
                        officeController.text.trim(),
                        workingHours:
                        workingHoursController.text
                            .trim(),
                        requiredDocuments: documents,
                        steps: steps,
                      );
                    }

                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    isEditing ? 'Update' : 'Add',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteProcedure(
      BuildContext context,
      ProcedureModel procedure,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Procedure'),

          content: Text(
            'Are you sure you want to delete '
                '"${procedure.title}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                context
                    .read<ProcedureProvider>()
                    .deleteProcedure(procedure.id);

                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}