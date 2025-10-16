import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/update_service.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.privacyPolicy,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF79113E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.appTitle +
                  ' ' +
                  AppLocalizations.of(context)!.privacyPolicy,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF79113E),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.lastUpdated}: ${UpdateService.getLastReleaseDateString()}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              AppLocalizations.of(context)!.ppCollectedInfoTitle,
              AppLocalizations.of(context)!.ppCollectedInfoContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.ppUsageTitle,
              AppLocalizations.of(context)!.ppUsageContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.ppSharingTitle,
              AppLocalizations.of(context)!.ppSharingContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.ppSecurityTitle,
              AppLocalizations.of(context)!.ppSecurityContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.ppDeletionTitle,
              AppLocalizations.of(context)!.ppDeletionContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.ppContactTitle,
              AppLocalizations.of(context)!.ppContactContent,
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.ppFooter,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF79113E),
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.6)),
        const SizedBox(height: 24),
      ],
    );
  }
}
