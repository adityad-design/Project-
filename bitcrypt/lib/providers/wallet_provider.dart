import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cryptocurrency.dart';
import '../services/crypto_service.dart';

class WalletProvider with ChangeNotifier {
  List<Cryptocurrency> _cryptocurrencies = [];
  List<Cryptocurrency> _portfolio = [];
  bool _isLoading = false;
  String? _error;
  double _totalBalance = 0.0;
  String _selectedCurrency = 'USD';

  // Getters
  List<Cryptocurrency> get cryptocurrencies => _cryptocurrencies;
  List<Cryptocurrency> get portfolio => _portfolio;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get totalBalance => _totalBalance;
  String get selectedCurrency => _selectedCurrency;

  final CryptoService _cryptoService = CryptoService();

  WalletProvider() {
    _loadPortfolioFromPrefs();
    loadCryptocurrencies();
  }

  // Load popular cryptocurrencies
  Future<void> loadCryptocurrencies() async {
    _setLoading(true);
    try {
      final cryptos = await _cryptoService.getTopCryptocurrencies();
      _cryptocurrencies = cryptos;
      _updatePortfolioPrices();
      _error = null;
    } catch (e) {
      _error = e.toString();
      // Load mock data if API fails
      _loadMockData();
    }
    _setLoading(false);
  }

  // Add cryptocurrency to portfolio
  void addToPortfolio(Cryptocurrency crypto, double amount) {
    final existingIndex = _portfolio.indexWhere((c) => c.id == crypto.id);
    
    if (existingIndex != -1) {
      // Update existing
      final existing = _portfolio[existingIndex];
      final newBalance = existing.balance + amount;
      _portfolio[existingIndex] = crypto.copyWith(
        balance: newBalance,
        balanceUSD: newBalance * crypto.currentPrice,
      );
    } else {
      // Add new
      _portfolio.add(crypto.copyWith(
        balance: amount,
        balanceUSD: amount * crypto.currentPrice,
      ));
    }
    
    _calculateTotalBalance();
    _savePortfolioToPrefs();
    notifyListeners();
  }

  // Remove from portfolio
  void removeFromPortfolio(String cryptoId) {
    _portfolio.removeWhere((crypto) => crypto.id == cryptoId);
    _calculateTotalBalance();
    _savePortfolioToPrefs();
    notifyListeners();
  }

  // Update portfolio with latest prices
  void _updatePortfolioPrices() {
    for (int i = 0; i < _portfolio.length; i++) {
      final portfolioCrypto = _portfolio[i];
      final latestCrypto = _cryptocurrencies.firstWhere(
        (c) => c.id == portfolioCrypto.id,
        orElse: () => portfolioCrypto,
      );
      
      _portfolio[i] = latestCrypto.copyWith(
        balance: portfolioCrypto.balance,
        balanceUSD: portfolioCrypto.balance * latestCrypto.currentPrice,
      );
    }
    _calculateTotalBalance();
  }

  // Calculate total portfolio balance
  void _calculateTotalBalance() {
    _totalBalance = _portfolio.fold(0.0, (sum, crypto) => sum + crypto.balanceUSD);
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Load portfolio from shared preferences
  Future<void> _loadPortfolioFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final portfolioJson = prefs.getString('portfolio');
      if (portfolioJson != null) {
        final List<dynamic> portfolioList = json.decode(portfolioJson);
        _portfolio = portfolioList.map((json) => Cryptocurrency.fromJson(json)).toList();
        _calculateTotalBalance();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading portfolio: $e');
    }
  }

  // Save portfolio to shared preferences
  Future<void> _savePortfolioToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final portfolioJson = json.encode(_portfolio.map((crypto) => crypto.toJson()).toList());
      await prefs.setString('portfolio', portfolioJson);
    } catch (e) {
      print('Error saving portfolio: $e');
    }
  }

  // Load mock data for demo purposes
  void _loadMockData() {
    _cryptocurrencies = [
      Cryptocurrency(
        id: 'bitcoin',
        name: 'Bitcoin',
        symbol: 'BTC',
        iconUrl: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
        currentPrice: 43250.00,
        priceChange24h: 1250.00,
        priceChangePercentage24h: 2.97,
        marketCap: 847000000000,
        volume24h: 15000000000,
      ),
      Cryptocurrency(
        id: 'ethereum',
        name: 'Ethereum',
        symbol: 'ETH',
        iconUrl: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
        currentPrice: 2650.00,
        priceChange24h: -85.00,
        priceChangePercentage24h: -3.11,
        marketCap: 318000000000,
        volume24h: 8500000000,
      ),
      Cryptocurrency(
        id: 'cardano',
        name: 'Cardano',
        symbol: 'ADA',
        iconUrl: 'https://assets.coingecko.com/coins/images/975/large/cardano.png',
        currentPrice: 0.485,
        priceChange24h: 0.025,
        priceChangePercentage24h: 5.43,
        marketCap: 17200000000,
        volume24h: 450000000,
      ),
      Cryptocurrency(
        id: 'solana',
        name: 'Solana',
        symbol: 'SOL',
        iconUrl: 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
        currentPrice: 98.50,
        priceChange24h: 4.20,
        priceChangePercentage24h: 4.45,
        marketCap: 43500000000,
        volume24h: 1200000000,
      ),
      Cryptocurrency(
        id: 'polkadot',
        name: 'Polkadot',
        symbol: 'DOT',
        iconUrl: 'https://assets.coingecko.com/coins/images/12171/large/polkadot.png',
        currentPrice: 7.85,
        priceChange24h: -0.32,
        priceChangePercentage24h: -3.92,
        marketCap: 10200000000,
        volume24h: 320000000,
      ),
    ];
  }

  // Refresh data
  Future<void> refresh() async {
    await loadCryptocurrencies();
  }

  // Get cryptocurrency by ID
  Cryptocurrency? getCryptocurrencyById(String id) {
    try {
      return _cryptocurrencies.firstWhere((crypto) => crypto.id == id);
    } catch (e) {
      return null;
    }
  }

  // Check if cryptocurrency is in portfolio
  bool isInPortfolio(String cryptoId) {
    return _portfolio.any((crypto) => crypto.id == cryptoId);
  }

  // Get portfolio item
  Cryptocurrency? getPortfolioItem(String cryptoId) {
    try {
      return _portfolio.firstWhere((crypto) => crypto.id == cryptoId);
    } catch (e) {
      return null;
    }
  }
}