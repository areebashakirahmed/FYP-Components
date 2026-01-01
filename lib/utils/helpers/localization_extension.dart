import 'package:flutter/widgets.dart';
import 'package:mehfilista/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
