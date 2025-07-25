import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/crypto_list_item.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search cryptocurrencies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkSurface
                    : Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<WalletProvider>().refresh();
        },
        child: Consumer<WalletProvider>(
          builder: (context, walletProvider, child) {
            final cryptocurrencies = walletProvider.cryptocurrencies;
            final isLoading = walletProvider.isLoading;

            if (isLoading && cryptocurrencies.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (cryptocurrencies.isEmpty) {
              return _buildErrorState(context, walletProvider);
            }

            // Filter cryptocurrencies based on search
            final filteredCryptos = _searchQuery.isEmpty
                ? cryptocurrencies
                : cryptocurrencies.where((crypto) =>
                    crypto.name.toLowerCase().contains(_searchQuery) ||
                    crypto.symbol.toLowerCase().contains(_searchQuery)).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Market Stats
                  _buildMarketStats(context),
                  
                  const SizedBox(height: 24),
                  
                  // Cryptocurrencies List
                  _buildCryptoList(context, filteredCryptos, walletProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMarketStats(BuildContext context) {
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
            'Market Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Total Market Cap',
                  '\$2.45T',
                  '+2.34%',
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  '24h Volume',
                  '\$98.7B',
                  '-1.23%',
                  false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, String change, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          change,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isPositive ? AppTheme.accentGreen : AppTheme.errorRed,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoList(BuildContext context, List cryptocurrencies, WalletProvider walletProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _searchQuery.isEmpty 
              ? 'Top Cryptocurrencies (${cryptocurrencies.length})'
              : 'Search Results (${cryptocurrencies.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (cryptocurrencies.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No cryptocurrencies found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search query',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cryptocurrencies.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final crypto = cryptocurrencies[index];
              return GestureDetector(
                onLongPress: () => _showBuyDialog(context, crypto, walletProvider),
                child: CryptoListItem(
                  cryptocurrency: crypto,
                  onTap: () => _showCryptoDetails(context, crypto, walletProvider),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, WalletProvider walletProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to Load Market Data',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please check your internet connection and try again.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => walletProvider.refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCryptoDetails(BuildContext context, crypto, WalletProvider walletProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Crypto Header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: crypto.iconUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              crypto.iconUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.currency_bitcoin,
                                  color: AppTheme.primaryBlue,
                                  size: 30,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.currency_bitcoin,
                            color: AppTheme.primaryBlue,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crypto.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          crypto.symbol,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Price Info
              Text(
                crypto.formattedPrice,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    crypto.isPriceUp ? Icons.trending_up : Icons.trending_down,
                    color: crypto.isPriceUp ? AppTheme.accentGreen : AppTheme.errorRed,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    crypto.formattedPriceChange,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: crypto.isPriceUp ? AppTheme.accentGreen : AppTheme.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showBuyDialog(context, crypto, walletProvider);
                      },
                      child: const Text('Buy'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Add to watchlist
                      },
                      child: const Text('Watch'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBuyDialog(BuildContext context, crypto, WalletProvider walletProvider) {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy ${crypto.symbol}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current Price: ${crypto.formattedPrice}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (${crypto.symbol})',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                walletProvider.addToPortfolio(crypto, amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully bought ${amount.toStringAsFixed(4)} ${crypto.symbol}'),
                    backgroundColor: AppTheme.accentGreen,
                  ),
                );
              }
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }
}