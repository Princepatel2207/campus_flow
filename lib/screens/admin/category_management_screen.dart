import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../providers/category_provider.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories =
        context.watch<CategoryProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        centerTitle: true,
      ),

      body: categories.isEmpty
          ? const Center(
        child: Text(
          'No categories found.\nAdd your first category.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  category.name.isNotEmpty
                      ? category.name[0].toUpperCase()
                      : '?',
                ),
              ),

              title: Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                category.description.isEmpty
                    ? 'No description'
                    : category.description,
              ),

              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showCategoryDialog(
                      context,
                      category: category,
                    );
                  }

                  if (value == 'delete') {
                    _deleteCategory(
                      context,
                      category,
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
          _showCategoryDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
      ),
    );
  }

  void _showCategoryDialog(
      BuildContext context, {
        CategoryModel? category,
      }) {
    final isEditing = category != null;

    final nameController = TextEditingController(
      text: category?.name ?? '',
    );

    final descriptionController = TextEditingController(
      text: category?.description ?? '',
    );

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isEditing
                ? 'Edit Category'
                : 'Add Category',
          ),

          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'e.g. Academic',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Enter category name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText:
                    'Describe this category',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
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
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final provider =
                context.read<CategoryProvider>();

                if (isEditing) {
                  provider.updateCategory(
                    id: category.id,
                    name: nameController.text.trim(),
                    description:
                    descriptionController.text.trim(),
                  );
                } else {
                  provider.addCategory(
                    name: nameController.text.trim(),
                    description:
                    descriptionController.text.trim(),
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
  }

  void _deleteCategory(
      BuildContext context,
      CategoryModel category,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),

          content: Text(
            'Are you sure you want to delete '
                '"${category.name}"?',
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
                    .read<CategoryProvider>()
                    .deleteCategory(category.id);

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