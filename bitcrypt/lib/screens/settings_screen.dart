import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(context),
            
            const SizedBox(height: 32),
            
            // Preferences Section
            _buildPreferencesSection(context),
            
            const SizedBox(height: 32),
            
            // Security Section
            _buildSecuritySection(context),
            
            const SizedBox(height: 32),
            
            // About Section
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BitCrypt User',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your profile and preferences',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.palette_outlined,
              title: 'Dark Mode',
              subtitle: 'Toggle dark/light theme',
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: AppTheme.accentGreen,
                  );
                },
              ),
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'English (US)',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Language Selection');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.attach_money_outlined,
              title: 'Currency',
              subtitle: 'USD',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Currency Selection');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification settings',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Notification Settings');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.fingerprint_outlined,
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Biometric Authentication');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.lock_outline,
              title: 'Change PIN',
              subtitle: 'Update your security PIN',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'PIN Management');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.backup_outlined,
              title: 'Backup Wallet',
              subtitle: 'Secure your wallet recovery phrase',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Wallet Backup');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.security_outlined,
              title: 'Two-Factor Authentication',
              subtitle: 'Add extra security layer',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, '2FA Setup');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Help & Support');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'View our privacy policy',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Privacy Policy');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'View terms and conditions',
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {
                _showComingSoon(context, 'Terms of Service');
              },
            ),
            const Divider(height: 1),
            _buildSettingsTile(
              context,
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: 'BitCrypt v1.0.0',
              trailing: null,
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Logo and Footer
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'BitCrypt',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Secure Cryptocurrency Wallet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$feature Coming Soon'),
          content: Text('The $feature feature will be available in a future update.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}