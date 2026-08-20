import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/portfolio/onjung_portfolio_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const OnjungPortfolioApp();
}
