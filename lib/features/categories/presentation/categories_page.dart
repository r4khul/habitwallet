import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/category_entity.dart';
import '../data/category_repository_provider.dart';
import 'providers/category_providers.dart';
import 'widgets/category_assets.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: categoriesAsync.when(
        data: (categories) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryTile(category: category);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, ref),
        tooltip: 'Add Category',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showAddEditDialog(
    BuildContext context,
    WidgetRef ref, [
    CategoryEntity? category,
  ]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryForm(category: category),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconData =
        CategoryAssets.icons[category.icon] ?? Icons.category_rounded;
    final color = Color(category.color);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (category.editedLocally) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'EDITED',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            visualDensity: VisualDensity.compact,
            tooltip: 'Edit Category',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _CategoryForm(category: category),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: AppColors.error,
            ),
            visualDensity: VisualDensity.compact,
            tooltip: 'Delete Category',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final isUsed = await ref
        .read(categoryRepositoryProvider)
        .isCategoryUsed(category.id);

    if (!isUsed) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Category?'),
          content: const Text('This will permanently remove the category.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await ref
            .read(categoryControllerProvider.notifier)
            .deleteCategory(category.id);
      }
      return;
    }

    // Category is in use, show the options bottom sheet
    if (context.mounted) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _CategoryUsageActionSheet(category: category),
      );
    }
  }
}

class _CategoryUsageActionSheet extends ConsumerStatefulWidget {
  const _CategoryUsageActionSheet({required this.category});

  final CategoryEntity category;

  @override
  ConsumerState<_CategoryUsageActionSheet> createState() =>
      _CategoryUsageActionSheetState();
}

class _CategoryUsageActionSheetState
    extends ConsumerState<_CategoryUsageActionSheet> {
  CategoryEntity? _targetCategory;
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryControllerProvider);
    final otherCategories =
        categoriesAsync.value
            ?.where((c) => c.id != widget.category.id)
            .toList() ??
        [];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category in Use',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '"${widget.category.name}" has existing transactions.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Option 1: Move Transactions',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Reassign all transactions to another category before deleting this one.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<CategoryEntity>(
            value: _targetCategory,
            decoration: const InputDecoration(
              hintText: 'Select New Category',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            items: otherCategories.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Row(
                  children: [
                    Icon(
                      CategoryAssets.icons[cat.icon] ?? Icons.category_rounded,
                      size: 18,
                      color: Color(cat.color),
                    ),
                    const SizedBox(width: 12),
                    Text(cat.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => _targetCategory = val),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _targetCategory == null || _isDeleting
                  ? null
                  : () async {
                      setState(() => _isDeleting = true);
                      await ref
                          .read(categoryControllerProvider.notifier)
                          .reassignAndDeleteCategory(
                            widget.category.id,
                            _targetCategory!.id,
                          );
                      if (context.mounted) Navigator.pop(context);
                    },
              child: _isDeleting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Move & Delete'),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          Text(
            'Option 2: Delete Everything',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This will permanently delete this category AND all transactions associated with it. This action cannot be undone.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _isDeleting
                  ? null
                  : () async {
                      final confirmed = await _showFinalConfirm(context);
                      if (confirmed) {
                        setState(() => _isDeleting = true);
                        await ref
                            .read(categoryControllerProvider.notifier)
                            .deleteCategoryWithTransactions(widget.category.id);
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Delete Category & Transactions'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<bool> _showFinalConfirm(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you absolutely sure?'),
            content: const Text(
              'All records associated with this category will be lost forever.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Delete All'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _CategoryForm extends ConsumerStatefulWidget {
  const _CategoryForm({this.category});

  final CategoryEntity? category;

  @override
  ConsumerState<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<_CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedIcon;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.icon ?? CategoryAssets.icons.keys.first;
    _selectedColor = widget.category != null
        ? Color(widget.category!.color)
        : CategoryAssets.palette.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: const Radius.circular(32)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category == null ? 'New Category' : 'Edit Category',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Category Name',
                prefixIcon: Icon(Icons.label_outline_rounded),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            Text('Icon', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: CategoryAssets.icons.entries.map((entry) {
                  final isSelected = _selectedIcon == entry.key;
                  return Semantics(
                    label: 'Select ${entry.key} icon',
                    selected: isSelected,
                    button: true,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIcon = entry.key),
                      child: Container(
                        width: 50,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Theme.of(context).colorScheme.outline,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          entry.value,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Text('Color', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: CategoryAssets.palette.map((color) {
                  final isSelected = _selectedColor == color;
                  return Semantics(
                    label: 'Select color ${color.toString()}',
                    selected: isSelected,
                    button: true,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 50,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final category = CategoryEntity(
                      id: widget.category?.id ?? '', // Handled in controller
                      name: _nameController.text.trim(),
                      icon: _selectedIcon,
                      color: _selectedColor.toARGB32(),
                    );
                    ref
                        .read(categoryControllerProvider.notifier)
                        .upsertCategory(category);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  widget.category == null ? 'Create Category' : 'Save Changes',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
