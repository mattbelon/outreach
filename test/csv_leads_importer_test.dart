import 'package:flutter_test/flutter_test.dart';
import 'package:outreach_flutter/features/leads/data/csv_leads_importer.dart';
import 'package:outreach_flutter/features/leads/domain/lead.dart';

void main() {
  group('CsvLeadsImporter', () {
    final importer = CsvLeadsImporter();

    test('parses valid rows with outreach headers', () {
      const csv =
          '''company_name,contact_name,email,website,status,sent_at,replied_at,notes
Acme,John,hello@acme.com,https://acme.com,sent,2026-08-01,,First touch
Beta,,team@beta.com,,follow_up,,,Needs reply
''';

      final result = importer.parse(csv);
      final drafts = result.drafts;

      expect(drafts.length, 2);
      expect(drafts.first.companyName, 'Acme');
      expect(drafts.first.status, LeadStatus.sent);
      expect(drafts.last.status, LeadStatus.followUp);
      expect(result.skippedEmptyRows, 0);
      expect(result.rowErrors, isEmpty);
    });

    test('supports quoted commas in values', () {
      const csv = '''company_name,email,notes
"Acme, Inc",hello@acme.com,"Line with, comma"
''';

      final drafts = importer.parse(csv).drafts;

      expect(drafts.single.companyName, 'Acme, Inc');
      expect(drafts.single.notes, 'Line with, comma');
    });

    test('reports row errors and skipped empty rows', () {
      const csv = '''company_name,email,sent_at
Acme,hello@acme.com,2026-08-01

Broken,invalid-email,2026-08-02
Gamma,team@gamma.com,invalid-date
''';

      final result = importer.parse(csv);

      expect(result.drafts.length, 1);
      expect(result.skippedEmptyRows, 1);
      expect(result.rowErrors.length, 2);
      expect(result.rowErrors.first.rowNumber, 4);
      expect(result.rowErrors.last.rowNumber, 5);
    });

    test('throws when required headers are missing', () {
      const csv = 'name,site\nAcme,https://acme.com';

      expect(() => importer.parse(csv), throwsFormatException);
    });
  });
}
