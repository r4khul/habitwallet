import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/transaction_providers.dart';

/// Transaction Details Feature Presentation: Detailed view of a specific transaction.
class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text('Transaction $id')),
      body: transactionAsync.when(
        data: (tx) => tx == null
            ? const Center(child: Text('Transaction not found'))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category: ${tx.category}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Amount: ${tx.amount}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Date: ${tx.timestamp}'),
                    if (tx.note != null) ...[
                      const SizedBox(height: 16),
                      Text('Note: ${tx.note}'),
                    ],
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
