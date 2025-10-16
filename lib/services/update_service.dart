import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

class UpdateService {
  static const String keyLatestVersion = 'latest_version';
  static const String keyMinSupportedVersion = 'min_supported_version';
  static const String keyDownloadUrl = 'download_url';
  static const String keyLastReleaseDate =
      'last_release_date'; // ISO 8601 (YYYY-MM-DD)

  static Future<void> ensureInitialized() async {
    final rc = FirebaseRemoteConfig.instance;
    await rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await rc.setDefaults(const {
      keyLatestVersion: '1.1.3',
      keyMinSupportedVersion: '1.0.0',
      keyDownloadUrl:
          'https://github.com/Conquerorr0/bilsin/releases/latest/download/app-release.apk',
      keyLastReleaseDate: '2025-10-16',
    });
    await rc.fetchAndActivate();
  }

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      await ensureInitialized();

      final info = await PackageInfo.fromPlatform();
      final current = info.version; // e.g. 1.1.0

      final rc = FirebaseRemoteConfig.instance;
      final latest = rc.getString(keyLatestVersion);
      final minSupported = rc.getString(keyMinSupportedVersion);
      final downloadUrl = rc.getString(keyDownloadUrl);

      final isMandatory = _isVersionLower(current, minSupported);
      final isRecommended = _isVersionLower(current, latest);

      if (!(isMandatory || isRecommended)) return;

      if (!context.mounted) return;
      await _showUpdateDialog(
        context: context,
        mandatory: isMandatory,
        downloadUrl: downloadUrl,
        current: current,
        latest: latest,
      );
    } catch (_) {
      // Sessizce yut: güncelleme kontrolü uygulamayı engellemesin
    }
  }

  static String getLastReleaseDateString() {
    try {
      final rc = FirebaseRemoteConfig.instance;
      final date = rc.getString(keyLastReleaseDate);
      if (date.isEmpty) return '';
      return date; // keep as provided (ISO or display string)
    } catch (_) {
      return '';
    }
  }

  static bool _isVersionLower(String a, String b) {
    try {
      List<int> pa = a.split('.').map(int.parse).toList();
      List<int> pb = b.split('.').map(int.parse).toList();
      for (int i = 0; i < 3; i++) {
        final ai = i < pa.length ? pa[i] : 0;
        final bi = i < pb.length ? pb[i] : 0;
        if (ai < bi) return true;
        if (ai > bi) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _showUpdateDialog({
    required BuildContext context,
    required bool mandatory,
    required String downloadUrl,
    required String current,
    required String latest,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: !mandatory,
      builder: (ctx) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.updateAvailable),
          content: Text(
            mandatory
                ? '${l10n.updateRequired}: v$current → v$latest'
                : '${l10n.updateOptional}: v$current → v$latest',
          ),
          actions: [
            if (!mandatory)
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.updateLater),
              ),
            FilledButton(
              onPressed: () async {
                final uri = Uri.parse(downloadUrl);
                bool opened = false;
                if (await canLaunchUrl(uri)) {
                  opened = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                }
                if (!opened) {
                  opened = await launchUrl(
                    uri,
                    mode: LaunchMode.platformDefault,
                  );
                }
                if (!opened) {
                  opened = await launchUrl(uri, mode: LaunchMode.inAppWebView);
                }
                if (mandatory) {
                  // Zorunlu güncellemede kullanıcıyı uygulamadan çıkar
                  if (!context.mounted) return;
                  Navigator.of(ctx).pop();
                  exit(0);
                } else {
                  if (!context.mounted) return;
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(l10n.updateNow),
            ),
          ],
        );
      },
    );
  }
}
