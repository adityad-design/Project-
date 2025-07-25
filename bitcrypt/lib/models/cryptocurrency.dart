class Cryptocurrency {
  final String id;
  final String name;
  final String symbol;
  final String iconUrl;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCap;
  final double volume24h;
  final double balance;
  final double balanceUSD;

  Cryptocurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.iconUrl,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.volume24h,
    this.balance = 0.0,
    this.balanceUSD = 0.0,
  });

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    return Cryptocurrency(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      iconUrl: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      volume24h: (json['total_volume'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'iconUrl': iconUrl,
      'currentPrice': currentPrice,
      'priceChange24h': priceChange24h,
      'priceChangePercentage24h': priceChangePercentage24h,
      'marketCap': marketCap,
      'volume24h': volume24h,
      'balance': balance,
      'balanceUSD': balanceUSD,
    };
  }

  Cryptocurrency copyWith({
    String? id,
    String? name,
    String? symbol,
    String? iconUrl,
    double? currentPrice,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? marketCap,
    double? volume24h,
    double? balance,
    double? balanceUSD,
  }) {
    return Cryptocurrency(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      iconUrl: iconUrl ?? this.iconUrl,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCap: marketCap ?? this.marketCap,
      volume24h: volume24h ?? this.volume24h,
      balance: balance ?? this.balance,
      balanceUSD: balanceUSD ?? this.balanceUSD,
    );
  }

  bool get isPriceUp => priceChangePercentage24h >= 0;

  String get formattedPrice {
    if (currentPrice >= 1) {
      return '\$${currentPrice.toStringAsFixed(2)}';
    } else {
      return '\$${currentPrice.toStringAsFixed(6)}';
    }
  }

  String get formattedPriceChange {
    final sign = isPriceUp ? '+' : '';
    return '$sign${priceChangePercentage24h.toStringAsFixed(2)}%';
  }

  String get formattedBalance {
    if (balance >= 1) {
      return balance.toStringAsFixed(4);
    } else {
      return balance.toStringAsFixed(8);
    }
  }

  String get formattedBalanceUSD {
    return '\$${balanceUSD.toStringAsFixed(2)}';
  }
}