# BitCrypt - Cryptocurrency Wallet App

A modern, secure cryptocurrency wallet application built with Flutter, similar to Trust Wallet. BitCrypt provides a sleek and intuitive interface for managing your cryptocurrency portfolio.

## 🚀 Features

### Core Functionality
- **Multi-Currency Support**: Support for Bitcoin, Ethereum, Cardano, Solana, Polkadot, and more
- **Real-time Price Data**: Live cryptocurrency prices and market data via CoinGecko API
- **Portfolio Management**: Track your holdings and portfolio performance
- **Buy/Sell Simulation**: Simulate cryptocurrency transactions (demo mode)
- **Search & Discovery**: Find and explore cryptocurrencies

### User Experience
- **Modern UI/UX**: Clean, intuitive design inspired by Trust Wallet
- **Dark/Light Theme**: Toggle between dark and light modes
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Animations**: Fluid transitions and loading animations
- **Pull-to-Refresh**: Easy data refresh with pull gestures

### Security (Planned)
- **Biometric Authentication**: Fingerprint and Face ID support
- **PIN Protection**: Secure PIN-based access
- **Wallet Backup**: Secure recovery phrase management
- **Two-Factor Authentication**: Additional security layer

## 📱 Screenshots

The app features four main screens accessible via bottom navigation:

1. **Home**: Portfolio overview, quick actions, and holdings summary
2. **Portfolio**: Detailed portfolio breakdown and analytics
3. **Market**: Browse and search cryptocurrencies with market data
4. **Settings**: App preferences, security settings, and account management

## 🛠️ Tech Stack

- **Framework**: Flutter 3.24.3
- **Language**: Dart 3.5.3
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: SharedPreferences
- **UI Components**: Material Design 3
- **Fonts**: Google Fonts (Inter)
- **Charts**: FL Chart (for future price charts)
- **Icons**: Material Icons + custom SVG support

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.1.0
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  qr_flutter: ^4.1.0
  qr_code_scanner: ^1.0.1
  fl_chart: ^0.66.0
  flutter_svg: ^2.0.9
  lottie: ^2.7.0
  local_auth: ^2.1.7
  crypto: ^3.0.3
  url_launcher: ^6.2.4
  image_picker: ^1.0.7
  flutter_spinkit: ^5.2.0
  google_fonts: ^6.1.0
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── cryptocurrency.dart   # Cryptocurrency data model
├── providers/
│   ├── wallet_provider.dart  # Portfolio and crypto data management
│   └── theme_provider.dart   # Theme state management
├── screens/
│   ├── splash_screen.dart    # App splash screen
│   ├── main_navigation.dart  # Bottom navigation container
│   ├── home_screen.dart      # Dashboard/home screen
│   ├── portfolio_screen.dart # Portfolio details
│   ├── market_screen.dart    # Market browser
│   └── settings_screen.dart  # Settings and preferences
├── services/
│   └── crypto_service.dart   # API service for crypto data
├── utils/
│   └── app_theme.dart        # Theme configuration
└── widgets/
    ├── portfolio_card.dart   # Portfolio overview widget
    ├── quick_actions.dart    # Action buttons widget
    └── crypto_list_item.dart # Cryptocurrency list item
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd bitcrypt
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### API Configuration

The app uses the CoinGecko API for cryptocurrency data. No API key is required for the free tier, but rate limits apply. For production use, consider:

- Implementing API key authentication
- Adding error handling for rate limits
- Caching strategies for better performance

## 🎨 Design System

### Colors
- **Primary Blue**: #1E3A8A
- **Secondary Blue**: #3B82F6
- **Accent Green**: #10B981
- **Warning Orange**: #F59E0B
- **Error Red**: #EF4444

### Typography
- **Font Family**: Inter (Google Fonts)
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Spacing & Layout
- **Base Unit**: 8px
- **Border Radius**: 12px, 16px, 20px
- **Shadows**: Subtle elevation with opacity-based shadows

## 🔧 Development

### Running Tests
```bash
flutter test
```

### Building for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Code Quality
The project follows Flutter/Dart best practices:
- Consistent naming conventions
- Proper widget composition
- State management with Provider
- Error handling and loading states
- Responsive design principles

## 🔐 Security Considerations

This is a demo application. For production use, implement:

- **Secure Storage**: Use flutter_secure_storage for sensitive data
- **Certificate Pinning**: Pin SSL certificates for API calls
- **Code Obfuscation**: Obfuscate code for release builds
- **Biometric Authentication**: Implement local_auth properly
- **Wallet Integration**: Connect with actual blockchain wallets

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Design inspiration from Trust Wallet
- CoinGecko for cryptocurrency API
- Flutter team for the amazing framework
- Material Design for UI guidelines

## 📞 Support

For support, email support@bitcrypt.app or join our Discord community.

---

**Note**: This is a demonstration application. Do not use for actual cryptocurrency transactions without implementing proper security measures and wallet integrations.
