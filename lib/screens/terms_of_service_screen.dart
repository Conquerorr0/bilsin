import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/update_service.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.termsOfService,
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
                  AppLocalizations.of(context)!.termsOfService,
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
              AppLocalizations.of(context)!.tosServiceTitle,
              AppLocalizations.of(context)!.tosServiceContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.tosTermsTitle,
              AppLocalizations.of(context)!.tosTermsContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.tosResponsibilitiesTitle,
              AppLocalizations.of(context)!.tosResponsibilitiesContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.tosDowntimeTitle,
              AppLocalizations.of(context)!.tosDowntimeContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.tosContentLiabilityTitle,
              AppLocalizations.of(context)!.tosContentLiabilityContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.tosChangesTitle,
              AppLocalizations.of(context)!.tosChangesContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.tosDisclaimerTitle,
              AppLocalizations.of(context)!.tosDisclaimerContent,
            ),
            _buildSection(
              AppLocalizations.of(context)!.tosContactTitle,
              AppLocalizations.of(context)!.tosContactContent,
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.tosFooter,
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
