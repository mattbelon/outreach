class Lead {
  const Lead({
    this.id,
    required this.companyName,
    required this.email,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.contactName,
    this.website,
    this.sentAt,
    this.repliedAt,
    this.notes,
  });

  final int? id;
  final String companyName;
  final String? contactName;
  final String email;
  final String? website;
  final LeadStatus status;
  final DateTime? sentAt;
  final DateTime? repliedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class LeadHistoryEntry {
  const LeadHistoryEntry({
    required this.id,
    required this.leadId,
    required this.action,
    required this.summary,
    required this.createdAt,
  });

  final int id;
  final int leadId;
  final LeadHistoryAction action;
  final String summary;
  final DateTime createdAt;
}

enum LeadStatus { pending, sent, replied, followUp, closed }

enum LeadHistoryAction { created, updated, markedSent, imported, deleted }

extension LeadHistoryActionX on LeadHistoryAction {
  String get label {
    switch (this) {
      case LeadHistoryAction.created:
        return 'Created';
      case LeadHistoryAction.updated:
        return 'Updated';
      case LeadHistoryAction.markedSent:
        return 'Marked sent';
      case LeadHistoryAction.imported:
        return 'Imported';
      case LeadHistoryAction.deleted:
        return 'Deleted';
    }
  }
}

extension LeadStatusX on LeadStatus {
  String get label {
    switch (this) {
      case LeadStatus.pending:
        return 'Pending';
      case LeadStatus.sent:
        return 'Sent';
      case LeadStatus.replied:
        return 'Replied';
      case LeadStatus.followUp:
        return 'Follow up';
      case LeadStatus.closed:
        return 'Closed';
    }
  }
}

class LeadDraft {
  const LeadDraft({
    required this.companyName,
    required this.email,
    required this.status,
    this.contactName,
    this.website,
    this.sentAt,
    this.repliedAt,
    this.notes,
  });

  final String companyName;
  final String? contactName;
  final String email;
  final String? website;
  final LeadStatus status;
  final DateTime? sentAt;
  final DateTime? repliedAt;
  final String? notes;

  bool get isValid =>
      companyName.trim().isNotEmpty && _isValidEmail(email.trim());

  static bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }
}
