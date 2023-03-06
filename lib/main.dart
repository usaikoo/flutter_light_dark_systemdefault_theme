import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportnewsmyanmar/page/home_page.dart';
import 'package:sportnewsmyanmar/provider/theme_provider.dart';
import 'package:sportnewsmyanmar/page/setting.dart';
import 'package:sportnewsmyanmar/utils/constant.dart';
import 'package:sportnewsmyanmar/utils/themenotifier.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((value) {
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) {
          String? theme = value.getString(Constants.APP_THEME);
          if (theme == null ||
              theme == "" ||
              theme == Constants.SYSTEM_DEFAULT) {
            value.setString(Constants.APP_THEME, Constants.SYSTEM_DEFAULT);
            return ThemeNotifier(ThemeMode.system);
          }
          return ThemeNotifier(
              theme == Constants.DARK ? ThemeMode.dark : ThemeMode.light);
        },
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  static const String title = 'Light , Dark & System Default';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeNotifier = Provider.of<ThemeNotifier>(context);

          return MaterialApp(
            title: title,
            themeMode: themeNotifier.getThemeMode(),
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: HomePage(),
          );
        },
      );
}
