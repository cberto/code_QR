import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/pages/home_pages.dart';
import 'package:qrreaderapp/src/pages/mapa_page.dart';

import 'src/providers/scan_list_provider.dart';
import 'src/providers/ui_privider.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new UiProvider() ),
        ChangeNotifierProvider(create: (_) => new ScanListProvider() ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'home',
        routes: {
          'home': ( _ ) => HomePage(),
          'mapa': ( _ ) => MapaPage(),
        },
        //cambia el color del boton de theme
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple
          )
        ),
      ),
    );

  }
}