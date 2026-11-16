import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';
import 'features/leads/data/drift_leads_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final leadsRepository = DriftLeadsRepository(database);

  runApp(OutreachApp(database: database, leadsRepository: leadsRepository));
}
