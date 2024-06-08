
import 'package:crypto_currencies_list_app/router/router.dart';
import 'package:crypto_currencies_list_app/theme/theme.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoCurrenciesList',
      theme: darkTheme,
      routes: routes
    );
  }
}




