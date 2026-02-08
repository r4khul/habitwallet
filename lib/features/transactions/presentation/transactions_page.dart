import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitwallet/core/util/formatting_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/util/theme_extension.dart';
import '../../../features/settings/presentation/providers/currency_provider.dart';
import '../../auth/presentation/providers/auth_providers.dart';

import '../../categories/presentation/providers/category_map_provider.dart';
import '../../categories/presentation/widgets/category_assets.dart';
import '../../categories/domain/category_entity.dart';
import '../../profile/presentation/providers/user_profile_provider.dart';
import '../data/transaction_repository_provider.dart';
import '../domain/transaction_entity.dart';
import 'providers/transaction_providers.dart';
import 'widgets/date_range_selector.dart';

/// Transactions Feature Presentation: List of financial transactions.
/// Implements a professional fintech-grade list with states.
class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final categoryMapAsync = ref.watch(categoryMapProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitWallet.'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Menu',
            ),
          ),
        ],
      ),
      endDrawer: const _AppDrawer(),
      body: Column(
        children: [
          const DateRangeSelector(),
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return _EmptyState(
                    onAction: () => _openAddTransaction(context),
                  );
                }
                return categoryMapAsync.when(
                  data: (categoryMap) => RefreshIndicator(
                    onRefresh: () async {
                      try {
                        await ref
                            .read(transactionRepositoryProvider)
                            .syncWithRemote();
                      } catch (_) {
                        // Fail silently or show toast, but let the refresher close
                      }
                    },
                    child: RepaintBoundary(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: transactions.length,
                        itemExtent: 72, // Fixed height for performance
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          final category = categoryMap[tx.categoryId];
                          return Dismissible(
                            key: Key(tx.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) =>
                                _showDeleteConfirmation(context, ref, tx),
                            onDismissed: (direction) {
                              ref
                                  .read(transactionControllerProvider.notifier)
                                  .deleteTransaction(tx.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Transaction deleted'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: _TransactionTile(
                              transaction: tx,
                              category: category,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  loading: () => const _LoadingState(),
                  error: (e, s) => _ErrorState(
                    message: 'Failed to load categories',
                    onRetry: () => ref.refresh(categoryMapProvider),
                  ),
                );
              },
              loading: () => const _LoadingState(),
              error: (error, stack) => _ErrorState(
                message: error.toString(),
                onRetry: () =>
                    ref.read(transactionControllerProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransaction(context),
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  void _openAddTransaction(BuildContext context) {
    context.push('/add-tx');
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    TransactionEntity transaction,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text(
          'This action cannot be undone. Are you sure you want to delete this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends ConsumerWidget {
  const _TransactionTile({required this.transaction, required this.category});

  final TransactionEntity transaction;
  final CategoryEntity? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountColor = transaction.isIncome
        ? AppColors.success
        : AppColors.error;
    final semanticsLabel =
        '${transaction.isIncome ? 'Income' : 'Expense'}: ${transaction.formattedAbsoluteAmount}';

    final currencySymbol = ref.watch(currencySymbolProvider);

    final iconData =
        CategoryAssets.icons[category?.icon] ?? Icons.category_rounded;
    final color = category != null ? Color(category!.color) : AppColors.grey500;

    return InkWell(
      onTap: () => context.push('/tx/${transaction.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: color,
                size: 24,
                semanticLabel: category?.name ?? 'Category icon',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category?.name ?? 'Unknown',
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transaction.displayDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                      if (transaction.editedLocally) ...[
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
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.fontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Semantics(
              label: semanticsLabel,
              child: Text(
                '${transaction.displaySign}$currencySymbol${transaction.compactAbsoluteAmount}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 8,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.grey200.withValues(alpha: 0.1),
              radius: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 120,
                    color: AppColors.grey200.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 80,
                    color: AppColors.grey200.withValues(alpha: 0.1),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              width: 60,
              color: AppColors.grey200.withValues(alpha: 0.1),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAction});

  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          Text(
            'No Transactions Yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start tracking your expenses and see where your money goes.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: onAction,
            style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(minimumSize: const Size(160, 50)),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Consumer(
                  builder: (context, ref, child) {
                    final profileAsync = ref.watch(
                      userProfileControllerProvider,
                    );
                    final savingsAsync = ref.watch(currentYearSavingsProvider);
                    final currencyAsync = ref.watch(currencyControllerProvider);
                    final currencySymbol = currencyAsync.value?.symbol ?? '\$';

                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          profileAsync.value?.name ?? 'User',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.push('/profile');
                                        },
                                        icon: const Icon(
                                          Icons.edit_note_rounded,
                                          color: AppColors.primary,
                                          size: 22,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: 'Edit Profile',
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Savings Target',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Savings Progress Graph (Linear Loader)
                        if (profileAsync.hasValue && savingsAsync.hasValue) ...[
                          Builder(
                            builder: (context) {
                              final goal =
                                  profileAsync.value?.yearlySavingsGoal ?? 1.0;
                              final current = savingsAsync.value ?? 0.0;
                              final isOverTarget = current > goal;
                              final barProgress = (current / goal)
                                  .clamp(0.0, 1.0)
                                  .toDouble();
                              final realPercentage = (current / goal * 100)
                                  .toInt();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            FormattingUtils.formatCompact(
                                              current,
                                              symbol: currencySymbol,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: isOverTarget
                                                      ? AppColors.success
                                                      : AppColors.primary,
                                                ),
                                          ),
                                          if (isOverTarget)
                                            Text(
                                              'Surplus: ${FormattingUtils.formatCompact(current - goal, symbol: currencySymbol)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: AppColors.success,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if (isOverTarget) ...[
                                            const Icon(
                                              Icons.stars_rounded,
                                              color: AppColors.success,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                          ],
                                          Text(
                                            '$realPercentage%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: isOverTarget
                                                      ? AppColors.success
                                                      : AppColors.grey500,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: barProgress,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isOverTarget
                                                  ? [
                                                      AppColors.success,
                                                      const Color(0xFF81C784),
                                                    ]
                                                  : [
                                                      AppColors.primary,
                                                      const Color(0xFF64B5F6),
                                                    ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Goal: ${FormattingUtils.formatCompact(goal, symbol: currencySymbol)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: AppColors.grey500),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              const Divider(height: 1),
              _ThemeToggle(),

              // Menu Items
              _DrawerItem(
                icon: Icons.category_outlined,
                label: 'Categories',
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  context.push('/categories');
                },
              ),
              _DrawerItem(
                icon: Icons.refresh_rounded,
                label: 'Sync Data',
                onTap: () {
                  ref.read(transactionControllerProvider.notifier).refresh();
                  Navigator.pop(context);
                },
              ),
              _DrawerItem(
                icon: Icons.bar_chart_rounded,
                label: 'Analytics',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/analytics');
                },
              ),
              _DrawerItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  context.push('/settings');
                },
              ),
              const Spacer(),

              // Logout
              const Divider(height: 1),
              _DrawerItem(
                icon: Icons.logout_rounded,
                label: 'Sign Out',
                color: AppColors.error,
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout();
                  Navigator.pop(context); // Close drawer
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(icon, color: color ?? AppColors.grey500, size: 24),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isDark = themeMode == ThemeMode.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(
        isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        color: AppColors.grey500,
        size: 24,
      ),
      title: Text(
        '${isDark ? 'Dark' : 'Light'} Mode',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: isDark,
        onChanged: (_) =>
            ref.read(themeControllerProvider.notifier).toggleTheme(),
        activeTrackColor: AppColors.primary,
      ),
    );
  }
}
