import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../categories/presentation/providers/category_providers.dart';
import '../../categories/presentation/widgets/category_assets.dart';
import '../domain/transaction_entity.dart';
import 'providers/transaction_providers.dart';

/// Transaction Details Feature Presentation: Detailed view of a specific transaction.
/// Implements a sophisticated, read-only view with edit capability.
class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          transactionAsync.whenOrNull(
                data: (tx) => tx != null
                    ? IconButton(
                        onPressed: () => context.push('/edit-tx/$id'),
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit Transaction',
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: transactionAsync.when(
        data: (tx) =>
            tx == null ? const _NotFoundState() : _DetailsView(transaction: tx),
        loading: () => const _LoadingState(),
        error: (e, s) => _ErrorState(message: e.toString()),
      ),
    );
  }
}

class _DetailsView extends ConsumerWidget {
  const _DetailsView({required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountColor = transaction.isIncome
        ? AppColors.success
        : AppColors.error;
    final categoryAsync = ref.watch(
      categoryByIdProvider(transaction.categoryId),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Header
          Center(
            child: Column(
              children: [
                categoryAsync.when(
                  data: (category) {
                    final iconData =
                        CategoryAssets.icons[category?.icon] ??
                        (transaction.isIncome
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded);
                    final color = category != null
                        ? Color(category.color)
                        : amountColor;
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconData,
                        color: color,
                        size: 48,
                        semanticLabel: category?.name ?? 'Category icon',
                      ),
                    );
                  },
                  loading: () => Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.grey900,
                      shape: BoxShape.circle,
                    ),
                  ),
                  error: (error, stack) => const Icon(Icons.error_outline),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label:
                      '${transaction.isIncome ? 'Income' : 'Expense'}: ${transaction.formattedAbsoluteAmount}',
                  child: Text(
                    '${transaction.displaySign}\$${transaction.formattedAbsoluteAmount}',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                categoryAsync.when(
                  data: (category) => Text(
                    category?.name ?? 'Unknown',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  loading: () => Container(
                    height: 24,
                    width: 100,
                    color: AppColors.grey900,
                  ),
                  error: (error, stack) => const Text('Error'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Details List
          _DetailRow(
            label: 'Status',
            value: 'Completed',
            icon: Icons.check_circle_outline,
          ),
          _DetailRow(
            label: 'Date',
            value: transaction.displayDate,
            icon: Icons.calendar_today_outlined,
          ),
          _DetailRow(
            label: 'Time',
            value: transaction.displayTime,
            icon: Icons.access_time_rounded,
          ),
          if (transaction.note != null && transaction.note!.isNotEmpty)
            _DetailRow(
              label: 'Note',
              value: transaction.note!,
              icon: Icons.notes_rounded,
            ),

          const SizedBox(height: 40),

          // Delete Action
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                // TODO: Implement delete logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delete functionality coming soon'),
                  ),
                );
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              label: Text(
                'Delete Transaction',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey600),
          const SizedBox(width: 16),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.grey600),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  const _NotFoundState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.grey800,
          ),
          const SizedBox(height: 16),
          Text(
            'Transaction Not Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'It may have been deleted or moved.',
            style: TextStyle(color: AppColors.grey500),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: const TextStyle(color: AppColors.error),
      ),
    );
  }
}
