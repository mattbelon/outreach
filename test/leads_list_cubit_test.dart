import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outreach_flutter/features/leads/data/csv_leads_importer.dart';
import 'package:outreach_flutter/features/leads/domain/lead.dart';
import 'package:outreach_flutter/features/leads/domain/leads_repository.dart';
import 'package:outreach_flutter/features/leads/presentation/leads_list/leads_list_cubit.dart';

void main() {
  group('LeadsListCubit', () {
    late _FakeLeadsRepository repository;
    late LeadsListCubit cubit;

    setUp(() {
      repository = _FakeLeadsRepository();
      cubit = LeadsListCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
      await repository.dispose();
    });

    test(
      'keeps selection across filtered results and exports selected ids',
      () async {
        repository.emitLeads([
          _lead(id: 1, companyName: 'Acme'),
          _lead(id: 2, companyName: 'Beta'),
        ]);
        cubit.initialize();
        await Future<void>.delayed(Duration.zero);

        cubit.toggleLeadSelection(_lead(id: 1, companyName: 'Acme'));
        repository.emitLeads([_lead(id: 2, companyName: 'Beta')]);
        await Future<void>.delayed(Duration.zero);

        final exportLeads = await cubit.getLeadsForExport();

        expect(cubit.state.selectedLeadIds, {1});
        expect(exportLeads.map((lead) => lead.id), [1]);
        expect(repository.lastGetLeadsByIds, [1]);
      },
    );

    test('debounces query updates before resubscribing', () {
      repository.emitLeads([_lead(id: 1, companyName: 'Acme')]);

      fakeAsync((async) {
        cubit.initialize();
        async.flushMicrotasks();

        cubit.setQuery('a');
        cubit.setQuery('ac');
        async.elapse(const Duration(milliseconds: 200));

        expect(repository.lastWatchedQuery, '');

        async.elapse(const Duration(milliseconds: 60));
        async.flushMicrotasks();

        expect(repository.lastWatchedQuery, 'ac');
      });
    });

    test('imports parsed csv using merge mode', () async {
      const parseResult = CsvLeadsImportParseResult(
        drafts: [
          LeadDraft(
            companyName: 'Acme',
            email: 'hello@acme.com',
            status: LeadStatus.pending,
          ),
        ],
        skippedEmptyRows: 1,
        rowErrors: <CsvLeadImportRowError>[],
      );

      final result = await cubit.importParsedCsv(
        parseResult,
        mode: LeadImportMode.mergeByEmail,
      );

      expect(result.importedCount, 1);
      expect(result.mode, LeadImportMode.mergeByEmail);
      expect(repository.lastImportMode, LeadImportMode.mergeByEmail);
      expect(cubit.state.lastImportResult?.mode, LeadImportMode.mergeByEmail);
    });
  });
}

class _FakeLeadsRepository implements LeadsRepository {
  final _controller = StreamController<List<Lead>>.broadcast();
  List<int>? lastGetLeadsByIds;
  String lastWatchedQuery = '';
  LeadStatus? lastWatchedStatus;
  LeadImportMode lastImportMode = LeadImportMode.insertOnly;

  void emitLeads(List<Lead> leads) {
    _controller.add(leads);
  }

  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  Future<void> deleteLead(int id) async {}

  @override
  Future<Lead?> getLeadById(int id) async {
    return _lead(id: id, companyName: 'Lead $id');
  }

  @override
  Future<List<Lead>> getLeadsByIds(List<int> ids) async {
    lastGetLeadsByIds = ids;
    return ids
        .map((id) => _lead(id: id, companyName: 'Lead $id'))
        .toList(growable: false);
  }

  @override
  Stream<List<LeadHistoryEntry>> watchLeadHistory(int leadId) {
    return const Stream<List<LeadHistoryEntry>>.empty();
  }

  @override
  Future<int> importLeads(
    List<LeadDraft> drafts, {
    LeadImportMode mode = LeadImportMode.insertOnly,
  }) async {
    lastImportMode = mode;
    return drafts.length;
  }

  @override
  Future<void> markAsSent(Lead lead) async {}

  @override
  Future<int> saveLead(LeadDraft draft, {int? id}) async {
    return id ?? 1;
  }

  @override
  Stream<List<Lead>> watchLeads({String query = '', LeadStatus? status}) {
    lastWatchedQuery = query;
    lastWatchedStatus = status;
    return _controller.stream;
  }
}

Lead _lead({required int id, required String companyName}) {
  return Lead(
    id: id,
    companyName: companyName,
    email: '$id@example.com',
    status: LeadStatus.pending,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}
