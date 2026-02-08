import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
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

class _DetailsView extends StatelessWidget {
  final TransactionEntity transaction;

  const _DetailsView({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? AppColors.success : AppColors.error;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    transaction.isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${transaction.isIncome ? '+' : '-'}\$${transaction.absoluteAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  transaction.category,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: AppColors.grey500),
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
            value:
                '${transaction.timestamp.day}/${transaction.timestamp.month}/${transaction.timestamp.year}',
            icon: Icons.calendar_today_outlined,
          ),
          _DetailRow(
            label: 'Time',
            value:
                '${transaction.timestamp.hour.toString().padLeft(2, '0')}:${transaction.timestamp.minute.toString().padLeft(2, '0')}',
            icon: Icons.access_time_rounded,
          ),
          if (transaction.note != null)
            _DetailRow(
              label: 'Note',
              value: transaction.note!,
              icon: Icons.notes_rounded,
            ),

          const SizedBox(height: 40),

          // Delete Action (Simulated)
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                // In a real app, show confirmation dialog
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              label: const Text(
                'Delete Transaction',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

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
          Text(value, style: Theme.of(context).textTheme.titleMedium),
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
  final String message;

  const _ErrorState({required this.message});

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
