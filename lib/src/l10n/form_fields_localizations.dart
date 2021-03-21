
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'form_fields_localizations_en.dart';
import 'form_fields_localizations_lv.dart';

/// Callers can lookup localized strings with an instance of FormFieldsLocalizations returned
/// by `FormFieldsLocalizations.of(context)`.
///
/// Applications need to include `FormFieldsLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/form_fields_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FormFieldsLocalizations.localizationsDelegates,
///   supportedLocales: FormFieldsLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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
/// be consistent with the languages listed in the FormFieldsLocalizations.supportedLocales
/// property.
abstract class FormFieldsLocalizations {
  FormFieldsLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static FormFieldsLocalizations of(BuildContext context) {
    return Localizations.of<FormFieldsLocalizations>(context, FormFieldsLocalizations);
  }

  static const LocalizationsDelegate<FormFieldsLocalizations> delegate = _FormFieldsLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('lv')
  ];

  /// No description provided for @countryDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryDialogTitle;

  /// No description provided for @countryPickButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pick a country'**
  String get countryPickButtonTooltip;

  /// No description provided for @phoneCountryDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get phoneCountryDialogTitle;

  /// No description provided for @phoneCountryCodeButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pick a country code'**
  String get phoneCountryCodeButtonTooltip;
}

class _FormFieldsLocalizationsDelegate extends LocalizationsDelegate<FormFieldsLocalizations> {
  const _FormFieldsLocalizationsDelegate();

  @override
  Future<FormFieldsLocalizations> load(Locale locale) {
    return SynchronousFuture<FormFieldsLocalizations>(_lookupFormFieldsLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'lv'].contains(locale.languageCode);

  @override
  bool shouldReload(_FormFieldsLocalizationsDelegate old) => false;
}

FormFieldsLocalizations _lookupFormFieldsLocalizations(Locale locale) {
  


// Lookup logic when only language code is specified.
switch (locale.languageCode) {
  case 'en': return FormFieldsLocalizationsEn();
    case 'lv': return FormFieldsLocalizationsLv();
}


  throw FlutterError(
    'FormFieldsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
