import 'package:flutter/material.dart';
import '../models/cryptocurrency.dart';
import '../utils/app_theme.dart';

class CryptoListItem extends StatelessWidget {
  final Cryptocurrency cryptocurrency;
  final bool showBalance;
  final VoidCallback? onTap;

  const CryptoListItem({
    super.key,
    required this.cryptocurrency,
    this.showBalance = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPositive = cryptocurrency.isPriceUp;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Crypto Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: cryptocurrency.iconUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        cryptocurrency.iconUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallbackIcon();
                        },
                      ),
                    )
                  : _buildFallbackIcon(),
            ),
            
            const SizedBox(width: 16),
            
            // Crypto Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cryptocurrency.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        cryptocurrency.symbol,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (showBalance && cryptocurrency.balance > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${cryptocurrency.formattedBalance}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Price Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cryptocurrency.formattedPrice,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? AppTheme.accentGreen.withOpacity(0.1)
                        : AppTheme.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        cryptocurrency.formattedPriceChange,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Balance USD (if showing balance)
            if (showBalance && cryptocurrency.balance > 0) ...[
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    cryptocurrency.formattedBalanceUSD,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cryptocurrency.formattedBalance,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(
      Icons.currency_bitcoin,
      color: AppTheme.primaryBlue,
      size: 24,
    );
  }
}