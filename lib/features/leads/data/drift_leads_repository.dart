import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/lead.dart';
import '../domain/leads_repository.dart';

class DriftLeadsRepository implements LeadsRepository {
  const DriftLeadsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> deleteLead(int id) async {
    final existing = await _database.getLeadRecordById(id);
    if (existing != null) {
      await _insertHistory(
        leadId: id,
        action: LeadHistoryAction.deleted,
        summary: 'Deleted ${existing.companyName}',
      );
    }
    await _database.deleteLeadById(id);
  }

  @override
  Future<Lead?> getLeadById(int id) async {
    final record = await _database.getLeadRecordById(id);
    return record == null ? null : _mapRecord(record);
  }

  @override
  Future<List<Lead>> getLeadsByIds(List<int> ids) async {
    final records = await _database.getLeadRecordsByIds(ids);
    return records.map(_mapRecord).toList(growable: false);
  }

  @override
  Stream<List<LeadHistoryEntry>> watchLeadHistory(int leadId) {
    return _database
        .watchLeadHistoryRecords(leadId)
        .map(
          (records) => records
              .map(
                (record) => LeadHistoryEntry(
                  id: record.id,
                  leadId: record.leadId,
                  action: record.action,
                  summary: record.summary,
                  createdAt: record.createdAt,
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Future<int> importLeads(
    List<LeadDraft> drafts, {
    LeadImportMode mode = LeadImportMode.insertOnly,
  }) async {
    if (drafts.isEmpty) {
      return 0;
    }

    if (mode == LeadImportMode.insertOnly) {
      return _insertLeads(drafts);
    }

    return _mergeLeadsByEmail(drafts);
  }

  Future<int> _insertLeads(List<LeadDraft> drafts) async {
    final now = DateTime.now();

    for (final draft in drafts) {
      final leadId = await _database.insertLead(
        _buildCompanion(draft, now: now),
      );
      await _insertHistory(
        leadId: leadId,
        action: LeadHistoryAction.imported,
        summary: 'Imported ${draft.companyName.trim()} (${draft.email.trim()})',
      );
    }

    return drafts.length;
  }

  Future<int> _mergeLeadsByEmail(List<LeadDraft> drafts) async {
    var affectedRows = 0;

    for (final draft in drafts) {
      final existing = await _database.getLeadRecordByEmail(draft.email);
      await _saveLeadInternal(
        draft,
        id: existing?.id,
        historyAction: LeadHistoryAction.imported,
        historySummary: existing == null
            ? 'Imported ${draft.companyName.trim()} (${draft.email.trim()})'
            : 'Imported update for ${draft.companyName.trim()} (${draft.email.trim()})',
      );
      affectedRows++;
    }

    return affectedRows;
  }

  @override
  Future<void> markAsSent(Lead lead) {
    return _saveLeadInternal(
      LeadDraft(
        companyName: lead.companyName,
        contactName: lead.contactName,
        email: lead.email,
        website: lead.website,
        status: LeadStatus.sent,
        sentAt: lead.sentAt ?? DateTime.now(),
        repliedAt: lead.repliedAt,
        notes: lead.notes,
      ),
      id: lead.id,
      historyAction: LeadHistoryAction.markedSent,
      historySummary: 'Marked ${lead.companyName} as sent',
    );
  }

  @override
  Future<int> saveLead(LeadDraft draft, {int? id}) async {
    return _saveLeadInternal(draft, id: id);
  }

  Future<int> _saveLeadInternal(
    LeadDraft draft, {
    int? id,
    LeadHistoryAction? historyAction,
    String? historySummary,
  }) async {
    if (!draft.isValid) {
      throw const FormatException('Company and a valid email are required.');
    }

    final now = DateTime.now();
    final normalizedSentAt =
        draft.status == LeadStatus.sent && draft.sentAt == null
        ? now
        : draft.sentAt;

    if (id == null) {
      final leadId = await _database.insertLead(
        _buildCompanion(draft, now: now),
      );
      await _insertHistory(
        leadId: leadId,
        action: historyAction ?? LeadHistoryAction.created,
        summary:
            historySummary ??
            'Created ${draft.companyName.trim()} (${draft.email.trim()})',
      );
      return leadId;
    }

    final existing = await _database.getLeadRecordById(id);
    if (existing == null) {
      throw StateError('Lead $id was not found.');
    }

    await _database.updateLeadRecord(
      existing.copyWith(
        companyName: draft.companyName.trim(),
        contactName: Value(_trimToNull(draft.contactName)),
        email: draft.email.trim(),
        website: Value(_trimToNull(draft.website)),
        status: draft.status,
        sentAt: Value(normalizedSentAt),
        repliedAt: Value(draft.repliedAt),
        notes: Value(_trimToNull(draft.notes)),
        updatedAt: now,
      ),
    );

    await _insertHistory(
      leadId: id,
      action: historyAction ?? LeadHistoryAction.updated,
      summary: historySummary ?? _buildUpdateSummary(existing, draft),
    );

    return id;
  }

  @override
  Stream<List<Lead>> watchLeads({String query = '', LeadStatus? status}) {
    return _database
        .watchLeadRecords(query: query, status: status)
        .map((records) => records.map(_mapRecord).toList(growable: false));
  }

  Lead _mapRecord(LeadRecord record) {
    return Lead(
      id: record.id,
      companyName: record.companyName,
      contactName: record.contactName,
      email: record.email,
      website: record.website,
      status: record.status,
      sentAt: record.sentAt,
      repliedAt: record.repliedAt,
      notes: record.notes,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }

  String? _trimToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  LeadsCompanion _buildCompanion(LeadDraft draft, {required DateTime now}) {
    final normalizedSentAt =
        draft.status == LeadStatus.sent && draft.sentAt == null
        ? now
        : draft.sentAt;

    return LeadsCompanion.insert(
      companyName: draft.companyName.trim(),
      contactName: Value(_trimToNull(draft.contactName)),
      email: draft.email.trim(),
      website: Value(_trimToNull(draft.website)),
      status: draft.status,
      sentAt: Value(normalizedSentAt),
      repliedAt: Value(draft.repliedAt),
      notes: Value(_trimToNull(draft.notes)),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  Future<void> _insertHistory({
    required int leadId,
    required LeadHistoryAction action,
    required String summary,
  }) async {
    await _database.insertLeadHistory(
      LeadHistoryCompanion.insert(
        leadId: leadId,
        action: action,
        summary: summary,
      ),
    );
  }

  String _buildUpdateSummary(LeadRecord existing, LeadDraft draft) {
    final changes = <String>[];

    if (existing.companyName != draft.companyName.trim()) {
      changes.add('company');
    }
    if (existing.email != draft.email.trim()) {
      changes.add('email');
    }
    if (existing.status != draft.status) {
      changes.add('status');
    }
    if (existing.notes != _trimToNull(draft.notes)) {
      changes.add('notes');
    }

    if (changes.isEmpty) {
      return 'Updated ${draft.companyName.trim()}';
    }

    return 'Updated ${draft.companyName.trim()} (${changes.join(', ')})';
  }
}
