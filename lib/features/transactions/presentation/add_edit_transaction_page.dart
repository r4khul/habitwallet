import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/transaction_entity.dart';
import 'providers/transaction_providers.dart';

/// Presentation: UI for adding or editing a transaction.
/// Reusable component handling form state and submission.
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
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (widget.transactionId != null) {
        // In a real app, we'd watch the provider.
        // For simplicity in this UI-focused task, we'll initialize once.
        ref.read(transactionByIdProvider(widget.transactionId!)).whenData((tx) {
          if (tx != null) {
            _amountController.text = tx.absoluteAmount.toString();
            _categoryController.text = tx.category;
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
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final amountValue = double.parse(_amountController.text);
      final transaction = TransactionEntity(
        id: widget.transactionId ?? const Uuid().v4(),
        amount: _isIncome ? amountValue : -amountValue,
        category: _categoryController.text.trim(),
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

              // Amount Field
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
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Category Field
              Text('Category', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(hintText: 'e.g. Groceries'),
                textCapitalization: TextCapitalization.words,
                validator: (value) => value == null || value.isEmpty
                    ? 'Category is required'
                    : null,
              ),
              const SizedBox(height: 24),

              // Date Picker
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
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

              // Note Field
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

              // Save Button
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
