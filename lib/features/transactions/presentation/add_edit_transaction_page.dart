import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../categories/domain/category_entity.dart';
import '../../categories/presentation/providers/category_providers.dart';
import '../../categories/presentation/widgets/category_assets.dart';
import '../domain/transaction_entity.dart';
import 'providers/transaction_providers.dart';

/// Presentation: UI for adding or editing a transaction.
class AddEditTransactionPage extends ConsumerStatefulWidget {
  final String? transactionId;

  const AddEditTransactionPage({super.key, this.transactionId});

  @override
  ConsumerState<AddEditTransactionPage> createState() =>
      _AddEditTransactionPageState();
}

class _AddEditTransactionPageState
    extends ConsumerState<AddEditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (widget.transactionId != null) {
        ref.read(transactionByIdProvider(widget.transactionId!)).whenData((tx) {
          if (tx != null) {
            _amountController.text = tx.absoluteAmount.toString();
            _selectedCategoryId = tx.categoryId;
            _noteController.text = tx.note ?? '';
            _selectedDate = tx.timestamp;
            _isIncome = tx.isIncome;
            setState(() {});
          }
        });
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final amountValue = double.parse(_amountController.text);
      final transaction = TransactionEntity(
        id: widget.transactionId ?? const Uuid().v4(),
        amount: _isIncome ? amountValue : -amountValue,
        categoryId: _selectedCategoryId!,
        timestamp: _selectedDate,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        editedLocally: true,
      );

      await ref
          .read(transactionControllerProvider.notifier)
          .upsertTransaction(transaction);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionId != null;
    final categoriesAsync = ref.watch(categoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'New Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Toggle
              Row(
                children: [
                  _TypeButton(
                    label: 'Expense',
                    isSelected: !_isIncome,
                    color: AppColors.error,
                    onTap: () => setState(() => _isIncome = false),
                  ),
                  const SizedBox(width: 12),
                  _TypeButton(
                    label: 'Income',
                    isSelected: _isIncome,
                    color: AppColors.success,
                    onTap: () => setState(() => _isIncome = true),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text('Amount', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: _isIncome ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Text('Category', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              categoriesAsync.when(
                data: (categories) => _CategorySelector(
                  categories: categories,
                  selectedId: _selectedCategoryId,
                  onSelected: (id) => setState(() => _selectedCategoryId = id),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, s) => Text('Error loading categories: $e'),
              ),
              const SizedBox(height: 24),

              Text('Date', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey800),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Note (Optional)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Add a description...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Save Changes' : 'Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const _CategorySelector({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selected = categories.cast<CategoryEntity?>().firstWhere(
      (c) => c?.id == selectedId,
      orElse: () => null,
    );

    return InkWell(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey800),
        ),
        child: Row(
          children: [
            if (selected != null) ...[
              Icon(
                CategoryAssets.icons[selected.icon] ?? Icons.category_rounded,
                color: Color(selected.color),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(selected.name, style: Theme.of(context).textTheme.bodyLarge),
            ] else
              Text(
                'Select Category',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.grey500),
              ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.grey500,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return ListTile(
            onTap: () {
              onSelected(cat.id);
              Navigator.pop(context);
            },
            leading: Icon(
              CategoryAssets.icons[cat.icon] ?? Icons.category_rounded,
              color: Color(cat.color),
            ),
            title: Text(cat.name),
            selected: cat.id == selectedId,
            selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.grey800,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isSelected ? color : AppColors.grey500,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
