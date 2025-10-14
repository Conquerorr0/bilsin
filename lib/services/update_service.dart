import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const String keyLatestVersion = 'latest_version';
  static const String keyMinSupportedVersion = 'min_supported_version';
  static const String keyDownloadUrl = 'download_url';

  static Future<void> ensureInitialized() async {
    final rc = FirebaseRemoteConfig.instance;
    await rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await rc.setDefaults(const {
      keyLatestVersion: '1.1.0',
      keyMinSupportedVersion: '1.0.0',
      keyDownloadUrl: 'https://github.com/Conquerorr0/bilsin/releases/latest/download/app-release.apk',
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
        return AlertDialog(
          title: const Text('Güncelleme Mevcut'),
          content: Text(
            mandatory
                ? 'Uygulamanız eski bir sürüm kullanıyor (v$current). Devam etmek için lütfen en az v$latest sürümüne güncelleyin.'
                : 'Yeni bir sürüm mevcut (v$latest). Şu anki sürümünüz v$current. Güncellemek ister misiniz?',
          ),
          actions: [
            if (!mandatory)
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Daha Sonra'),
              ),
            FilledButton(
              onPressed: () async {
                final uri = Uri.parse(downloadUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
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
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }
}


