import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/crypto_list_item.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add portfolio filters/sorting
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<WalletProvider>().refresh();
        },
        child: Consumer<WalletProvider>(
          builder: (context, walletProvider, child) {
            final portfolio = walletProvider.portfolio;
            final totalBalance = walletProvider.totalBalance;

            if (portfolio.isEmpty) {
              return _buildEmptyPortfolio(context);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Portfolio Stats
                  _buildPortfolioStats(context, totalBalance, portfolio),
                  
                  const SizedBox(height: 24),
                  
                  // Holdings List
                  _buildHoldingsList(context, portfolio),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortfolioStats(BuildContext context, double totalBalance, List portfolio) {
    // Calculate portfolio stats
    double totalGain = 0.0;
    for (final crypto in portfolio) {
      totalGain += (crypto.balance * crypto.priceChange24h);
    }
    final gainPercent = totalBalance > 0 ? (totalGain / (totalBalance - totalGain)) * 100 : 0.0;
    final isPositive = totalGain >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Value',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}\$${totalGain.abs().toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${isPositive ? '+' : ''}${gainPercent.toStringAsFixed(2)}%)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'today',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingsList(BuildContext context, List portfolio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Holdings (${portfolio.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: portfolio.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final crypto = portfolio[index];
            return CryptoListItem(
              cryptocurrency: crypto,
              showBalance: true,
              onTap: () {
                // TODO: Navigate to crypto details
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyPortfolio(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Portfolio Yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your portfolio will appear here once you start investing in cryptocurrencies.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to market/buy screen
              },
              child: const Text('Explore Market'),
            ),
          ],
        ),
      ),
    );
  }
}