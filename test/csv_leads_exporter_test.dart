import 'package:flutter_test/flutter_test.dart';
import 'package:outreach_flutter/features/leads/data/csv_leads_exporter.dart';
import 'package:outreach_flutter/features/leads/domain/lead.dart';

void main() {
  group('CsvLeadsExporter', () {
    final exporter = CsvLeadsExporter();

    test('builds outreach csv with header and rows', () {
      final csv = exporter.build([
        Lead(
          id: 1,
          companyName: 'Acme',
          contactName: 'John',
          email: 'hello@acme.com',
          website: 'https://acme.com',
          status: LeadStatus.sent,
          sentAt: DateTime(2026, 8, 1),
          repliedAt: null,
          notes: 'First touch',
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
      ]);

      expect(csv, contains('company_name,contact_name,email,website,status'));
      expect(csv, contains('Acme,John,hello@acme.com,https://acme.com,sent'));
      expect(csv, contains('2026-08-01'));
    });

    test('escapes commas and quotes', () {
      final csv = exporter.build([
        Lead(
          id: 1,
          companyName: 'Acme, Inc',
          contactName: 'John "JJ"',
          email: 'hello@acme.com',
          website: null,
          status: LeadStatus.pending,
          sentAt: null,
          repliedAt: null,
          notes: 'Needs, follow up',
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
      ]);

      expect(csv, contains('"Acme, Inc"'));
      expect(csv, contains('"John ""JJ"""'));
      expect(csv, contains('"Needs, follow up"'));
    });
  });
}
