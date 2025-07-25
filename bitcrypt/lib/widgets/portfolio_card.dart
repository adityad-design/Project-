import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_theme.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        final totalBalance = walletProvider.totalBalance;
        final portfolio = walletProvider.portfolio;
        
        // Calculate 24h change (mock calculation for demo)
        double dailyChange = 0.0;
        double dailyChangePercent = 0.0;
        
        if (portfolio.isNotEmpty) {
          for (final crypto in portfolio) {
            dailyChange += (crypto.balance * crypto.priceChange24h);
          }
          dailyChangePercent = totalBalance > 0 ? (dailyChange / (totalBalance - dailyChange)) * 100 : 0.0;
        }

        final isPositive = dailyChange >= 0;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue,
                AppTheme.secondaryBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Portfolio Value',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Icon(
                    Icons.visibility_outlined,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Total Balance
              Text(
                '\$${totalBalance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Daily Change
              if (portfolio.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}\$${dailyChange.abs().toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${isPositive ? '+' : ''}${dailyChangePercent.toStringAsFixed(2)}%)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Start investing to see your portfolio grow',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Portfolio Distribution (if has assets)
              if (portfolio.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Holdings',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: portfolio.take(3).map((crypto) {
                        final percentage = totalBalance > 0 ? (crypto.balanceUSD / totalBalance) * 100 : 0.0;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: _getColorForIndex(portfolio.indexOf(crypto)),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: portfolio.take(3).map((crypto) {
                        final percentage = totalBalance > 0 ? (crypto.balanceUSD / totalBalance) * 100 : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _getColorForIndex(portfolio.indexOf(crypto)),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${crypto.symbol} ${percentage.toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      AppTheme.accentGreen,
      AppTheme.warningOrange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}