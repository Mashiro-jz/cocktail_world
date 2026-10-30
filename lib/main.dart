import 'package:coctail_world/providers/cocktail_provider.dart';
import 'package:coctail_world/providers/favorites_provider.dart';
import 'package:coctail_world/screens/cocktail_screen.dart';
import 'package:coctail_world/providers/theme_provider.dart';
import 'package:coctail_world/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('pl'), Locale('en')],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('pl'),
      path: 'translate',
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (context) => CocktailProvider()..fetchCocktails(),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (context) => FavoritesProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => 'name'.tr(),
      theme: lightMode,
      darkTheme: darkMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const CoctailScreen(),
    );
  }
}
