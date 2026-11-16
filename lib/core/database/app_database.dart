import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/leads/domain/lead.dart';

part 'app_database.g.dart';

@DataClassName('LeadRecord')
class Leads extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get companyName => text()();

  TextColumn get contactName => text().nullable()();

  TextColumn get email => text()();

  TextColumn get website => text().nullable()();

  IntColumn get status => intEnum<LeadStatus>()();

  DateTimeColumn get sentAt => dateTime().nullable()();

  DateTimeColumn get repliedAt => dateTime().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('LeadHistoryRecord')
class LeadHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get leadId => integer()();

  IntColumn get action => intEnum<LeadHistoryAction>()();

  TextColumn get summary => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Leads, LeadHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _createIndexes();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await _createIndexes();
      }
      if (from < 3) {
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_leads_email ON leads (email)',
        );
      }
      if (from < 4) {
        await migrator.createTable(leadHistory);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_lead_history_lead_id ON lead_history (lead_id)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_lead_history_created_at ON lead_history (created_at DESC)',
        );
      }
    },
  );

  Future<LeadRecord?> getLeadRecordById(int id) {
    return (select(
      leads,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<LeadRecord>> getLeadRecordsByIds(List<int> ids) {
    if (ids.isEmpty) {
      return Future<List<LeadRecord>>.value(const <LeadRecord>[]);
    }

    return (select(leads)..where((table) => table.id.isIn(ids))).get();
  }

  Future<LeadRecord?> getLeadRecordByEmail(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    return (select(leads)
          ..where((table) => table.email.lower().equals(normalizedEmail)))
        .getSingleOrNull();
  }

  Stream<List<LeadHistoryRecord>> watchLeadHistoryRecords(int leadId) {
    return (select(leadHistory)
          ..where((table) => table.leadId.equals(leadId))
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .watch();
  }

  Stream<List<LeadRecord>> watchLeadRecords({
    String query = '',
    LeadStatus? status,
  }) {
    final statement = select(leads)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);

    if (status != null) {
      statement.where((table) => table.status.equalsValue(status));
    }

    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isNotEmpty) {
      statement.where(
        (table) =>
            table.companyName.lower().like('%$normalizedQuery%') |
            table.email.lower().like('%$normalizedQuery%'),
      );
    }

    return statement.watch();
  }

  Future<int> insertLead(LeadsCompanion companion) {
    return into(leads).insert(companion);
  }

  Future<bool> updateLeadRecord(LeadRecord record) {
    return update(leads).replace(record);
  }

  Future<int> deleteLeadById(int id) {
    return (delete(leads)..where((table) => table.id.equals(id))).go();
  }

  Future<int> insertLeadHistory(LeadHistoryCompanion companion) {
    return into(leadHistory).insert(companion);
  }

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_leads_status ON leads (status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_leads_sent_at ON leads (sent_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_leads_replied_at ON leads (replied_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_leads_updated_at ON leads (updated_at DESC)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_leads_email ON leads (email)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_lead_history_lead_id ON lead_history (lead_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_lead_history_created_at ON lead_history (created_at DESC)',
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    await directory.create(recursive: true);

    final file = File(p.join(directory.path, 'outreach.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
