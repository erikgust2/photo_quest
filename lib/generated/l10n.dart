// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get _locale {
    return Intl.message(
      'en',
      name: '_locale',
      desc: '',
      args: [],
    );
  }

  /// `testEN`
  String get testText {
    return Intl.message(
      'testEN',
      name: 'testText',
      desc: '',
      args: [],
    );
  }

  /// `Quests`
  String get questLabel {
    return Intl.message(
      'Quests',
      name: 'questLabel',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get mapLabel {
    return Intl.message(
      'Map',
      name: 'mapLabel',
      desc: '',
      args: [],
    );
  }

  /// `Collections`
  String get collectionsLabel {
    return Intl.message(
      'Collections',
      name: 'collectionsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get availableLabel {
    return Intl.message(
      'Available',
      name: 'availableLabel',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completedLabel {
    return Intl.message(
      'Completed',
      name: 'completedLabel',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get discoverLabel {
    return Intl.message(
      'Discover',
      name: 'discoverLabel',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileLabel {
    return Intl.message(
      'Profile',
      name: 'profileLabel',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get languageLabel {
    return Intl.message(
      'Language',
      name: 'languageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Colors`
  String get colorsLabel {
    return Intl.message(
      'Colors',
      name: 'colorsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accountSettingsLabel {
    return Intl.message(
      'Account Settings',
      name: 'accountSettingsLabel',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get userAgreementLabel {
    return Intl.message(
      'User Agreement',
      name: 'userAgreementLabel',
      desc: '',
      args: [],
    );
  }

  /// `This is the center of the Profile Page`
  String get profilePlaceholder {
    return Intl.message(
      'This is the center of the Profile Page',
      name: 'profilePlaceholder',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'sv'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
