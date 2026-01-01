import 'package:flutter/widgets.dart';
import 'package:mehfilista/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw FlutterError(
        'AppLocalizations not found. Make sure MaterialApp has localizationsDelegates configured.',
      );
    }
    return localizations;
  }
}
