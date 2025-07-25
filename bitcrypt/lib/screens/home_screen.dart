import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/crypto_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<WalletProvider>().refresh();
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: _buildHeader(context),
                expandedHeight: 60,
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Portfolio Overview Card
                      const PortfolioCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Quick Actions
                      const QuickActions(),
                      
                      const SizedBox(height: 24),
                      
                      // Your Holdings Section
                      _buildYourHoldings(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'BitCrypt Wallet',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Notifications
              IconButton(
                onPressed: () {
                  // TODO: Implement notifications
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              
              // Profile/Settings
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to profile
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYourHoldings(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        final portfolio = walletProvider.portfolio;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Holdings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (portfolio.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to full portfolio
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (portfolio.isEmpty)
              _buildEmptyPortfolio(context)
            else
              Column(
                children: portfolio.take(5).map((crypto) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CryptoListItem(
                      cryptocurrency: crypto,
                      showBalance: true,
                      onTap: () {
                        // TODO: Navigate to crypto details
                      },
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyPortfolio(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Assets Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building your portfolio by buying your first cryptocurrency',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to buy crypto
            },
            child: const Text('Buy Crypto'),
          ),
        ],
      ),
    );
  }
}