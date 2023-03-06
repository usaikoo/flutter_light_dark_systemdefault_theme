import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportnewsmyanmar/utils/constant.dart';
import 'package:sportnewsmyanmar/utils/themenotifier.dart';

enum Availability { loading, available, unavailable }

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _selectedPosition = 0;
  var isDarkTheme;
  List themes = Constants.themes;
  SharedPreferences? prefs;
  ThemeNotifier? themeNotifier;
  String output = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSavedTheme();
    });
  }

  _getSavedTheme() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPosition = themes.indexOf(
          prefs?.getString(Constants.APP_THEME) ?? Constants.SYSTEM_DEFAULT);
    });
  }

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.light_mode),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, position) {
                          return _createList(
                              context, themes[position], position);
                        },
                        itemCount: themes.length,
                      ),
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // ListTile(
            //   leading: Icon(Icons.info),
            //   onTap: () async {
            //     if (await canLaunch("#")) {
            //       await launch("#");
            //     }
            //   },
            //   title: Text('Join Telegram', style: TextStyle()),
            // ),
          ],
        ),
      ),
    );
  }

  void log(String message) {
    if (message != null) {
      setState(() {
        output = message;
      });
      print(message);
    }
  }

  _createList(context, item, position) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        _updateState(position);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Radio(
            value: _selectedPosition,
            groupValue: position,
            activeColor: isDarkTheme ? Colors.green : Colors.black,
            onChanged: (_) {
              _updateState(position);
            },
          ),
          Text(item),
        ],
      ),
    );
  }

  _updateState(int position) {
    setState(() {
      _selectedPosition = position;
    });
    onThemeChanged(themes[position]);
  }

  void onThemeChanged(String value) async {
    var prefs = await SharedPreferences.getInstance();
    if (value == Constants.SYSTEM_DEFAULT) {
      themeNotifier!.setThemeMode(ThemeMode.system);
    } else if (value == Constants.DARK) {
      themeNotifier!.setThemeMode(ThemeMode.dark);
    } else {
      themeNotifier!.setThemeMode(ThemeMode.light);
    }
    prefs.setString(Constants.APP_THEME, value);
  }
}
