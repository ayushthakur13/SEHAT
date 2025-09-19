import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/services/app_router.dart';
import 'common/services/theme_service.dart';

void main() {
  runApp(const ProviderScope(child: SehatApp()));
}

class SehatApp extends ConsumerWidget {
  const SehatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'SEHAT',
      debugShowCheckedModeBanner: false,
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}