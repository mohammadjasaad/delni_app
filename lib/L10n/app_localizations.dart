import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _localizedStrings = {
    'en': {
      'app_title': 'Delni Classifieds',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'my_ads': 'My Ads',
      'add_ad': 'Add Ad',
      'edit': 'Edit',
      'delete': 'Delete',
      'title': 'Title',
      'description': 'Description',
      'price': 'Price',
      'city': 'City',
      'category': 'Category',
    }, // ✅ هذه الفاصلة كانت ناقصة
    'ar': {
      'app_title': 'دلني للإعلانات',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'my_ads': 'إعلاناتي',
      'add_ad': 'إضافة إعلان',
      'edit': 'تعديل',
      'delete': 'حذف',
      'title': 'العنوان',
      'description': 'الوصف',
      'price': 'السعر',
      'city': 'المدينة',
      'category': 'التصنيف',
    }
  };

  String translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ??
        _localizedStrings['en']![key]!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
