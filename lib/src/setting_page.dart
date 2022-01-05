import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif_picker/gif_picker.dart';

///
class SettingPage extends StatelessWidget {
  ///
  const SettingPage({
    Key? key,
    required this.settingNotifier,
  }) : super(key: key);

  ///
  final ValueNotifier<TenorSetting> settingNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: ValueListenableBuilder<TenorSetting>(
          valueListenable: settingNotifier,
          builder: (context, setting, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Locale
                Text('Locale', style: theme.textTheme.headline6),
                const SizedBox(height: 12),
                _Dropdown<Locale>(
                  items: _languageCodes,
                  currentValue: setting.locale,
                  labelBuilder: (locale) => locale.locale,
                  onChanged: (locale) {
                    settingNotifier.value = setting.copyWith(locale: locale);
                  },
                ),

                const SizedBox(height: 16),

                // Media filter (basic | minimal)
                Text('Media Filter', style: theme.textTheme.headline6),
                const SizedBox(height: 12),
                _Dropdown<TenorMediaFilter>(
                  items: TenorMediaFilter.values,
                  currentValue: setting.mediaFilter,
                  labelBuilder: (filter) => filter.name,
                  onChanged: (filter) {
                    settingNotifier.value =
                        setting.copyWith(mediaFilter: filter);
                  },
                ),

                const SizedBox(height: 16),

                // AR-Range (all | wide | standard)
                Text('Aspect Ratio Range', style: theme.textTheme.headline6),
                const SizedBox(height: 12),
                _Dropdown<TenorARRange>(
                  items: TenorARRange.values,
                  currentValue: setting.arRange,
                  labelBuilder: (arRange) => arRange.name,
                  onChanged: (arRange) {
                    settingNotifier.value = setting.copyWith(arRange: arRange);
                  },
                ),

                const SizedBox(height: 16),

                // Content filter [off | low | medium | high]
                Text('Content Filter', style: theme.textTheme.headline6),
                const SizedBox(height: 12),
                _Dropdown<TenorContentFilter>(
                  items: TenorContentFilter.values,
                  currentValue: setting.contentFilter,
                  labelBuilder: (filter) => filter.name,
                  onChanged: (filter) {
                    settingNotifier.value =
                        setting.copyWith(contentFilter: filter);
                  },
                ),

                const SizedBox(height: 16),

                // Limit
                Text('Limit', style: theme.textTheme.headline6),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: '${setting.limit}',
                      hintStyle: theme.textTheme.subtitle1?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    style: theme.textTheme.subtitle1?.copyWith(
                      color: scheme.primary,
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(2)],
                    onSubmitted: (text) {
                      final limit = int.tryParse(text);
                      if (limit != null) {
                        settingNotifier.value = setting.copyWith(limit: limit);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Set anonymous id
                Row(
                  children: [
                    Expanded(
                      child: Text('Anonymous ID',
                          style: theme.textTheme.headline6),
                    ),
                    CupertinoSwitch(
                      value: setting.createAnonymousId,
                      onChanged: (value) {
                        settingNotifier.value =
                            setting.copyWith(createAnonymousId: value);
                      },
                    ),
                  ],
                ),

                // Save setting button
                const SizedBox(height: 48),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      Navigator.of(context).pop(setting);
                    },
                  ),
                ),

                //
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    Key? key,
    required this.items,
    required this.currentValue,
    required this.labelBuilder,
    required this.onChanged,
  }) : super(key: key);

  final List<T> items;
  final T? currentValue;
  final String Function(T item) labelBuilder;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: currentValue,
        items: List.generate(items.length, (index) {
          final item = items[index];
          final isEven = index.isEven;
          final isSelected = currentValue == item;

          return DropdownMenuItem<T>(
            value: item,
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: isSelected
                  ? scheme.primary
                  : isEven
                      ? Colors.grey.shade200
                      : Colors.grey.shade300,
              child: Text(
                labelBuilder(item),
                style: theme.textTheme.subtitle1?.copyWith(
                  color: isSelected ? scheme.onPrimary : null,
                ),
              ),
            ),
          );
        }),
        selectedItemBuilder: (context) {
          return _languageCodes.map((e) {
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                currentValue == null
                    ? 'Choose Option'
                    // ignore: null_check_on_nullable_type_parameter
                    : labelBuilder(currentValue!),
                style:
                    theme.textTheme.subtitle1?.copyWith(color: scheme.primary),
              ),
            );
          }).toList();
        },
        onChanged: onChanged,
        isExpanded: true,
        dropdownColor: Colors.transparent,
        elevation: 0,
        menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
        icon: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(CupertinoIcons.chevron_down, size: 20),
        ),
        underline: const SizedBox(),
        style: TextStyle(color: scheme.primary),
      ),
    );
  }
}

///
@immutable
class Locale {
  ///
  const Locale({
    required this.language,
    required this.languageCode,
  });

  ///
  final String language;

  ///
  final String languageCode;

  ///
  String get locale => '$language - $languageCode';

  @override
  String toString() =>
      'Locale(languageCode: $language, languageCode: $languageCode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Locale &&
        other.language == language &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode => language.hashCode ^ languageCode.hashCode;
}

///
@immutable
class TenorSetting {
  ///
  const TenorSetting({
    this.locale = const Locale(languageCode: 'en', language: 'English'),
    this.mediaFilter = TenorMediaFilter.none,
    this.arRange = TenorARRange.all,
    this.contentFilter = TenorContentFilter.off,
    this.limit = 20,
    this.categoryType = TenorCategoryType.featured,
    this.createAnonymousId = true,
  });

  ///
  final Locale locale;

  ///
  final TenorMediaFilter mediaFilter;

  ///
  final TenorARRange arRange;

  ///
  final TenorContentFilter contentFilter;

  ///
  final int limit;

  ///
  final TenorCategoryType categoryType;

  ///
  final bool createAnonymousId;

  ///
  TenorSetting copyWith({
    Locale? locale,
    TenorMediaFilter? mediaFilter,
    TenorARRange? arRange,
    TenorContentFilter? contentFilter,
    int? limit,
    TenorCategoryType? categoryType,
    bool? createAnonymousId,
  }) {
    return TenorSetting(
      locale: locale ?? this.locale,
      mediaFilter: mediaFilter ?? this.mediaFilter,
      arRange: arRange ?? this.arRange,
      contentFilter: contentFilter ?? this.contentFilter,
      limit: limit ?? this.limit,
      categoryType: categoryType ?? this.categoryType,
      createAnonymousId: createAnonymousId ?? this.createAnonymousId,
    );
  }

  @override
  String toString() {
    return '''
    TenorSetting(
      locale: $locale, 
      mediaFilter: $mediaFilter, 
      arRange: $arRange, 
      contentFilter: $contentFilter, 
      limit: $limit, 
      categoryType: $categoryType,
      createAnonymousId: $createAnonymousId,
    )''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorSetting &&
        other.locale == locale &&
        other.mediaFilter == mediaFilter &&
        other.arRange == arRange &&
        other.contentFilter == contentFilter &&
        other.limit == limit &&
        other.categoryType == categoryType &&
        other.createAnonymousId == createAnonymousId;
  }

  @override
  int get hashCode {
    return locale.hashCode ^
        mediaFilter.hashCode ^
        arRange.hashCode ^
        contentFilter.hashCode ^
        limit.hashCode ^
        categoryType.hashCode ^
        createAnonymousId.hashCode;
  }
}

//
const _languageCodes = <Locale>[
  Locale(languageCode: 'en', language: 'English'),
  Locale(languageCode: 'fr', language: 'French'),
  Locale(languageCode: 'de', language: 'German'),
  Locale(languageCode: 'es', language: 'Spanish'),
  Locale(languageCode: 'it', language: 'Italian'),
  Locale(languageCode: 'ja', language: 'Japanese'),
  Locale(languageCode: 'ko', language: 'Korean'),
  Locale(languageCode: 'pt', language: 'Portuguese'),
  Locale(languageCode: 'ru', language: 'Russian'),
  Locale(languageCode: 'tr', language: 'Turkish'),
  Locale(languageCode: 'zh-TW', language: 'Traditional Chinese'),
  Locale(languageCode: 'zh-CN', language: 'Simplified Chinese'),
  Locale(languageCode: 'ar', language: 'Arabic'),
  Locale(languageCode: 'nl', language: 'Dutch'),
  Locale(languageCode: 'pl', language: 'Polish'),
  Locale(languageCode: 'sv', language: 'Swedish'),
  Locale(languageCode: 'th', language: 'Thai'),
  Locale(languageCode: 'vi', language: 'Vietnamese'),
  Locale(languageCode: 'sq', language: 'Albanian'),
  Locale(languageCode: 'sk', language: 'Slovak'),
  Locale(languageCode: 'hr', language: 'Croatian'),
  Locale(languageCode: 'cs', language: 'Czech'),
  Locale(languageCode: 'hu', language: 'Hungarian'),
  Locale(languageCode: 'ro', language: 'Romanian'),
  Locale(languageCode: 'el', language: 'Greek'),
  Locale(languageCode: 'id', language: 'Indonesian'),
  Locale(languageCode: 'ms', language: 'Malay'),
  Locale(languageCode: 'hi', language: 'Hindi'),
  Locale(languageCode: 'bn', language: 'Bengali'),
  Locale(languageCode: 'tl', language: 'Tagalog'),
  Locale(languageCode: 'ur', language: 'Urdu'),
  Locale(languageCode: 'fi', language: 'Finnish'),
  Locale(languageCode: 'uk', language: 'Ukrainian'),
  Locale(languageCode: 'da', language: 'Danish'),
  Locale(languageCode: 'he', language: 'Hebrew'),
  Locale(languageCode: 'yue', language: 'Cantonese'),
  Locale(languageCode: 'nn', language: 'Norwegian (Nynorsk)'),
  Locale(languageCode: 'nb', language: 'Norwegian (Bokmål)'),
  Locale(languageCode: 'ca', language: 'Catalan'),
  Locale(languageCode: 'fa', language: 'Farsi'),
];

///
extension TenorSettingX on TenorSetting {
  /// Trending query from the setting
  TenorTrendingQuery get trendingQuery => TenorTrendingQuery(
        locale: locale.languageCode,
        mediaFilter: mediaFilter,
        arRange: arRange,
        contentFilter: contentFilter,
        limit: limit,
      );

  /// Tenor categories query
  TenorCategoriesQuery get categoriesQuery => TenorCategoriesQuery(
        locale: locale.languageCode,
        contentFilter: contentFilter,
      );

  /// Tenor search query
  TenorSearchQuary get searchQuery => TenorSearchQuary(
        query: '',
        locale: locale.languageCode,
        mediaFilter: mediaFilter,
        arRange: arRange,
        contentFilter: contentFilter,
        limit: limit,
      );

  /// Tenor query
  TenorQuery get tenorQuery => TenorQuery(
        locale: locale.languageCode,
        limit: limit,
      );

  /// Tenor search suggestion query
  TenorSearchSuggestionsQuery get tenorSuggestionsQuery =>
      TenorSearchSuggestionsQuery(
        query: '',
        locale: locale.languageCode,
        limit: limit,
      );
}