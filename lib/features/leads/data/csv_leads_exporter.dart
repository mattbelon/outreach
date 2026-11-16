import '../domain/lead.dart';

class CsvLeadsExporter {
  String build(List<Lead> leads) {
    final buffer = StringBuffer(
      'company_name,contact_name,email,website,status,sent_at,replied_at,notes\n',
    );

    for (final lead in leads) {
      buffer.writeln(
        [
          lead.companyName,
          lead.contactName ?? '',
          lead.email,
          lead.website ?? '',
          _statusToCsv(lead.status),
          _formatDate(lead.sentAt),
          _formatDate(lead.repliedAt),
          lead.notes ?? '',
        ].map(_escape).join(','),
      );
    }

    return buffer.toString();
  }

  String _statusToCsv(LeadStatus status) {
    switch (status) {
      case LeadStatus.pending:
        return 'pending';
      case LeadStatus.sent:
        return 'sent';
      case LeadStatus.replied:
        return 'replied';
      case LeadStatus.followUp:
        return 'follow_up';
      case LeadStatus.closed:
        return 'closed';
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '';
    }

    return value.toIso8601String().split('T').first;
  }

  String _escape(String value) {
    final escaped = value.replaceAll('"', '""');
    if (escaped.contains(',') ||
        escaped.contains('"') ||
        escaped.contains('\n')) {
      return '"$escaped"';
    }

    return escaped;
  }
}
