import 'lead.dart';

enum LeadImportMode { insertOnly, mergeByEmail }

abstract class LeadsRepository {
  Stream<List<Lead>> watchLeads({String query = '', LeadStatus? status});

  Future<Lead?> getLeadById(int id);

  Future<List<Lead>> getLeadsByIds(List<int> ids);

  Stream<List<LeadHistoryEntry>> watchLeadHistory(int leadId);

  Future<int> saveLead(LeadDraft draft, {int? id});

  Future<int> importLeads(
    List<LeadDraft> drafts, {
    LeadImportMode mode = LeadImportMode.insertOnly,
  });

  Future<void> deleteLead(int id);

  Future<void> markAsSent(Lead lead);
}
