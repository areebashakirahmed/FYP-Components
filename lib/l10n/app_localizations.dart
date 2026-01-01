import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'mehfilista'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to mehfilista'**
  String get welcome;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @getstarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getstarted;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, User!'**
  String get helloUser;

  /// No description provided for @onBoard1.
  ///
  /// In en, this message translates to:
  /// **'Let’s meet new\npeople around you'**
  String get onBoard1;

  /// No description provided for @onBoard2.
  ///
  /// In en, this message translates to:
  /// **'Let’s Meet mollit non deserunt\nsit aliqua dolor do amet sint.'**
  String get onBoard2;

  /// No description provided for @signupheading.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupheading;

  /// No description provided for @semail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get semail;

  /// No description provided for @spw.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get spw;

  /// No description provided for @scpw.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get scpw;

  /// No description provided for @regPolicy.
  ///
  /// In en, this message translates to:
  /// **'I accept all the '**
  String get regPolicy;

  /// No description provided for @regPolicy2.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get regPolicy2;

  /// No description provided for @regPolicy3.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get regPolicy3;

  /// No description provided for @signupbtn.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupbtn;

  /// No description provided for @pwmatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get pwmatch;

  /// No description provided for @swfb.
  ///
  /// In en, this message translates to:
  /// **'Signup with Facebook'**
  String get swfb;

  /// No description provided for @swg.
  ///
  /// In en, this message translates to:
  /// **'Signup with Google'**
  String get swg;

  /// No description provided for @swa.
  ///
  /// In en, this message translates to:
  /// **'Signup with Apple'**
  String get swa;

  /// No description provided for @alracc.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alracc;

  /// No description provided for @btmlog.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get btmlog;

  /// No description provided for @wcbk.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get wcbk;

  /// No description provided for @forgotpw.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotpw;

  /// No description provided for @lwfb.
  ///
  /// In en, this message translates to:
  /// **'Login with Facebook'**
  String get lwfb;

  /// No description provided for @lwg.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get lwg;

  /// No description provided for @lwa.
  ///
  /// In en, this message translates to:
  /// **'Login with Apple'**
  String get lwa;

  /// No description provided for @dontacc.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get dontacc;

  /// No description provided for @resetpw.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetpw;

  /// No description provided for @newpw.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newpw;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @forgotpw1.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotpw1;

  /// No description provided for @entermail.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated\nwith your account.'**
  String get entermail;

  /// No description provided for @verifyemail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyemail;

  /// No description provided for @fourdigit.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 4-digit code we\njust sent you to your email address'**
  String get fourdigit;

  /// No description provided for @resendcode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendcode;

  /// No description provided for @chooselanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooselanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
