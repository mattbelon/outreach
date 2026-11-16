import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/database/app_database.dart';
import '../features/leads/domain/leads_repository.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class OutreachApp extends StatefulWidget {
  const OutreachApp({
    required this.database,
    required this.leadsRepository,
    super.key,
  });

  final AppDatabase database;
  final LeadsRepository leadsRepository;

  @override
  State<OutreachApp> createState() => _OutreachAppState();
}

class _OutreachAppState extends State<OutreachApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(widget.leadsRepository);
  }

  @override
  void dispose() {
    widget.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LeadsRepository>.value(
      value: widget.leadsRepository,
      child: MaterialApp.router(
        title: 'Outreach',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('en')],
        routerConfig: _appRouter.router,
      ),
    );
  }
}
